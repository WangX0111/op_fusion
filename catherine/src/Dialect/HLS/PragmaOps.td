//===-------------------------------------------------------*- tablegen -*-===//
//
//===----------------------------------------------------------------------===//

/// This file is deprecated and will be removed in the future.

#ifndef CATHERINE_DIALECT_HLSCPP_PRAGMAOPS_TD
#define CATHERINE_DIALECT_HLSCPP_PRAGMAOPS_TD

include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/BuiltinAttributeInterfaces.td"
include "mlir/IR/SymbolInterfaces.td"
include "Dialect/HLS/Interfaces.td"
include "mlir/IR/BuiltinAttributes.td"

def ApplyPragmasOp : HLSOp<"apply_pragmas", [
  PragmaOpInterface,
  SingleBlockImplicitTerminator<"EndOp">
]> {
  let summary = "Apply pragmas to the parent operation";
  let description = [{
    This hlscpp.apply_pragmas operation owns one region containing one or more
    concrete pragmas, and applies all of them to its parent operation (e.g.,
    functions, loops, or other regions). This operation should always be
    inserted to the front of its parent operation. For detailed description of
    each concrete pragma, please refer to:
  }];

  let regions = (region SizedRegion<1> : $pragmaRegion);

  let skipDefaultBuilders = 1;
  let builders = [
    OpBuilder<(ins), "build($_builder, $_state);">
    ];

  // TODO: verifier for this op:
  // (1) is in the front of its parent operation.
  // (2) only contains hlscpp pragma operation.

  let extraClassDeclaration = [{
  }];
}

def PragmaPipelineOp : HLSOp<"pragma_pipeline", [
  PragmaOpInterface,
  HasParent<"ApplyPragmasOp">
]> {
  let summary = "Apply PIPELINE HLS pragma";
  let description = [{
    This hlscpp.pragma_pipeline operation represent the "#pragma HLS PIPELINE"
    directive in HLS C++.
  }];

  let arguments = (ins
    UI32Attr : $II,
    BoolAttr : $enable_flush,
    BoolAttr : $rewind,
    BoolAttr : $off
  );
  let extraClassDeclaration = [{
  }];
  // let extraClassDeclaration = [{

  //   bool isEnableFlush() {
  //     return getAttrOfType<BoolAttr>("enable_flush").getValue();
  //   }

  //   bool isRewind() {
  //     return getAttrOfType<BoolAttr>("rewind").getValue();
  //   }

  //   bool isOff() {
  //     return getAttrOfType<BoolAttr>("off").getValue();
  //   }
  // }];
}

def PragmaUnrollOp : HLSOp<"pragma_unroll", [
  PragmaOpInterface,
  HasParent<"ApplyPragmasOp">
]> {
  let summary = "Apply UNROLL HLS pragma";
  let description = [{
    This hlscpp.pragma_unroll operation represent the "#pragma HLS UNROLL"
    directive in HLS C++.
  }];

  let arguments = (ins
    UI32Attr : $factor,
    BoolAttr : $region,
    BoolAttr : $skip_exit_check
  );
  let extraClassDeclaration = [{
  }];
  // let extraClassDeclaration = [{

  //   bool isRegion() {
  //     return getAttrOfType<BoolAttr>("region").getValue();
  //   }

  //   bool isSkipExitCheck() {
  //     return getAttrOfType<BoolAttr>("skip_exit_check").getValue();
  //   }
  // }];
}

def PragmaArrayPartitionOp : HLSOp<"pragma_array_partition", [
  PragmaOpInterface
]> {
  let summary = "Apply ARRAY_PARTITION HLS pragma to the input value";
  let description = [{
    This hlscpp.pragma_array_partition operation represent the "#pragma HLS 
    ARRAY_PARTITION" directive in HLS C++.
  }];

  let arguments = (ins 
    Type<IsShapedTypePred> : $variable,
    StrAttr : $type,
    UI32Attr : $factor,
    UI32Attr : $dim
  );

  // TODO: verifier for this op:
  // (1) dim is not larger than variable's dim.
  // (2) factor is not larger than variable's shape of the corresponding dim.

  let extraClassDeclaration = [{
  }];
}

#endif // CATHERINE_DIALECT_HLSCPP_PRAGMAOPS_TD
