#ifndef ONNX_MLIR_UTILS_HPP
#define ONNX_MLIR_UTILS_HPP


#include "mlir/IR/Attributes.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/Types.h"
#include "mlir/IR/Value.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/ArrayRef.h"
#include <cassert>
#include <functional>
#include <sstream>

#include "src/Dialect/ONNX/ONNXOps.hpp"


using namespace mlir;

namespace onnx_mlir {

#define SET_CONTAINS(set, key) (set.find(key) != set.cend())

template <typename SourceOp>
bool isa(mlir::Operation *op) {
  return op ? (llvm::dyn_cast<SourceOp>(op) != nullptr) : false;
}

template <typename ArrayT>
std::string ArrayToStr(ArrayT arr) {
  std::stringstream ss;
  ss << '[';
  for (auto dim : arr) {
    ss << dim << ",";
  }
  ss << ']';
  return ss.str();
}

template <typename T>
mlir::Attribute GetConstantValueAttr(
    mlir::Builder *builder, mlir::Type op_element_type, T value) {
  mlir::Attribute value_attr;
  if (op_element_type.isInteger(1)) {
    value_attr = builder->getIntegerAttr(
        builder->getI1Type(), llvm::APInt(1, static_cast<bool>(value)));
  } else if (op_element_type.isInteger(8)) {
    value_attr = builder->getI8IntegerAttr(static_cast<int8_t>(value));
  } else if (op_element_type.isInteger(16)) {
    value_attr = builder->getI16IntegerAttr(static_cast<int16_t>(value));
  } else if (op_element_type.isInteger(32)) {
    value_attr = builder->getI32IntegerAttr(static_cast<int32_t>(value));
  } else if (op_element_type.isInteger(64)) {
    value_attr = builder->getI64IntegerAttr(static_cast<int64_t>(value));
  } else if (op_element_type.isF16()) {
    value_attr = builder->getF16FloatAttr(static_cast<float>(value));
  } else if (op_element_type.isF32()) {
    value_attr = builder->getF32FloatAttr(static_cast<float>(value));
  } else if (op_element_type.isF64()) {
    value_attr = builder->getF64FloatAttr(static_cast<double>(value));
  } else if (op_element_type.isBF16()) {
    value_attr = builder->getFloatAttr(
        builder->getBF16Type(), static_cast<float>(value));
  } else {
    assert("not support dtype");
  }


  return value_attr;
}

template <typename T>
mlir::Operation *CreateConstantOp(mlir::OpBuilder *builder,
    mlir::Location location, mlir::Type op_element_type,
    llvm::ArrayRef<int64_t> shape, T value) {
  auto splat_type = mlir::RankedTensorType::get(shape, op_element_type);
  auto value_attr = GetConstantValueAttr(builder, op_element_type, value);

  mlir::DenseElementsAttr const_value = mlir::DenseElementsAttr::get(
      splat_type, llvm::ArrayRef<mlir::Attribute>(value_attr));
  auto const_op =
      builder->create<mlir::ONNXConstantOp>(location, Attribute(), const_value);

  return const_op.getOperation();
}

} // namespace onnx_mlir

#endif /* ONNX_MLIR_UTILS_HPP */
