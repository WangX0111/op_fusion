//===- Passes.h - Pass Entrypoints ------------------------------*- C++ -*-===//
//
// This file exposes the entry points to create compiler passes for catherine
//
//===----------------------------------------------------------------------===//

// #pragma once
#ifndef DIALECT_HLS_PASSES_H
#define DIALECT_HLS_PASSES_H

#include "mlir/Pass/Pass.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/ArrayRef.h"

#include <memory>

namespace mlir {
class Pass;
namespace func {
class FuncOp;
} // namespace func
}


namespace mlir {

class FuncOp;
class FunctionPass;
class ModuleOp;
class Operation;
template <typename T>
class OperationPass;
class Pass;

namespace catherine {

/// Creates a pass that performs mamul optimization.
// std::unique_ptr<mlir::Pass> createMatmulOptPass();
std::unique_ptr<mlir::Pass> createFusionPass(
    );


std::unique_ptr<OperationPass<FuncOp>> createDiscFusionPass(
    bool gpu_enabled = true, const std::string& fusion_strategy = "base");

std::unique_ptr<Pass> createEstimationPass();

void registerHLSDSEPipeline();
void registerTransformsPasses();

#define GEN_PASS_CLASSES
#include "Passes.h.inc"

} // namespace catherine
} // namespace mlir

#endif // DIALECT_HLS_PASSES_H
