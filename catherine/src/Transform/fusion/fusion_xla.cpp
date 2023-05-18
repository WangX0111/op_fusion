#include <memory>
#include <set>
#include <string>
#include <vector>
#include <mutex>

// #include "lhlo/IR/lhlo_ops.h"
#include "llvm/ADT/EquivalenceClasses.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
// #include "mlir/disc/transforms/lhlo_elemental_utils.h"
// #include "mlir/disc/transforms/shape_utils.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Shape/IR/Shape.h"  // TF:llvm-project
#include "mlir/IR/MLIRContext.h"          // TF:llvm-project
#include "mlir/IR/Matchers.h"
#include "mlir/Pass/Pass.h"               // TF:local_config_mlir
#include "mlir/Transforms/RegionUtils.h"  // TF:llvm-project
// #include "mlir/disc/IR/lhlo_disc_ops.h"
// #include "mlir/disc/disc_util.h"
// #include "mlir/disc/transforms/PassDetail.h"
// #include "mlir/disc/transforms/disc_shape_optimization_utils.h"
// #include "mlir/disc/transforms/fusion_utils.h"
// #include "mlir/disc/transforms/placement_utils.h"
// #include "mlir/disc/transforms/shape_utils.h"
#include "src/Utils/cycle_detector.h"
// #include "tensorflow/core/util/env_var.h"

#define DEBUG_TYPE "disc-fusion-utils"


//This pass has similar functionality of the fusion pass in XLA stack.
//During conversion, it tries to greedily find kLoop/kInput fusion patterns.

namespace mlir{
namespace catherine{

using namespace std;
using llvm::EquivalenceClasses;


namespace {
int max_num_arguments_per_kernel = 64;

// -------------------Disc utils 

bool IsOpWriteValue(Operation* op, Value value) {
  llvm::SmallVector<mlir::MemoryEffects::EffectInstance, 2> effects;
  MemoryEffectOpInterface interface = dyn_cast<MemoryEffectOpInterface>(op);
  // Suppose that value without `MemoryEffectOpInterface` is readonly.
  if (!interface) return false;

  interface.getEffectsOnValue(value, effects);
  return llvm::any_of(
      effects, [](const mlir::MemoryEffects::EffectInstance& instance) {
        return mlir::isa<mlir::MemoryEffects::Write>(instance.getEffect());
      });
}

// -------------------Shape Utils
class ShapeAnalysis {
 public:
  virtual ~ShapeAnalysis() = default;

  virtual bool isShapeEqual(Value lhs, Value rhs) = 0;

  virtual bool isProductEqual(Value lhs, ArrayRef<int> lhsDimIdxs, Value rhs,
                              ArrayRef<int> rhsDimIdxs) = 0;

  virtual bool isProductEqual(Value lhs, int lhsFrom, int lhsTo, Value rhs,
                              int rhsFrom, int rhsTo);

  virtual bool isSameNumElements(Value lhs, Value rhs);
};

// --------------------FUsion utils



enum FusionType {
  kNone,
  kLoop,
  kRowReduction,
  kColReduction,
  kInput,
  kStitch,
  kLargeConcat,
  kDot,
  kWhere,
  kTransform,
  kSparseReduction,
};

StringRef fusionTypeToString(FusionType ft){return "base";};

struct TileInfo {
  // Maps axis -> tile_size along this axis.
  // select all the elements along the axis if tile_size ==
  // ShapedType::kDynamic
  DenseMap<int64_t, int64_t> tileSizes;

  // Returns false if failed to merge.
  bool merge(TileInfo& other){
	for (auto&& e : other.tileSizes) {
    if (!merge(e.first, e.second)) return false;
  }
  return true;
	}

  // Returns false if failed to merge.
  bool merge(int64_t axis, int64_t tileSize = ShapedType::kDynamic){
		auto it = tileSizes.find(axis);
		if (it == tileSizes.end()) {
			tileSizes[axis] = tileSize;
			return true;
		}

		int64_t minSize = std::min(it->second, tileSize);
		int64_t maxSize = std::max(it->second, tileSize);
		if (minSize == ShapedType::kDynamic) {
			it->second = ShapedType::kDynamic;
			return true;
		}

		if (minSize == 0 || maxSize % minSize != 0) return false;
		it->second = maxSize;
		return true;
	}

  // return true if updated.
  bool updateIfNotEqual(TileInfo& other){
		if (other.tileSizes == tileSizes) return false;
		tileSizes = other.tileSizes;
		return true;
	}
};

class FusionPatternBase {
 public:
  using FusionOpList = SmallVector<Operation*, 4>;
  using FusionValueList = SmallVector<Value, 4>;

  // Create a new fusion pattern from a single op.
  explicit FusionPatternBase(Operation* op){
		op_list_.push_back(op);
		calculateOperandsAndResults();
	}

	explicit FusionPatternBase(SmallVectorImpl<Operation*>& op_list) : op_list_(op_list.begin(), op_list.end()){
		calculateOperandsAndResults();
	}

  FusionOpList& getOpList() { return op_list_; }

  FusionValueList& getOperands() { return operands_; }

  FusionValueList& getResults() { return results_; }

  SmallVector<Operation*, 4>& getRootOps() { return root_ops_; }


  FusionValueList& getInternalResults() { return internal_results_; }

  FusionValueList& getExternalOnlyResults() { return external_only_results_; }

  DenseMap<Value, Operation*>& getLastWriter() { return last_writer_; }

  int size() { return op_list_.size(); }

  int effectiveSize(){
		return llvm::count_if(
      op_list_, [](Operation* op) { return 0; });
	}

  void sortFusionOpListBy(DenseMap<Operation*, int>& op_to_idx){
		std::sort(op_list_.begin(), op_list_.end(),
            [&](Operation* lhs, Operation* rhs) {
              return op_to_idx[lhs] < op_to_idx[rhs];
            });
	}

  void sortFusionOpListWithTopologyOrder(){
		// wangx
	}

  Operation* findLastWriter(Value value) {
    auto it = last_writer_.find(value);
    if (it != last_writer_.end()) {
      return it->second;
    }
    return value.getDefiningOp();
  }

  void updateLastWriter(Value value, Operation* op) {
    last_writer_[value] = op;
  }

  bool alreadyInRootOps(Operation* new_op) {
    for (Operation* op : root_ops_) {
      if (new_op == op) {
        return true;
      }
    }
    return false;
  }

 protected:
  // Calculates the inputs and outputs of the fusion pattern.
  void calculateOperandsAndResults(){
		// wangx 
	}

  FusionOpList op_list_;
  FusionValueList operands_;
  FusionValueList results_;
  FusionValueList internal_results_;
  FusionValueList external_only_results_;
  SmallVector<Operation*, 4> root_ops_;
  DenseMap<Value, Operation*> last_writer_;
};

class FusionPattern : public FusionPatternBase {
 public:
  // Create a new fusion pattern from a single op.
  explicit FusionPattern(Operation* op) : FusionPatternBase(op){
		fusion_type_ = FusionType::kNone;
    dominant_op_ = op;
	}

//   explicit FusionPattern(lmhlo::FusionOp op, ShapeAnalysis* shape_analysis);
  // explicit FusionPattern(Operation* op, ShapeAnalysis* shape_analysis){};

  Operation* getDominantOp() { return dominant_op_; }

  void setDominantOp(Operation* op) { dominant_op_ = op; }

  FusionType getFusionType() { return fusion_type_; }

  StringRef getFusionTypeStr() { return fusionTypeToString(fusion_type_); }

  void setFusionType(FusionType type) { fusion_type_ = type; }

  bool isFusible() { return getFusionType() != FusionType::kNone; }

  bool isKLoopFusion() { return getFusionType() == FusionType::kLoop; }

  bool isKInputFusion() {
    return (getFusionType() == FusionType::kRowReduction ||
            getFusionType() == FusionType::kColReduction);
  }

  bool isStitchFusion() { return getFusionType() == FusionType::kStitch; }

  bool isTransformBasedFusion() {
    return getFusionType() == FusionType::kTransform;
  }

  // Merges two fusion patterns and returns the merged pattern. The original
  // pattern remains unmodified. The new merged pattern is uninitialized.
  FusionPattern mergeWithoutInit(FusionPattern& other){
		FusionOpList new_op_list = getOpList();
		new_op_list.insert(new_op_list.end(), other.getOpList().begin(),
											other.getOpList().end());
		FusionPattern new_fusion_pattern{new_op_list};
		return new_fusion_pattern;
	}

  // Create a new fusion pattern with the given op list, without init.
  static FusionPattern createWithoutInit(SmallVectorImpl<Operation*>& op_list){
		return FusionPattern(op_list);
	}

  DenseMap<Value, TileInfo>& getTilePlan() { return tile_plan_; }
  void setTilePlan(const DenseMap<Value, TileInfo>& tile_plan) {
    tile_plan_ = tile_plan;
  }

  SmallVector<Operation*, 4>& getSubRootOps() { return sub_root_ops_; }

  void setSubRootOps(const SmallVector<Operation*, 4>& sub_root_ops) {
    sub_root_ops_ = sub_root_ops;
  }

 private:
  // Create a new fusion pattern with the ops inside the list.
  explicit FusionPattern(SmallVectorImpl<Operation*>& op_list) : FusionPatternBase(op_list){
		fusion_type_ = FusionType::kNone;
		dominant_op_ = (size() == 0 ? nullptr : getOpList()[0]);
	}

  Operation* dominant_op_ = nullptr;
  FusionType fusion_type_ = FusionType::kNone;
  SmallVector<Operation*, 4> sub_root_ops_;
  DenseMap<Value, TileInfo> tile_plan_;
};

struct FusionOptions {
  // Maximum allowed number of arguments per fused kernel. Here arguments
  // include both read-only buffers and writable buffers.
  int max_num_arguments_per_kernel = 64;
};

namespace {
// global fusion options
std::mutex fusionOptionsMu;
FusionOptions fusionOptions;
}  // namespace

void setGlobalFusionOptions(const FusionOptions& options) {
  std::lock_guard<std::mutex> lock(fusionOptionsMu);
  fusionOptions = options;
}

// Returns the global fusion options.
const FusionOptions& getGlobalFusionOptions() {
  std::lock_guard<std::mutex> lock(fusionOptionsMu);
  return fusionOptions;
}
class FusionStrategy {
 public:
	FusionStrategy(const FusionOptions& options) : options_(options) {	}

  virtual bool isFusible(Operation* op){return false;};
  virtual bool isFusible(FusionPattern& fusion_pattern){return false;};
  virtual bool initFusionPattern(ShapeAnalysis& shapeAnalysis,
                                 FusionPattern& fusion_pattern) = 0;
  virtual bool pruneFusionPattern(ShapeAnalysis& shapeAnalysis,
                                  FusionPattern& fusion_pattern,
                                  SmallVectorImpl<Operation*>& excluded_ops){return false;};
  virtual bool tryFuseInplace(ShapeAnalysis& shapeAnalysis, FusionPattern& lhs,
                              FusionPattern& rhs){return false;};
  virtual bool tryFuse(ShapeAnalysis& shapeAnalysis, FusionPattern& lhs,
                       FusionPattern& rhs, FusionPattern& target){return false;};
  virtual StringRef getName() { return "FusionStrategy"; }

 protected:
  FusionOptions options_;
};

class BaseFusionStrategy : public FusionStrategy {
 public:
  using FusionStrategy::FusionStrategy;
	// BaseFusionStrategy(const FusionOptions& options) : FusionStrategy(options){
	// 	llvm::outs() << "1" << "\n";
	// }

  bool isFusible(Operation* op) {return true;}
	bool isFusible(FusionPattern& fusion_pattern) {return true;};
  bool initFusionPattern(ShapeAnalysis& shapeAnalysis,
                         FusionPattern& fusion_pattern) {return true;}
	 bool pruneFusionPattern(
      ShapeAnalysis& shapeAnalysis, FusionPattern& fusion_pattern,
      SmallVectorImpl<Operation*>& excluded_ops) { return true;}
	 bool tryFuseInplace(ShapeAnalysis& shapeAnalysis, FusionPattern& lhs,
                              FusionPattern& rhs){return true;}
  bool tryFuse(ShapeAnalysis& shapeAnalysis, FusionPattern& lhs,
               FusionPattern& rhs, FusionPattern& target) {return true;}
   StringRef getName()  { return "BaseFusionStrategy"; }

 protected:
   bool checkSameShape(FusionPattern& lhs, FusionPattern& rhs,
                              FusionPattern& target) {
    return false;
  }
};

// Represents a list of disjoint fusion patterns for a block.
using FusionPlan = std::vector<FusionPattern>;

// ------------------------

using FusionPipeline = SmallVector<unique_ptr<FusionStrategy>>;

class FusionPlanner {
public:
  explicit FusionPlanner(FusionPipeline& pipeline, Block* block,
                         ShapeAnalysis* shapeAnalysis)
        :   fusionPipeline_(pipeline),
            block_(block),
						shape_analysis_(shapeAnalysis){
    assert(!fusionPipeline_.empty());
    assert(block_ != nullptr);
    // assert(shape_analysis_ != nullptr);
    currentFusionStrategy_ = fusionPipeline_[0].get();
    MoveUpMetadataOnlyOpsForFusion();
    for (Operation& op : *block) {
      op_list_.push_back(&op);
    }
    cycle_detector_.reset(new GraphCycles((int32_t)op_list_.size()));
    original_graph_with_explicit_edges_.reset(new GraphCycles(op_list_.size()));
    BuildNodeMap();
    }

    void dumpCluster() {
        llvm::dbgs() << "Fusion result:\n";
        DenseSet<Cluster*> seen_clusters;
        for (Operation* op : op_list_) {
        Cluster* cluster = GetClusterForNode(op);
        if (!seen_clusters.insert(cluster).second) continue;
        FusionPattern& fusion_pattern = cluster->fused_pattern();
        llvm::dbgs() << "  Cluster #" << seen_clusters.size() << "@"
                    << fusion_pattern.getFusionTypeStr() << "\n";
        for (Operation* subOp : fusion_pattern.getOpList()) {
            llvm::dbgs() << "    " << *subOp << "\n";
        }
        }
    }

  // Returns a fusion plan if success, otherwise none.
    llvm::Optional<FusionPlan> Run() {
      llvm::outs() << "fusion plan run"<<"\n";
        // Greedily search connected fusible pattern, and ops belonging to
        // a same fusion pattern are grouped into a cluster.
        for (auto& strategy : fusionPipeline_) {
        currentFusionStrategy_ = strategy.get();
        // Re-init non-fusible fusion pattern using the given fusion strategy
        // since different fusion strategy may support different set of ops.
        initFusionPatterns();
        RunEdgeContractionLoop();
        if (!RunFusionPatternFinalization()) {
            return llvm::None;
        }
        LLVM_DEBUG(dumpCluster());
        }

        // After doing edge contraction, each unique cluster having size
        // more than one represents a potential fusion pattern.
        // We collect all these clusters and construct a fusion plan.
        FusionPlan plan;
        DenseSet<Cluster*> seen_clusters;
        for (Operation* op : op_list_) {
        Cluster* cluster = GetClusterForNode(op);
        if (!seen_clusters.insert(cluster).second) continue;
				
				// wangx

        // FusionPattern& fusion_pattern = cluster->fused_pattern();
        // Make sure the ops in a fusion pattern are in topological ordering.
        // fusion_pattern.sortFusionOpListBy(op_to_node_id_);
        // if (!fusion_pattern.isFusible() || fusion_pattern.effectiveSize() < 1 ||
        //     !fusion_pattern.isTransformBasedFusion() &&
        //         fusion_pattern.effectiveSize() == 1) {
        //     continue;
        // }
        // plan.emplace_back(fusion_pattern);
        }

        // Re-order ops inside the blocks to make sure all producers are placed
        // before its consumers after fusion.
        ReorderOperationsInsideBlock();
        return plan;
  }

	const SmallVectorImpl<Operation*>& op_list() const { return op_list_; }

  FusionStrategy& getFusionStrategy() { return *currentFusionStrategy_; }

private:
	class Cluster {
   public:
    Cluster(int node_id, FusionPlanner* planner)
        : node_id_(node_id), pattern_(planner->op_list()[node_id]) {}

    Cluster(int node_id, FusionPattern& fusion_pattern)
        : node_id_(node_id), pattern_(fusion_pattern) {}

    // The number of nodes in this cluster.
    int cluster_size() { return pattern_.size(); }

    // The ID of the cluster as represented in `cycle_detector_`.
    int cycles_graph_node_id() const { return node_id_; }

    // Sets the ID of the cluster as represented in `cycle_detector_`.
    void set_cycles_graph_node_id(int cycles_graph_node_id) {
      node_id_ = cycles_graph_node_id;
    }

    // Currently the fused pattern this cluster holds.
    FusionPattern& fused_pattern() { return pattern_; }

   private:
    // ID of the representative node of this cluster.
    int node_id_;

    // the fused pattern this cluster holds.
    FusionPattern pattern_;
  };

private:
	Cluster* MakeCluster(int cycles_graph_node_id) {
    cluster_storage_.emplace_back(new Cluster(cycles_graph_node_id, this));
    getFusionStrategy().initFusionPattern(
        *shape_analysis_, cluster_storage_.back()->fused_pattern());
    return cluster_storage_.back().get();
  }

	void initFusionPatterns() {
    llvm::outs() << "initFusionPatterns"<<"\n";
    for (int32_t node : cycle_detector_->AllNodesInPostOrder()) {
      Cluster* cluster = GetClusterForCyclesGraphNode(node);
      FusionPattern& pattern = cluster->fused_pattern();
      if (pattern.isFusible()) continue;
      getFusionStrategy().initFusionPattern(*shape_analysis_, pattern);
    }
  }
	
	void MoveUpMetadataOnlyOpsForFusion() {}

	SmallVector<Value, 4> GetAllPossibleUsedValues(Operation* op) {
    SmallVector<Value, 4> values;
    op->walk([&](Operation* nest_op) {
      for (Value v : nest_op->getOperands()) {
        values.push_back(v);
      }
    });
    return values;
  }

	void BuildNodeMap() {
    int num_nodes = op_list_.size();
    for (int node_id = 0; node_id < num_nodes; ++node_id) {
      Operation* op = op_list_[node_id];
      MakeCluster(node_id);
      op_to_node_id_[op] = node_id;
      leader_for_node_.insert(node_id);
      for (Value operand : GetAllPossibleUsedValues(op)) {
        Operation* operand_op = FindLastWriter(operand);
        // Only consider the operand_op inside the target block.
        auto iter = op_to_node_id_.find(operand_op);
        if (iter == op_to_node_id_.end()) {
          continue;
        }
        // Add an edge to connect the last writer and the current consumer.
        cycle_detector_->InsertEdge(iter->second, node_id);
        original_graph_with_explicit_edges_->InsertEdge(iter->second, node_id);
      }
				// wangx
        // If an op is not in lmhlo or lmhlo_disc dialect, it may be written
        // multiple times (e.g. multiple memref.store ops for the same
        // underlying buffer).
        for (Value v : op->getOperands()) {
          if (!IsOpWriteValue(op, v)) continue;
          last_writer_[v] = op;
        }
      
    }
  }

	Cluster* GetClusterForNode(Operation* n) {
    int id = op_to_node_id_[n];
    id = leader_for_node_.getLeaderValue(id);
    return cluster_storage_[id].get();
  }

	Cluster* GetClusterForCyclesGraphNode(int node_id) {
    return cluster_storage_[leader_for_node_.getLeaderValue(node_id)].get();
  }

  using FnTy = llvm::function_ref<bool(Cluster*, Cluster*)>;
	bool ForEachEdgeInPostOrder(FnTy fn, bool enable_cross_fusion = false) {
		//wangx
	}

	bool TryToContractEdge(Cluster* cluster_from, Cluster* cluster_to) {
		//wangx
	}

	// Greedily fuse connected node.
  bool RunEdgeContractionLoop() {
		// wangx
	}

	int32_t reContractEdges(FusionPattern& fusion_pattern,
                          DenseMap<int32_t, DenseSet<int32_t>>& producers_map,
                          GraphCycles* cycle_detector,
                          EquivalenceClasses<int32_t>& leader_for_node) {
		// wangx
		return -1;
	}

	bool RunFusionPatternFinalization() {
		//wangx 
	}

	Operation* FindLastWriter(Value value) {
    auto it = last_writer_.find(value);
    if (it != last_writer_.end()) {
      return it->second;
    }
    return value.getDefiningOp();
  }

	void ReorderOperationsInsideBlock() {
		// wangx
	}

private:
  FusionPipeline& fusionPipeline_;
  FusionStrategy* currentFusionStrategy_;
  Block* block_;
  SmallVector<Operation*, 4> op_list_;
  ShapeAnalysis* shape_analysis_;
  DenseMap<Operation*, int> op_to_node_id_;
  std::unique_ptr<GraphCycles> cycle_detector_;
  std::vector<std::unique_ptr<Cluster>> cluster_storage_;

  std::unique_ptr<GraphCycles> original_graph_with_explicit_edges_;

  EquivalenceClasses<int32_t> leader_for_node_;

  DenseMap<Value, Operation*> last_writer_;

};


class DiscFusionPass 
    : public PassWrapper<DiscFusionPass,  OperationPass<::mlir::func::FuncOp>>  {

// class DiscFusionPass : public ::mlir::catherine::impl::DiscFusionPassBase<DiscFusionPass> {
private:
	bool gpu_enabled_;
	std::string fusion_strategy_;
public:
	MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(DiscFusionPass)
	StringRef getArgument() const final { return "disc-fusion-pass"; }
	StringRef getDescription() const final { return "Fusion Pass."; }
  DiscFusionPass() = default;

  // using DiscFusionPassBase<DiscFusionPass>::DiscFusionPassBase;
  explicit DiscFusionPass(bool gpu_enabled, const std::string& fusion_strategy)
  {
    this->gpu_enabled_ = gpu_enabled;
    this->fusion_strategy_ = fusion_strategy;
  }

  FusionPipeline makeFusionPipeline() {
    FusionPipeline pipeline;
		auto& options = getGlobalFusionOptions();
    if (fusion_strategy_ == "base") {
      llvm::outs() << "fusion_strategy_ == base";
			pipeline.emplace_back(
				std::make_unique<BaseFusionStrategy>(options)
			);
    } 
		// wangx
    return pipeline;
  }

  void runOnOperation() override {
    llvm::outs()<<"xla fusion start:"<< "\n";

    func::FuncOp func = getOperation();

    // skip shape constraint graph
		llvm::outs() << func.getName();

    // collect all blocks inside the function.
    SmallVector<Block*, 4> blocks;
    CollectBlocksInsideFunction(func, blocks);

		for(auto block : blocks){
			// block->printAsOperand(llvm::outs());
			// block->dump();
		}

		std::unique_ptr<ShapeAnalysis> shapeAnalysisPtr;

		FusionPipeline pipeline = makeFusionPipeline();
    int64_t fusion_pattern_number = 0;

		for (Block* block : blocks) {
			block->dump();
      FusionPlanner planner(pipeline, block, shapeAnalysisPtr.get());
      llvm::Optional<FusionPlan> plan = planner.Run();
      if (!plan) {
        emitError(func.getLoc(),
                  "an error occurs while trying to find fusion candidates");
        signalPassFailure();
        return;
      }
      fusion_pattern_number += plan->size();
      if (!ApplyFusionPlan(*plan)) {
        emitError(func.getLoc(), "apply fusion plan failed");
        signalPassFailure();
        return;
      }
    }

		llvm::outs() << "end" << "\n";
    
  }

  bool ApplyFusionPlan(FusionPlan& plan) {
    return true;
  }

  void CollectBlocksInsideFunction(func::FuncOp op,
                                   SmallVectorImpl<Block*>& blocks) {
    op.walk([&](Block* block) {
      // It does not make sense to fuse the region attached to these ops.
      if (block->getParentOp())
        blocks.push_back(block);
    });
  }

 private:
  int64_t applied_fusion_numbers_ = 0;
  int64_t disc_debug_max_fusion_number_;
};

} //namespace

std::unique_ptr<OperationPass<func::FuncOp>> 
createDiscFusionPass(
    bool gpu_enabled,  const std::string& fusion_strategy) {
  return std::make_unique<DiscFusionPass>(gpu_enabled, fusion_strategy);
}

}
}