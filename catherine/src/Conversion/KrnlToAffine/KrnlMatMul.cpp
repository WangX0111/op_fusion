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
// #include "mlir/IR/Types.h"
// #include "mlir/IR/StandardTypes.h"


#include "Blis/BlisOps.h"

#define DEBUG_TYPE "kate"
using namespace mlir;
using namespace vector;

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

    // Option.

    // Operands and types.
    // Get input A, B, C.
    Value A = op->getOperand(0);
    llvm::outs()<<"Value A:"<<A<< "\n";
    Value B = op->getOperand(1);
    // Value C = op->getOperand(2);
    // Type elementType =
    //     operandAdaptor.A().getType().cast<MemRefType>().getElementType();
    // Init scope and emit constants.
    Location loc = matmulOp.getLoc();

    // Gather A, B, C tile sizes.
    // SmallVector<IndexExpr, 2> aTileSize, bTileSize;
    // Value A(operandAdaptor.A()), B(operandAdaptor.B());

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

    // Tile sizes for A/B/C are determined by their memref unless explicitly
    // specified by an optional argument. That allows A/B/C memrefs to be
    // padded if needed for SIMD/unroll and jam, for example.

    // Gather N, M, K compute tile size. This is the size of the computations,
    // if the tile is full. Because computation in the buffers could be further
    // sub-tiled, the default size can be overridden from the tile sizes using
    // the computeTileSize attribute. Tiles may not be full if they are at the
    // outer boundaries of the original data.
    matmulOp.getOperation()->setAttr("M_C", IntegerAttr::get(IntegerType::get(matmulOp.getContext(), 32), 330));
    matmulOp.getOperation()->setAttr("N_C", IntegerAttr::get(IntegerType::get(matmulOp.getContext(), 32), 2048));
    matmulOp.getOperation()->setAttr("K_C", IntegerAttr::get(IntegerType::get(matmulOp.getContext(), 32), 480));
    matmulOp.getOperation()->setAttr("M_R", IntegerAttr::get(IntegerType::get(matmulOp.getContext(), 32), 3));
    matmulOp.getOperation()->setAttr("N_R", IntegerAttr::get(IntegerType::get(matmulOp.getContext(), 32), 16));
    matmulOp.getOperation()->setAttr("K_U", IntegerAttr::get(IntegerType::get(matmulOp.getContext(), 32), 4));

    llvm::outs()<<"converted matmul op:"<< "\n";
    matmulOp.dump();
    // Get the global upper bound of the original computations.

    // Has a matrix times vector when the J upper bound is literal 1.

    // Investigate SIMD
    // Assume no simd.

    // Now get global start indices, which would define the first element of the
    // tiles in the original computations.

    // Now determine if we have full/partial tiles. This is determined by the
    // outer dimensions of the original computations, as by definition tiling
    // within the buffer always results in full tiles. In other words, partial
    // tiles only occurs because of "running out" of the original data.

    // And if the tiles are not full, determine how many elements to compute.
    // With over-compute, this could be relaxed.

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
  // patterns.add<MatMulOptimizePattern>(context, vecSize, kernelM, kernelN);

  if (failed(applyPartialConversion(module, target, std::move(patterns))))
    signalPassFailure();
}

namespace catherine {
namespace blis {
void registerKrnlMatMulLoweringPass() { PassRegistration<KrnlMatMulLoweringPass>(); }
} // namespace buddy
} // namespace mlir
