//===-------------------------------------------------------*- tablegen -*-===//
//
//===----------------------------------------------------------------------===//

#ifndef DIALECT_HLS_INTERFACES_TD
#define DIALECT_HLS_INTERFACES_TD

include "mlir/IR/OpBase.td"

def PragmaOpInterface : OpInterface<"PragmaOpInterface"> {
  let description = [{
    This interface indicates the operation represents one pragma directive or a
    group of pragmas.
  }];
}

def ParamOpInterface : OpInterface<"ParamOpInterface"> {
  let description = [{
    This interface indicates the operation represents a group of parameters of
    its parent region.
  }];
}

#endif // DIALECT_HLS_INTERFACES_TD
