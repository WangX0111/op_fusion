//===- Passes.h - Pass Entrypoints ------------------------------*- C++ -*-===//
//
// This file exposes the entry points to create compiler passes for catherine
//
//===----------------------------------------------------------------------===//

#pragma once

#include <memory>

namespace mlir {
class Pass;
}

namespace catherine {
    
    /// Creates a pass that performs mamul optimization.
    std::unique_ptr<mlir::Pass> createMatmulOptPass();

} // end namespace catherine

