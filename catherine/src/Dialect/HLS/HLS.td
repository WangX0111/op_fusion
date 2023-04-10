//===-------------------------------------------------------*- tablegen -*-===//
//
//===----------------------------------------------------------------------===//

#ifndef DIALECT_HLS_DIALECT_TD
#define DIALECT_HLS_DIALECT_TD

include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/EnumAttr.td"
include "mlir/IR/OpBase.td"

def HLSDialect : Dialect {
  let name = "hls";
  let summary = "An HLS out-of-tree MLIR dialect";
  let description = [{
    This dialect contains dedicated operations, interfaces, and passes designed
    for representing HLS specific structures and components in MLIR, while
    enabling comprehensive optimization for both performance and area. Passes
    in this dialect can optimize and generate IRs
  }];
  let cppNamespace = "::mlir::catherine::hls";
}

class HLSOp<string mnemonic, list<Trait> traits = []> :
    Op<HLSDialect, mnemonic, traits>;

include "Interfaces.td"

// include "Attributes.td"

include "PragmaOps.td"
include "StructureOps.td"

#endif // DIALECT_HLS_DIALECT_H
