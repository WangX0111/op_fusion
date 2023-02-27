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
// #include "mlir/Transforms/AffineDataCopyGeneration.h"

// #include "mlir/IR/Types.h"
// #include "mlir/IR/StandardTypes.h"

#include "Blis/BlisOps.h"
#include <blis.h>

#define DEBUG_TYPE "kate"
using namespace mlir;
using namespace vector;


// 定义BLIS操作的C++实现
void blis_gemm(MemRefType A, MemRefType B, MemRefType C) {
 
  // // 调用BLIS库实现矩阵乘法，暂时使用mock数据
  // dim_t m = 4, n = 5, k = 3;
  // inc_t rsa = 1, csa = m;
  // inc_t rsb = 1, csb = k;
  // inc_t rsc = 1, csc= m;
  // double c[m * n];
  // double a[m * k];
  // double b[k * n];
  // double alpha = 1.0;
  // double beta = 1.0;
  // bli_dgemm(BLIS_NO_TRANSPOSE, BLIS_NO_TRANSPOSE,
  //           m, n, k, 
  //           &alpha, a, rsa, csa, 
  //           b, rsb, csb, 
  //           &beta, c, rsc, csc);
}
//===----------------------------------------------------------------------===//
// Rewrite Pattern
//===----------------------------------------------------------------------===//

namespace {
// Matmul will be lowered to vector and affine expressions, but now only change the info
class KrnlMatMulLoweringPattern : public ConversionPattern {
public:
  explicit KrnlMatMulLoweringPattern(MLIRContext *context)
      : ConversionPattern(catherine::blis::BlisMatmulOp::getOperationName(), 1, context) {

  }

  LogicalResult
  matchAndRewrite(Operation *op, ArrayRef<Value> /*operands*/,
                  ConversionPatternRewriter &rewriter) const override {
    auto matmulOp = cast<catherine::blis::BlisMatmulOp>(op);
    catherine::blis::BlisMatmulOpAdaptor operandAdaptor(matmulOp);


    matmulOp->dump();
    // Get the two dimensions of the matmul operation.
    auto lhsShape = matmulOp.getOperand(0).getType().cast<ShapedType>().getShape();
    auto rhsShape = matmulOp.getOperand(1).getType().cast<ShapedType>().getShape();
    auto resShape = matmulOp.getOperand(2).getType().cast<ShapedType>().getShape();
    // auto resShape = matmulOp.getResult().getType().cast<ShapedType>().getShape();
    int64_t m = lhsShape[0];
    int64_t k = lhsShape[1];
    int64_t n = rhsShape[1];

    // Create the size information as a string attribute.
    std::string sizeInfoStr = std::to_string(m) + "x" + std::to_string(k) + "x" + std::to_string(n);
    auto sizeInfoAttr = StringAttr::get(matmulOp.getContext(), sizeInfoStr);

    MemRefType MA = matmulOp.getOperand(0).getType().cast<MemRefType>();
    MemRefType MB = matmulOp.getOperand(1).getType().cast<MemRefType>();
    MemRefType MC = matmulOp.getOperand(2).getType().cast<MemRefType>();
    blis_gemm(MA, MB, MC);

    // 遍历所有的matmul操作，将它们替换为BLIS dgemm
    matmulOp.walk([&](catherine::blis::BlisMatmulOp matmul) {

      // 使用BLIS的dgemm来替换matmul操作
      blis_gemm(MA, MB, MC);
      auto newCTy =
        MemRefType::get({m, n}, MC.getElementType());
    });



    rewriter.eraseOp(op);
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
class KrnlMatMulLoweringPass
    : public PassWrapper<KrnlMatMulLoweringPass, OperationPass<ModuleOp>> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(KrnlMatMulLoweringPass)
  StringRef getArgument() const final { return "blis"; }
  StringRef getDescription() const final { return "MatMul Optimization."; }
  KrnlMatMulLoweringPass() = default;
  KrnlMatMulLoweringPass(const KrnlMatMulLoweringPass &) {}

  void runOnOperation() override;

  void getDependentDialects(DialectRegistry &registry) const override {
    registry.insert<linalg::LinalgDialect, scf::SCFDialect, AffineDialect, VectorDialect
                    // , BlisDialect
                    >();
  }

  };
} // end anonymous namespace.

void KrnlMatMulLoweringPass::runOnOperation() {
  MLIRContext *context = &getContext();
  ModuleOp module = getOperation();

  

  ConversionTarget target(*context);
  target
      .addLegalDialect<arith::ArithDialect, AffineDialect, scf::SCFDialect,
                       memref::MemRefDialect, VectorDialect>();
  target.addLegalOp<ModuleOp, func::FuncOp, func::ReturnOp>();
  target.addLegalOp<linalg::FillOp>();

  RewritePatternSet patterns(context);
  patterns.add<KrnlMatMulLoweringPattern>(context);
  // patterns.insert<BLISAffineDataCopyGenerate>(context);
  // patterns.add<MatMulOptimizePattern>(context, vecSize, kernelM, kernelN);
  
  // (void)applyPatternsAndFoldGreedily(module, std::move(patterns));

  if (failed(applyPartialConversion(module, target, std::move(patterns))))
    signalPassFailure();
}

namespace catherine {
namespace blis {
void registerKrnlMatMulLoweringPass() { PassRegistration<KrnlMatMulLoweringPass>(); }
} // namespace buddy
} // namespace mlir
