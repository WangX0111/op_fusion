//===------------------------------------------------------------*- C++ -*-===//
//
//===----------------------------------------------------------------------===//

#include "Passes.h"

using namespace mlir;
using namespace catherine;
using namespace hls;

void hls::registerHLSPasses() {
#define GEN_PASS_REGISTRATION
#include "Passes.h.inc"
} // namespace
