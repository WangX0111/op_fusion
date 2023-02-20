#include "BlisDialect.h"
#include "BlisOps.h"

using namespace mlir;
using namespace catherine::blis;
#include "Blis/BlisOpsDialect.cpp.inc"


//===----------------------------------------------------------------------===//
// Blis dialect.
//===----------------------------------------------------------------------===//

void BlisDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "Blis/BlisOps.cpp.inc"
      >();
}
