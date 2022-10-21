#include "src/Transform/ONNX/OpFusion.hpp"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Operation.h"
#include "src/CostModel/TransformationImpedance.hpp"

#include "src/Dialect/ONNX/ONNXOps.hpp"
#include "src/Utils/Utils.hpp"

#include "llvm/Support/raw_ostream.h"


#include <algorithm>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <iterator>
#include <random>
#include <unordered_map>
#include <vector>

namespace onnx_mlir {

void SetDefaultTransformationImpedance(mlir::OpBuilder &builder,
    std::vector<Operation *> &ops, const TISetT &TI_set) {
  auto default_TI = *TI_set.begin();
  auto default_priority = 0;

  for (auto &op : ops) {

    op->setAttr(TI_ATTR, builder.getStringAttr(default_TI.id()));
    op->setAttr(PRIORITY_ATTR, builder.getF32FloatAttr(default_priority));
  }
}

void SetDefaultTransformationImpedanceAndPriority(mlir::OpBuilder &builder,
    std::vector<Operation *> &ops, const TISetT &TI_set) {
  auto default_TI = *TI_set.begin();
  auto default_priority = 0;

  for (auto &op : ops) {

    op->setAttr(TI_ATTR, builder.getStringAttr(default_TI.id()));
    op->setAttr(PRIORITY_ATTR, builder.getF32FloatAttr(default_priority));
  }
}

} // namespace onnx_mlir