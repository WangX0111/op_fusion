//===- MatMulOptimize.cpp -------------------------------------------------===//
//
//  该文件实现了一个基于BLIS的matmul优化。
//
//===----------------------------------------------------------------------===//

#include <mlir/Dialect/Affine/IR/AffineOps.h>
#include <mlir/Dialect/Func/IR/FuncOps.h>
#include <mlir/Dialect/Linalg/Transforms/Transforms.h>
#include <mlir/IR/Dialect.h>
#include <mlir/IR/Operation.h>
#include <mlir/IR/TypeUtilities.h>
#include <mlir/IR/Value.h>
#include <mlir/Pass/Pass.h>
#include "llvm/Support/Debug.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#include "Blis/BlisOps.h"

#define DEBUG_TYPE "hopt"
using namespace mlir;
using namespace vector;

//===----------------------------------------------------------------------===//
// Rewrite Pattern
//===----------------------------------------------------------------------===//

namespace {
// Matmul will be lowered to vector and affine expressions
class MatMulOptimizePattern : public ConversionPattern {
public:
  explicit MatMulOptimizePattern(MLIRContext *context)
      : ConversionPattern(catherine::blis::BlisMatmulOp::getOperationName(), 1, context) {

  }

  LogicalResult
  matchAndRewrite(Operation *op, ArrayRef<Value> /*operands*/,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op->getLoc();

    // Get input A, B, C.
    Value A = op->getOperand(0);
    Value B = op->getOperand(1);
    Value C = op->getOperand(2);

    auto matmulOp = cast<catherine::blis::BlisMatmulOp>(op);
    catherine::blis::BlisMatmulOpAdaptor operandAdaptor(matmulOp);
    LLVM_DEBUG(llvm::dbgs()
               <<"matmul op:"<<matmulOp<< "\n");
    // rewriter.eraseOp(op);
    return success();
  }

private:

};
} // end anonymous namespace

//===----------------------------------------------------------------------===//
// MatMulOptimizePass
// PassWrapper 是一个模板类，它可以将一个继承自 OperationPass 的类包装成一个可以注册到 PassManager 中的 OpPass。
// 使用 PassWrapper 可以使得我们更方便地注册一个 OperationPass，并将其作为一个 OpPass 运行。
//===----------------------------------------------------------------------===//

/// This is a partial lowering linalg pooling operations to mixture of
/// Affine + Vector operations. 

namespace {
class MatMulOptimizePass
    : public PassWrapper<MatMulOptimizePass, OperationPass<ModuleOp>> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(MatMulOptimizePass)
  StringRef getArgument() const final { return "matmul-optimize"; }
  StringRef getDescription() const final { return "MatMul Optimization."; }
  MatMulOptimizePass() = default;
  MatMulOptimizePass(const MatMulOptimizePass &) {}
  // explicit MatMulOptimizePass(int64_t vecSizeParam, int64_t kernelMParam,
  //                             int64_t kernelNParam) {
  //   vecSize = vecSizeParam;
  //   kernelM = kernelMParam;
  //   kernelN = kernelNParam;
  // }

  void runOnOperation() override;

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<linalg::LinalgDialect, scf::SCFDialect, AffineDialect, VectorDialect
                    // , BlisDialect
                    >();
  }

  };
} // end anonymous namespace.

void MatMulOptimizePass::runOnOperation() {
  MLIRContext *context = &getContext();
  ModuleOp module = getOperation();

  ConversionTarget target(*context);
  target
      .addLegalDialect<arith::ArithDialect, AffineDialect, scf::SCFDialect,
                       memref::MemRefDialect, VectorDialect>();
  target.addLegalOp<ModuleOp, func::FuncOp, func::ReturnOp>();
  target.addLegalOp<linalg::FillOp>();

  RewritePatternSet patterns(context);
  patterns.add<MatMulOptimizePattern>(context);
  // patterns.add<MatMulOptimizePattern>(context, vecSize, kernelM, kernelN);

  if (failed(applyPartialConversion(module, target, std::move(patterns))))
    signalPassFailure();
}

namespace catherine {
namespace blis {
void registerMatMulOptimizePass() { PassRegistration<MatMulOptimizePass>(); }
} // namespace buddy
} // namespace mlir
