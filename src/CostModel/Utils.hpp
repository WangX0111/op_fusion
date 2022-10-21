#ifndef COST_MODEL_UTILS_HPP
#define COST_MODEL_UTILS_HPP

#include "src/Dialect/ONNX/ONNXOps.hpp"
#include "src/Utils/Utils.hpp"

#include "mlir/IR/Operation.h"

namespace onnx_mlir {

inline bool ShouldIgnoreOperandOp(mlir::Operation *op) {
  if (!op || isa<ONNXConstantOp>(op) || isa<ONNXNoneOp>(op) ||
      isa<ONNXSliceOp>(op)) {
    return true;
  }
  return false;
}

} // namespace onnx_mlir

#endif /* COST_MODEL_UTILS_HPP */
