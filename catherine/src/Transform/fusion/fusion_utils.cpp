#include "src/Transform/fusion/fusion_utils.hpp"

#include <algorithm>
#include <mutex>

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Shape/IR/Shape.h"  // TF:llvm-project
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/MLIRContext.h"  // TF:llvm-project
#include "mlir/IR/Matchers.h"
#include "mlir/Interfaces/ViewLikeInterface.h"

// This file implements some helper functions and classes used to do fusion
// & code generation.

namespace mlir {
namespace catherine {

  // 1，对op_list进行分析
  // 2，合并入一个group
  // 3，按规则进行判断是否能融合
  bool doAnalysis(){

  }

  // 根据规则进行融合
  bool doCodeGeneration(OpBuilder& b, Operation* fusion){
    LLVM_DEBUG(llvm::dbgs() << "Try to doCodeGeneration for fusion:\n" << fusion);

  }

}
}
