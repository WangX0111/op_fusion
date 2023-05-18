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

def FusionPass : Pass<"fusion"> {
  let summary = "fusion pass";
  let constructor = "mlir::catherine::createFusionPass()";
  let options = [
    Option<"gpu_enabled_", "gpu-enabled", "bool",
              /*default=*/"true", "whether gpu is available.">,
        Option<"fusion_strategy_", "fusion-strategy", "std::string",
              /*default=*/"\"base\"", "Name of the fusion strategy.">,

  ];
}

def DiscFusionPass : Pass<"disc-fusion", "::mlir::func::FuncOp"> {
  let summary = "Fuse lmhlo ops to kLoop/kInput fusion patterns.";
  let constructor = "mlir::catherine::createDiscFusionPass()";
  let options = [
    Option<"gpu_enabled_", "gpu-enabled", "bool",
           /*default=*/"true", "whether gpu is available.">,
    Option<"fusion_strategy_", "fusion-strategy", "std::string",
           /*default=*/"\"base\"", "Name of the fusion strategy.">,
  ];
}

def Estimation : Pass<"estimation", "::mlir::ModuleOp"> {
  let summary = "Estimate the performance and resource utilization";
  let description = [{
    This pass will analyze the input IR and estimate the latency and resource
    utilization of HLS C++ synthesis. This pass will take all dependency and
    resource constraints and pragma settings into consideration, and conduct the
    estimation through an ALAP scheduling.
  }];
  let constructor = "mlir::catherine::createEstimationPass()";

  let options = [
    Option<"targetSpec", "target-spec", "std::string",
           /*default=*/"\"../config/target-spec.ini\"", 
           "File path: target backend specifications and configurations">,
    Option<"opLatency", "op-latency", "std::string",
           /*default=*/"\"../config/op-latency.ini\"", 
           "Config file path: profiling data for operation latency">
  ];
}

#endif // CATHERINE_PASSES
