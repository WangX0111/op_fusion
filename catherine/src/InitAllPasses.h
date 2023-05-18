//===----------------------------------------------------------------------===//
//
// Copyright 2020-2021 The ScaleHLS Authors.
//
//===----------------------------------------------------------------------===//

#ifndef SCALEHLS_INITALLPASSES_H
#define SCALEHLS_INITALLPASSES_H

#include "mlir/InitAllPasses.h"
#include "Transform/Passes.h"

namespace mlir {
namespace catherine {


// Add all the ScaleHLS passes.
inline void registerAllPasses() {
  mlir::catherine::registerTransformsPasses();
  mlir::registerAllPasses();
}

} // namespace catherine
} // namespace mlir

#endif // SCALEHLS_INITALLPASSES_H
