//===----------------------------------------------------------------------===//
//
// This file contains definitions for passes within the Transforms/ directory.
//
//===----------------------------------------------------------------------===//

#ifndef CATHERINE_PASSES
#define CATHERINE_PASSES

include "mlir/Pass/PassBase.td"


def MatmulOpt : Pass<"hopt"> {
  let summary = "MatmulOpt optimization";
  let constructor = "catherine::createMatmulOptPass()";
  let options = [
  Option<"clCopy", "copy", "bool",
           /*default=*/"true", "Perform explicit copying / packing of memrefs">,
    Option<"clScalRep", "scalrep", "bool",
           /*default=*/"true", "Perform scalar replacement">,
    Option<"clUnroll", "unroll", "bool",
           /*default=*/"true", "Perform unroll and unroll-and-jam">,
    Option<"clVect", "vect", "bool",
           /*default=*/"true", "Perform auto-vectorization">
  ];
}

#endif // CATHERINE_PASSES
