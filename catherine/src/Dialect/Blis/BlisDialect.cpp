#include "BlisDialect.h"
#include "BlisOps.h"

using namespace mlir;
using namespace catherine::blis;

//===----------------------------------------------------------------------===//
// Blis dialect.
//===----------------------------------------------------------------------===//

void BlisDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "src/Dialect/Blis/BlisOps.cpp.inc"
      >();
}
