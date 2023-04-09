//===------------------------------------------------------------*- C++ -*-===//
//
//===----------------------------------------------------------------------===//

#include "HLS.h"
// #include "mlir/IR/StandardTypes.h"

using namespace mlir;
using namespace catherine;
using namespace hls;

void HLSDialect::initialize() {

  addOperations<
#define GET_OP_LIST
#include "Dialect/HLS/HLS.cpp.inc"
      >();
}

#include "Dialect/HLS/HLSDialect.cpp.inc"
#include "Dialect/HLS/HLSInterfaces.cpp.inc"

#define GET_OP_CLASSES
#include "Dialect/HLS/HLS.cpp.inc"
