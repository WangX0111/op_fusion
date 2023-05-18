
#ifndef TENSORFLOW_COMPILER_MLIR_HLO_INCLUDE_MLIR_HLO_DIALECT_MHLO_TRANSFORMS_FUSION_UTILS_H_
#define TENSORFLOW_COMPILER_MLIR_HLO_INCLUDE_MLIR_HLO_DIALECT_MHLO_TRANSFORMS_FUSION_UTILS_H_

#include <memory>
#include <set>
#include <string>
#include <vector>

#include "llvm/ADT/EquivalenceClasses.h"
#include "llvm/Support/Debug.h"
#include "mlir/Dialect/SCF/IR/SCF.h"

#define DEBUG_TYPE "disc-fusion-utils"

// This file implements some helper functions and classes used to do fusion
// & code generation.

namespace llvm {
template <>
struct DenseMapInfo<SmallVector<mlir::Value>> {
  static SmallVector<mlir::Value> getEmptyKey() {
    return SmallVector<mlir::Value>{DenseMapInfo<mlir::Value>::getEmptyKey()};
  }

  static SmallVector<mlir::Value> getTombstoneKey() {
    return SmallVector<mlir::Value>{
        DenseMapInfo<mlir::Value>::getTombstoneKey()};
  }

  static unsigned getHashValue(const SmallVector<mlir::Value>& vs) {
    unsigned hash = hash_value(vs.size());
    for (auto v : vs) hash = llvm::hash_combine(hash, v);
    return hash;
  }

  static bool isEqual(const SmallVector<mlir::Value>& lhs,
                      const SmallVector<mlir::Value>& rhs) {
    return lhs == rhs;
  }
};

}  // namespace llvm


namespace mlir {
namespace catherine {

  DenseSet<Operation*> NoLoaderUser(SmallVectorImpl<Operation*>& ops);

  bool isOnGpu(Operation* op);

  enum FusionType {
  };

  // Represents a list of disjoint fusion patterns for a block.
  // using FusionPlan = std::vector<FusionPattern>;

  // a -> b iff graph[a][b] = true;
  using ValueGraph = DenseMap<Value, DenseMap<Value, bool>>;

  bool doAnalysis();

  bool doCodeGeneration(OpBuilder& b, Operation* fusion);

  // Used for roots dominant analysis
  Value dominantValue_;
  ValueGraph dominantGraph_;

  struct OpGroup {
    Operation* dominant_op;
    SmallVector<Operation*> op_list;
  };
}
}
#endif