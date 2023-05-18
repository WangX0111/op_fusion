#pragma once
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "third_party/onnx-mlir/src/Dialect/ONNX/ONNXAttributes.hpp"
#include "third_party/onnx-mlir/src/Dialect/ONNX/ONNXDialect.hpp"
#include "third_party/onnx-mlir/src/Dialect/ONNX/ONNXOps/ShapeHelper.hpp"
#include "third_party/onnx-mlir/src/Dialect/ONNX/ONNXTypes.hpp"
#include "third_party/onnx-mlir/src/Interface/HasOnnxSubgraphOpInterface.hpp"
#include "third_party/onnx-mlir/src/Interface/ResultTypeInferenceOpInterface.hpp"
#include "third_party/onnx-mlir/src/Interface/ShapeInferenceOpInterface.hpp"

namespace catherine {
static constexpr int CURRENT_ONNX_OPSET = 17;
} 

#define GET_OP_CLASSES
#include "RewriteAnalyze.hpp.inc"
