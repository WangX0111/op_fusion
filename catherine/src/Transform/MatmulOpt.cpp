// =============================================================================
//
// 该文件实现了一个基于BLIS的matmul优化。
//===----------------------------------------------------------------------===//

// #include "PassDetail.h"

#include "mlir/Dialect/Affine/Analysis/AffineAnalysis.h"
#include "mlir/Dialect/Affine/Analysis/Utils.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/Utils.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/IR/BlockAndValueMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Dialect/Affine/LoopUtils.h"
#include "mlir/Transforms/Passes.h"
#include "llvm/Support/Debug.h"
#include <mlir/Dialect/Func/IR/FuncOps.h>
#include <mlir/Dialect/Linalg/Transforms/Transforms.h>
#include <mlir/IR/Dialect.h>
#include <mlir/IR/Operation.h>
#include <mlir/IR/TypeUtilities.h>
#include <mlir/IR/Value.h>
#include "Blis/BlisOps.h"
// #include "Passes.h.inc"

#include <algorithm>
#include <sstream>
#include <unordered_map>

#define DEBUG_TYPE "hopt"

using namespace mlir;
using namespace catherine;


namespace{

class MatmulOpt : public OpRewritePattern<catherine::blis::BlisMatmulOp> {
public:
  using OpRewritePattern<catherine::blis::BlisMatmulOp>::OpRewritePattern;
  MatmulOpt(MLIRContext *context)
      : OpRewritePattern<catherine::blis::BlisMatmulOp>(context) {

  }

  LogicalResult matchAndRewrite(
      catherine::blis::BlisMatmulOp matmulOp, PatternRewriter &rewriter) const override {
    // llvm::outs()<<"MatmulOpt:"<< "\n";
    // matmulOp.dump();
    // rewriter.eraseOp(matmulOp);
    return success();
  }
};

/// optimization pass.
class MatmulOptPass
    : public PassWrapper<MatmulOptPass,  OperationPass<ModuleOp>>  {
public:
    MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(MatmulOptPass)
    StringRef getArgument() const final { return "matmul-opt"; }
    StringRef getDescription() const final { return "MatMul Optimization."; }
    MatmulOptPass() = default;
    MatmulOptPass(const MatmulOptPass &) {}

    void runOnOperation() override;
    void runOnBlock(Block *block);

    void optimizeMatmul(AffineForOp rootMatmulNest, unsigned M_C, unsigned N_C,
                      unsigned K_C, unsigned M_R, unsigned N_R, unsigned K_U,
                      OpBuilder &builder);

    // struct Options : public PassOptions<Options> {
    ::mlir::Pass::Option<bool> clCopy{
        *this, "copy",
        llvm::cl::desc("Perform explicit copying / packing of memrefs"),
        llvm::cl::init(true)};
    ::mlir::Pass::Option<bool> clScalRep{
        *this, "scalRep",
        llvm::cl::desc("Perform scalar replacement"),
        llvm::cl::init(true)};
    ::mlir::Pass::Option<bool> clUnroll{
        *this, "unroll",
        llvm::cl::desc("Perform unroll and unroll-and-jam"),
        llvm::cl::init(true)};
    ::mlir::Pass::Option<bool> clVect{
        *this, "vect",
        llvm::cl::desc("Perform auto-vectorization"),
        llvm::cl::init(true)};
    // }

// private:
//     bool clCopy = false;
//     bool clScalRep = false;
//     bool clUnroll = false;
//     bool clVect = false;

  };

} // end anonymous namespace

// 参数初始化
static unsigned getMatmulOptPassParameter(Operation *op, StringRef name) {
  // 默认参数
  const llvm::DenseMap<StringRef, unsigned> kDefaultMatmulOptPassParams = {
      {"M_C", 330}, {"N_C", 2048}, {"K_C", 480},
      {"M_R", 6},   {"N_R", 8},    {"K_U", 4}};
  IntegerAttr attr = op->getAttrOfType<IntegerAttr>(name);
  if (!attr) {
    // Use the default value.
    assert(kDefaultMatmulOptPassParams.count(name) > 0 &&
           "default opt conf parameter not found");
    return kDefaultMatmulOptPassParams.lookup(name);
  }
  return attr.getValue().getSExtValue();
}

static AffineForOp getByPolyName(AffineForOp root, StringRef polyName) {
  const char *kPolyCodeGenAttrName = "poly_name";
  AffineForOp res;
  root.walk([&](AffineForOp forOp) {
    auto stringAttr = forOp->getAttrOfType<StringAttr>(kPolyCodeGenAttrName);
    if (!stringAttr)
      return WalkResult::advance();
    auto forOpCodegenName = stringAttr.getValue();
    if (forOpCodegenName.equals(polyName)) {
      res = forOp;
      return WalkResult::interrupt();
    }
    return WalkResult::advance();
  });
  return res;
}

/// Optimize matmul nest with vectorization, packing, and register tiling.
void MatmulOptPass::optimizeMatmul(AffineForOp rootMatmulNest,
                                              unsigned M_C, unsigned N_C,
                                              unsigned K_C, unsigned M_R,
                                              unsigned N_R, unsigned K_U,
                                              OpBuilder &builder) {
  llvm::outs()<<"optimizeMatmul transformer:"<< "\n";

  Value outputMemRef, lhsMemRef, rhsMemRef;
  //  LHS, RHS, 和输出 memrefs.
  rootMatmulNest.walk(
      [&](AffineStoreOp storeOp) { outputMemRef = storeOp.getMemRef(); });
  rootMatmulNest.walk([&](AffineLoadOp loadOp) {
    if (outputMemRef == loadOp.getMemRef())
      return;
    rhsMemRef = loadOp.getMemRef();
  });
  rootMatmulNest.walk([&](AffineLoadOp loadOp) {
    if (rhsMemRef == loadOp.getMemRef() || outputMemRef == loadOp.getMemRef())
      return;
    lhsMemRef = loadOp.getMemRef();
  });

  assert(outputMemRef && lhsMemRef && rhsMemRef &&
         "unable to identify memrefs");
  AffineForOp jC = getByPolyName(rootMatmulNest, "jC");
  (void)jC;
  // 如果jC or kC 没找到
  AffineForOp kC = getByPolyName(rootMatmulNest, "kC");
  (void)kC;

  AffineForOp iC = getByPolyName(rootMatmulNest, "iC");
  if (!iC) {
    LLVM_DEBUG(llvm::dbgs()
               << "BLIS transformation recipe failed: iC not found\n");
    return;
  }

  AffineForOp jR = getByPolyName(rootMatmulNest, "jR");
  if (!jR) {
    LLVM_DEBUG(llvm::dbgs()
               << "BLIS transformation recipe failed: jR not found\n");
    return;
  }

  AffineForOp k = getByPolyName(rootMatmulNest, "k");
  AffineForOp jjR = getByPolyName(rootMatmulNest, "jjR");
  AffineForOp iiR = getByPolyName(rootMatmulNest, "iiR");
  // I如果 iiR, jjR 没找到

  if (clVect && jjR &&
      !outputMemRef.getType()
           .cast<MemRefType>()
           .getElementType()
           .isa<VectorType>()) {
    DenseMap<Value, Value> vecMemRefMap;
    // if (succeeded(loopVectorize(jjR, /*simdWidth=*/256, &vecMemRefMap))) {
    //   assert(vecMemRefMap.count(rhsMemRef) > 0 && "rhs vec memref not found");
    //   assert(vecMemRefMap.count(outputMemRef) > 0 &&
    //          "output vec memref not found");

    //   rhsMemRef = vecMemRefMap[rhsMemRef];
    //   outputMemRef = vecMemRefMap[outputMemRef];
    // }
  }

  Value lhsBuf, rhsL3Buf, rhsL1Buf;

  // Packing.
  if (clCopy) {
    AffineCopyOptions copyOptions = {/*generateDma=*/false,
                                     /*slowMemorySpace=*/0,
                                     /*fastMemorySpace=*/0,
                                     /*tagMemorySpace=*/0,
                                     /*fastMemCapacityBytes=*/32 * 1024 * 1024UL
                                    };

    // For the LHS matrix (pack into L2).
    auto d0 = builder.getAffineDimExpr(0);
    auto d1 = builder.getAffineDimExpr(1);
    SmallVector<AffineExpr, 4> bufRemapExprs = {d0.floorDiv(M_R), d1, d0 % M_R};
    // copyOptions.fastBufferLayout = AffineMap();
    SmallVector<Value, 1> fastBuf;
    DenseSet<Operation *> copyNests;

    // affineDataCopyGenerate会分析代码，寻找affine loads和affine stores的引用，然后自动生成affine copy operations。
    // 使用affineDataCopyGenerate pass可以将数据复制到内存布局良好的存储方案中，以便使用硬件加速器进行加速。同时，这种数据复制操作还可以帮助提高并行性，并为许多ML应用程序提供性能优势。
    affineDataCopyGenerate(iC.getBody()->begin(),
                           std::prev(iC.getBody()->end()), copyOptions,
                           lhsMemRef, copyNests
                          //  , &fastBuf
                           );
    // lhsBuf = fastBuf[0];

    if (kC) {
      // RHS matrix, pack into L3 tile if the kC loop exists.
      // copyOptions.fastBufferLayout = AffineMap();
      affineDataCopyGenerate(kC.getBody()->begin(),
                             std::prev(kC.getBody()->end()), copyOptions,
                             rhsMemRef, copyNests
                            //  , &fastBuf
                             );
      // rhsL3Buf = fastBuf[0];
    } else {
      // rhsL3Buf = rhsMemRef;
    }

    // For the RHS matrix (pack into L1).
    // copyOptions.fastBufferLayout = AffineMap();
    copyOptions.fastMemCapacityBytes = 256 * 1024UL;
    affineDataCopyGenerate(jR.getBody()->begin(),
                           std::prev(jR.getBody()->end()), copyOptions,
                           /*filterMemRef=*/rhsL3Buf, copyNests
                          //  , &fastBuf
                           );
    // rhsL1Buf = fastBuf[0];

    // // 将LHS和RHS缓冲器的对齐为256位，如果已经是矢量memrefs，就不需要设置对齐。
    // auto allocOp = cast<memref::AllocOp>(lhsBuf.getDefiningOp());
    // auto alignmentAttrName = allocOp.getAlignmentAttrName();
    // auto alignmentAttr = builder.getI64IntegerAttr(32);
    // allocOp->setAttr(alignmentAttrName, alignmentAttr);
    // // cast<memref::AllocOp>(lhsBuf.getDefiningOp())


    //     ->setAttr(memref::AllocOp::getAlignmentAttrName(),
    //              builder.getI64IntegerAttr(32));
    // The rhsL3buf could sometimes just be the original memref / func arg.


    // if ( rhsL3Buf.getDefiningOp()){
    //   auto rhsAllocOp = cast<memref::AllocOp>(rhsL3Buf.getDefiningOp());

    //   auto rhsAllocOpAlignmentAttrName = rhsAllocOp.getAlignmentAttrName();
    //   rhsAllocOp->setAttr(rhsAllocOpAlignmentAttrName,
    //                       builder.getI64IntegerAttr(32));
    // }
    // auto rhsL1BufOp = cast<memref::AllocOp>(rhsL1Buf.getDefiningOp());
    // rhsL1BufOp->setAttr(rhsL1BufOp.getAlignmentAttrName(),
    //              builder.getI64IntegerAttr(32));
  }

  if (clUnroll) {
    // 将寄存器内的tile循环完全展开。
    if (iiR)
      (void)loopUnrollJamUpToFactor(iiR, M_R);
    if (jjR)
      (void)loopUnrollJamUpToFactor(jjR, N_R);
    if (k)
      (void)loopUnrollJamByFactor(k, K_U);
  }
}

void MatmulOptPass::runOnBlock(Block *block) {
  llvm::outs()<<"MatmulOpt runOnBlock:"<< "\n";

  for (auto &op : *block) {
    if (auto forOp = dyn_cast<AffineForOp>(op)) {
      // todo 使用 mlir::tile 平铺

      StringAttr polyClass =
          forOp.getOperation()->getAttrOfType<StringAttr>("class");
      polyClass.dump();
      if (!polyClass || !polyClass.getValue().equals("blis.matmul"))
        continue;

      OpBuilder builder(forOp);

      auto M_C = getMatmulOptPassParameter(forOp, "M_C");
      auto N_C = getMatmulOptPassParameter(forOp, "N_C");
      auto K_C = getMatmulOptPassParameter(forOp, "K_C");
      auto M_R = getMatmulOptPassParameter(forOp, "M_R");
      auto N_R = getMatmulOptPassParameter(forOp, "N_R");
      auto K_U = getMatmulOptPassParameter(forOp, "K_U");
      llvm::outs()<<M_C<<" "<<N_C<<" "<<K_C<<"\n";
      optimizeMatmul(forOp, M_C, N_C, K_C, M_R, N_R, K_U, builder);
      forOp.dump();
    }
  }
}

void MatmulOptPass::runOnOperation() {
  llvm::outs()<<"MatmulOpt:"<< "\n";

  auto moduleOp = getOperation();
  // Get the first func in the module
  // mlir::func::FuncOp func = nullptr;
  moduleOp.walk([this, moduleOp](mlir::func::FuncOp func) {
    // Process all blocks of the function.
    for (auto &block : func.getBlocks())
      runOnBlock(&block);

    // Normalize non-identity layouts used.
    func.walk([](memref::AllocOp allocOp) { (void)normalizeMemRef(&allocOp); });

    // Canonicalize.
    {
    
      ConversionTarget target(getContext());
      RewritePatternSet patterns(&getContext());
      patterns.insert<MatmulOpt>( &getContext());
      LogicalResult res =
          applyPatternsAndFoldGreedily(moduleOp, std::move(patterns));
      assert((succeeded(res) || failed(res)) && "remove unused var warning");
      // AffineLoadOp::getCanonicalizationPatterns(patterns, context);
      // AffineStoreOp::getCanonicalizationPatterns(patterns, context);
      // AffineApplyOp::getCanonicalizationPatterns(patterns, context);
      // (void)applyPatternsAndFoldGreedily(func, std::move(patterns));
    }

  });

  

  // 标量替代
  // if (clScalRep) {
  //   func.walk([&](AffineForOp forOp) { scalarReplace(forOp); });
  // }
}


// 创建一个通道来执行依赖于memref数据流的优化
namespace catherine {
  void registerMatmulOptPass(){
    PassRegistration<MatmulOptPass>();
  }
}

// 以后放在passes中
// std::unique_ptr<Pass> catherine::createMatmulOptPass() {
//   return std::make_unique<MatmulOptPass>();
// }