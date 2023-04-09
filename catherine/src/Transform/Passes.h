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

#include <memory>

namespace mlir {
class Pass;
namespace func {
class FuncOp;
} // namespace func
}


namespace mlir {
namespace catherine {

/// Creates a pass that performs mamul optimization.
// std::unique_ptr<mlir::Pass> createMatmulOptPass();
void registerHLSDSEPipeline();
void registerTransformsPasses();

std::unique_ptr<Pass> createEstimationPass();

#define GEN_PASS_CLASSES
#include "Passes.h.inc"

} // namespace catherine
} // namespace mlir

#endif // DIALECT_HLS_PASSES_H
