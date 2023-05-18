
#include <math.h>

#include "mlir/IR/Matchers.h"
#include "mlir/IR/PatternMatch.h"


#include "third_party/onnx-mlir/src/Dialect/ONNX/ONNXOps.hpp"
#include "RewriteAnalyze.hpp"


using namespace mlir;
using namespace onnx_mlir;

/// on the ONNXAddOp.
void ONNXAddOp::getCanonicalizationPatterns(
    RewritePatternSet &results, MLIRContext *context) {

  results.insert<MulAddToGemmOptPattern>(context);

}