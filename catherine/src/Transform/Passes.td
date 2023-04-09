//===----------------------------------------------------------------------===//
//
// This file contains definitions for passes within the Transforms/ directory.
//
//===----------------------------------------------------------------------===//

#ifndef CATHERINE_PASSES
#define CATHERINE_PASSES

// include "mlir/IR/Operation.h"

include "mlir/Pass/PassBase.td"
// include "mlir/IR/BuiltinOps.h"


// def MatmulOpt : Pass<"hopt"> {
//   let summary = "MatmulOpt optimization";
//   let constructor = "catherine::createMatmulOptPass()";
//   let options = [
//   Option<"clCopy", "copy", "bool",
//            /*default=*/"true", "Perform explicit copying / packing of memrefs">,
//     Option<"clScalRep", "scalrep", "bool",
//            /*default=*/"true", "Perform scalar replacement">,
//     Option<"clUnroll", "unroll", "bool",
//            /*default=*/"true", "Perform unroll and unroll-and-jam">,
//     Option<"clVect", "vect", "bool",
//            /*default=*/"true", "Perform auto-vectorization">
//   ];
// }



def Estimation : Pass<"estimation", "mlir::ModuleOp"> {
  let summary = "Estimate the performance and resource utilization";
  let description = [{
    This pass will analyze the input IR and estimate the latency and resource
    utilization of HLS C++ synthesis. This pass will take all dependency and
    resource constraints and pragma settings into consideration, and conduct the
    estimation through an ALAP scheduling.
  }];
  let constructor = "mlir::catherine::createEstimationPass()";

  let options = [
    Option<"toolConfig", "tool-config", "std::string",
           /*default=*/"\"../config/tool-config.ini\"", 
           "Config file path: global configurations for the ScaleHLS tools">,
    Option<"opLatency", "op-latency", "std::string",
           /*default=*/"\"../config/op-latency.ini\"", 
           "Config file path: profiling data for operation latency">
  ];
}

#endif // CATHERINE_PASSES
