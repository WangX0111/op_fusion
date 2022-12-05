#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Types.h"
#include "mlir/Pass/Pass.h"

// #include "src/CostModel/Device.hpp"
// #include "src/CostModel/GraphCostNC.hpp"
#include "src/Transform/ONNX/OpFusion.hpp"
#include "src/Dialect/ONNX/ONNXOps.hpp"
#include "src/Pass/Passes.hpp"

#include "src/Utils/Utils.hpp"
#include "src/Support/Log/Log.hpp"

#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/raw_ostream.h"
#include <memory>
#include <string>
#include <vector>

using namespace mlir;

namespace onnx_mlir {

bool IgnoreOp(mlir::Operation *op) {
  if (isa<ONNXReturnOp>(op) || isa<ONNXConstantOp>(op) ||
      isa<func::ReturnOp>(op) || isa<ONNXNoneOp>(op) || isa<ONNXReturnOp>(op) || isa<ONNXSliceOp>(op)) {
    return true;
  }
  return false;
}

class OpFusionPass
    : public mlir::PassWrapper<OpFusionPass, OperationPass<ModuleOp>> {
public:
  llvm::StringRef getArgument() const override { return "op-fusion"; }

  llvm::StringRef getDescription() const override {
    return "op fusion for onnx mlr";
  }

/* 
    1.算子初始化阻抗
    2.调用后端进行融合
    3.性能分析
**/
  void runOnOperation() override {
    llvm::outs() << "Enter OpFusionPass\n";

    auto module_op = getOperation();
    auto main_func = module_op.lookupSymbol<mlir::func::FuncOp>("main_graph");

    auto &block = main_func.front();
    auto builder = mlir::OpBuilder(&block, block.end());

    std::vector<Operation *> ops;
    for (auto &op : llvm::make_early_inc_range(
             llvm::make_range(block.begin(), block.end()))) {
      if (IgnoreOp(&op)) {
        // std::cout << op.getName().getStringRef().str() << "\n";
        continue;
      }
      ops.push_back(&op);
    }

    //transformation impedance
    auto TI_set = GetTISet();
    SetTI(builder, ops, TI_set);

    std::cout << "\n";
  }

private:
  void SetTI(mlir::OpBuilder &builder,
      std::vector<Operation *> &ops, const TISetT &TI_set) {
    SetDefaultTransformationImpedance(builder, ops, TI_set);
    // fusion Strategy
    
  }
};

std::unique_ptr<mlir::Pass> createOpFusionPass() {
  return std::make_unique<OpFusionPass>();
}
} // namespace onnx_mlir