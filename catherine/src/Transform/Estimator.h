//===------------------------------------------------------------*- C++ -*-===//
//
//===----------------------------------------------------------------------===//

#ifndef CATHERINE_TRANSFORMS_ESTIMATION_H
#define CATHERINE_TRANSFORMS_ESTIMATION_H

#include <mlir/IR/Operation.h>
#include "mlir/IR/BuiltinOps.h"
#include "StaticParam.h"
#include "Dialect/HLS/Visitor.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Affine/Analysis/AffineAnalysis.h"
#include "mlir/Pass/Pass.h"
#include "llvm/ADT/TypeSwitch.h"

namespace mlir {
namespace catherine {

//===----------------------------------------------------------------------===//
// HLSAnalyzer Class Declaration
//===----------------------------------------------------------------------===//

class HLSAnalyzer : public HLSVisitorBase<HLSAnalyzer, bool> {
public:
  explicit HLSAnalyzer(ProcParam &procParam, MemParam &memParam)
      : procParam(procParam), memParam(memParam) {}

  ProcParam &procParam;
  MemParam &memParam;

  bool visitUnhandledOp(Operation *op) { return true; }

  using HLSVisitorBase::visitOp;
  bool visitOp(AffineForOp op);
  bool visitOp(AffineParallelOp op);
  bool visitOp(AffineIfOp op);

  void analyzeOperation(Operation *op);
  void analyzeFunc(func::FuncOp func);
  void analyzeBlock(Block &block);
  void analyzeModule(ModuleOp module);
};

//===----------------------------------------------------------------------===//
// Estimator Class Declaration
//===----------------------------------------------------------------------===//

class Estimator : public HLSVisitorBase<Estimator, bool> {
public:
  explicit Estimator(ProcParam &procParam, MemParam &memParam,
                        std::string targetSpecPath, std::string opLatencyPath);

  ProcParam &procParam;
  MemParam &memParam;

  bool visitUnhandledOp(Operation *op) { return true; }

  using HLSVisitorBase::visitOp;
  /// These methods can estimate the performance and resource utilization of a
  /// specific MLIR structure, and update them in procParams or memroyParams.
  bool visitOp(AffineForOp op);
  bool visitOp(AffineParallelOp op);
  bool visitOp(AffineIfOp op);

  /// These methods are used for searching longest path in a DAG.
  void updateValueTimeStamp(Operation *currentOp, unsigned opTimeStamp,
                            DenseMap<Value, unsigned> &valueTimeStampMap);
  unsigned searchLongestPath(Block &block);

  /// MLIR component estimators.
  void estimateOperation(Operation *op);
  void estimateFunc(func::FuncOp func);
  void estimateBlock(Block &block);
  void estimateModule(ModuleOp module);
};

} // namespace catherine
} // namespace mlir

#endif // CATHERINE_TRANSFORMS_ESTIMATION_H
