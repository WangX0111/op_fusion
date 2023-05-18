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
}


namespace mlir {
namespace catherine {
namespace hls {


/// Creates a pass that performs mamul optimization.
// std::unique_ptr<mlir::Pass> createMatmulOptPass();

std::unique_ptr<Pass> createEstimationPass();

void registerHLSPasses();
// void registerTransformsPasses();

#define GEN_PASS_CLASSES
#include "Passes.h.inc"

} // hls
} // namespace catherine
} // namespace mlir

#endif // DIALECT_HLS_PASSES_H