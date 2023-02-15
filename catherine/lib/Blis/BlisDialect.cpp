#include "Blis/BlisDialect.h"
#include "Blis/BlisOps.h"

using namespace mlir;
using namespace catherine::blis;

//===----------------------------------------------------------------------===//
// Blis dialect.
//===----------------------------------------------------------------------===//

void BlisDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "Blis/BlisOps.cpp.inc"
      >();
}
