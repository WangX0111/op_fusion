/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Rewriters                                                                  *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

/* Generated from:
    /home/ustc/wang/op_fusion/catherine/src/Transform/ONNX/RewriteAnalyze.td:23
*/
using namespace mlir;

struct MulAddToGemmOptPattern : public ::mlir::RewritePattern {
  MulAddToGemmOptPattern(::mlir::MLIRContext *context)
      : ::mlir::RewritePattern("onnx.Add", 2, context, {"onnx.Gemm"}) {}
  ::mlir::LogicalResult matchAndRewrite(::mlir::Operation *op0,
      ::mlir::PatternRewriter &rewriter) const override {
    // Variables for capturing values and attributes used while creating ops
    ::mlir::Operation::operand_range m3(op0->getOperands());
    ::mlir::Operation::operand_range m2(op0->getOperands());
    ::mlir::Operation::operand_range m1(op0->getOperands());
    ::mlir::ONNXMatMulOp res;
    ::llvm::SmallVector<::mlir::Operation *, 4> tblgen_ops;

    // Match
    tblgen_ops.push_back(op0);
    auto castedOp0 = ::llvm::dyn_cast<::mlir::ONNXAddOp>(op0); (void)castedOp0;
    {
      auto *op1 = (*castedOp0.getODSOperands(0).begin()).getDefiningOp();
      if (!(op1)){
        return rewriter.notifyMatchFailure(castedOp0, [&](::mlir::Diagnostic &diag) {
          diag << "There's no operation that defines operand 0 of castedOp0";
        });
      }
      auto castedOp1 = ::llvm::dyn_cast<::mlir::ONNXMatMulOp>(op1); (void)castedOp1;
      if (!(castedOp1)){
        return rewriter.notifyMatchFailure(op1, [&](::mlir::Diagnostic &diag) {
          diag << "castedOp1 is not ::mlir::ONNXMatMulOp type";
        });
      }
      res = castedOp1;
      m1 = castedOp1.getODSOperands(0);
      m2 = castedOp1.getODSOperands(1);
      tblgen_ops.push_back(op1);
    }
    m3 = castedOp0.getODSOperands(1);
    if (!(((*res.getODSResults(0).begin()).hasOneUse()))){
      return rewriter.notifyMatchFailure(op0, [&](::mlir::Diagnostic &diag) {
        diag << "entities 'res' failed to satisfy constraint: ''";
      });
    }
    if (!(((*m1.begin()).getType().isa<mlir::ShapedType>() && (*m1.begin()).getType().cast<ShapedType>().hasRank() && (*m1.begin()).getType().cast<ShapedType>().getRank() == 2))){
      return rewriter.notifyMatchFailure(op0, [&](::mlir::Diagnostic &diag) {
        diag << "entities 'm1' failed to satisfy constraint: ''";
      });
    }
    if (!(((*m2.begin()).getType().isa<mlir::ShapedType>() && (*m2.begin()).getType().cast<ShapedType>().hasRank() && (*m2.begin()).getType().cast<ShapedType>().getRank() == 2))){
      return rewriter.notifyMatchFailure(op0, [&](::mlir::Diagnostic &diag) {
        diag << "entities 'm2' failed to satisfy constraint: ''";
      });
    }

    // Rewrite
    auto odsLoc = rewriter.getFusedLoc({tblgen_ops[0]->getLoc(), tblgen_ops[1]->getLoc()}); (void)odsLoc;
    ::llvm::SmallVector<::mlir::Value, 4> tblgen_repl_values;
    auto nativeVar_0 = rewriter.getF32FloatAttr(1.0); (void)nativeVar_0;
    auto nativeVar_1 = rewriter.getF32FloatAttr(1.0); (void)nativeVar_1;
    auto nativeVar_2 = IntegerAttr::get(rewriter.getIntegerType(64, /*isSigned=*/true), APInt(64, 0, /*isSigned=*/true)); (void)nativeVar_2;
    auto nativeVar_3 = IntegerAttr::get(rewriter.getIntegerType(64, /*isSigned=*/true), APInt(64, 0, /*isSigned=*/true)); (void)nativeVar_3;
    ::mlir::ONNXGemmOp tblgen_ONNXGemmOp_4;
    {
      ::llvm::SmallVector<::mlir::Value, 4> tblgen_values; (void)tblgen_values;
      ::llvm::SmallVector<::mlir::NamedAttribute, 4> tblgen_attrs; (void)tblgen_attrs;
      tblgen_values.push_back((*m1.begin()));
      tblgen_values.push_back((*m2.begin()));
      tblgen_values.push_back((*m3.begin()));
      if (auto tmpAttr = nativeVar_0) {
        tblgen_attrs.emplace_back(rewriter.getStringAttr("alpha"), tmpAttr);
      }
      if (auto tmpAttr = nativeVar_1) {
        tblgen_attrs.emplace_back(rewriter.getStringAttr("beta"), tmpAttr);
      }
      if (auto tmpAttr = nativeVar_2) {
        tblgen_attrs.emplace_back(rewriter.getStringAttr("transA"), tmpAttr);
      }
      if (auto tmpAttr = nativeVar_3) {
        tblgen_attrs.emplace_back(rewriter.getStringAttr("transB"), tmpAttr);
      }
      ::llvm::SmallVector<::mlir::Type, 4> tblgen_types; (void)tblgen_types;
      for (auto v: castedOp0.getODSResults(0)) {
        tblgen_types.push_back(v.getType());
      }
      tblgen_ONNXGemmOp_4 = rewriter.create<::mlir::ONNXGemmOp>(odsLoc, tblgen_types, tblgen_values, tblgen_attrs);
    }

    for (auto v: ::llvm::SmallVector<::mlir::Value, 4>{ tblgen_ONNXGemmOp_4.getODSResults(0) }) {
      tblgen_repl_values.push_back(v);
    }

    rewriter.replaceOp(op0, tblgen_repl_values);
    return ::mlir::success();
  };
};

void LLVM_ATTRIBUTE_UNUSED populateWithGenerated(::mlir::RewritePatternSet &patterns) {
  patterns.add<MulAddToGemmOptPattern>(patterns.getContext());
}
