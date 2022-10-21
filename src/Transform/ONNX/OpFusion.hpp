#ifndef ONNX_MLIR_OPSCHEDULER_HPP
#define ONNX_MLIR_OPSCHEDULER_HPP

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Operation.h"
#include "src/CostModel/TransformationImpedance.hpp"
#include "src/Dialect/ONNX/ONNXOps.hpp"
#include "llvm/Support/Casting.h"

#include <cstdint>
#include <vector>

using namespace mlir;

namespace onnx_mlir {

constexpr const char *TI_ATTR = "TI";
constexpr const char *PRIORITY_ATTR = "priority";
constexpr const char *TYPE_ATTR = "type";

void SetDefaultTransformationImpedance(mlir::OpBuilder &builder,
    std::vector<Operation *> &ops, const TISetT &TI_set);

void SetDefaultTransformationImpedanceAndPriority(mlir::OpBuilder &builder,
    std::vector<Operation *> &ops, const TISetT &TI_set);

} // namespace onnx_mlir
#endif /* ONNX_MLIR_OPSCHEDULER_HPP */
