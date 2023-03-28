struct LoweringToConvOp : public mlir::ConversionPattern {
    LoweringToConvOp(mlir::MLIRContext)
    
}

void OnnxToKateKrnlLoweringPass::runOnFunction() {
    mlir::ConversionTarget target(getContext());

    target.addLegalDialect<KateKrnlDialect>();

    target.addIllegalDialect<mlir::ONNXOpsDialect>();
}