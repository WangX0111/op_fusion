#ifndef BLIS_DIALECT
#define BLIS_DIALECT

include "mlir/IR/OpBase.td"

//===----------------------------------------------------------------------===//
// Blis dialect definition.
//===----------------------------------------------------------------------===//

def Blis_Dialect : Dialect {
    let name = "blis";
    let summary = "A Blis out-of-tree MLIR dialect.";
    let description = [{
        This dialect is an example of an out-of-tree MLIR dialect designed to
        illustrate the basic setup required to develop MLIR-based tools without
        working inside of the LLVM source tree.
    }];
    let cppNamespace = "::catherine::blis";
}

//===----------------------------------------------------------------------===//
// Base Blis operation definition.
//===----------------------------------------------------------------------===//

class Blis_Op<string mnemonic, list<Trait> traits = []> :
        Op<Blis_Dialect, mnemonic, traits>;

#endif // BLIS_DIALECT