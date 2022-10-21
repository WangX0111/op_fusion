#include "src/Support/Log/Log.hpp"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Operation.h"

namespace onnx_mlir {

std::unordered_set<std::string> NotSupportCostOp;

std::ostream &operator<<(std::ostream &os, const mlir::Value &value) {
  mlir::Operation *op = value.getDefiningOp();
  auto node_name_attr = op->getAttr("onnx_node_name");
  std::string node_name;
  if (node_name_attr) {
    node_name = node_name_attr.cast<mlir::StringAttr>().str();
  }
  os << "Value(" << op->getName().getStringRef().str() << " " << node_name
     << ")";
  return os;
}
} // namespace onnx_mlir
