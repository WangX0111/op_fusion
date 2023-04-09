//===-------------------------------------------------------*- tablegen -*-===//
//
//===----------------------------------------------------------------------===//

#ifndef DIALECT_HLS_PARAMOPS_TD
#define DIALECT_HLS_PARAMOPS_TD

include "Interfaces.td"

//===----------------------------------------------------------------------===//
// FuncParamOp
//===----------------------------------------------------------------------===//

def FuncParamOp : HLSOp<"func_param", [
  ParamOpInterface,
  HasParent<"func::FuncOp">
]> {
  let summary = "Hold function parameters";
  let description = [{
    This HLS.func_param operation holds parameters for function region.
  }];

  let arguments = (ins
    // Pragma configuration parameters
    // BoolAttr : $enable_pipeline,
    // PositiveUI32Attr : $initial_interval,

    // Resource utilization parameters
    UI32Attr : $lut,
    UI32Attr : $dsp,
    UI32Attr : $bram
  );
}

//===----------------------------------------------------------------------===//
// LoopParamOp
//===----------------------------------------------------------------------===//

def LoopParamOp : HLSOp<"loop_param", [
  ParamOpInterface,
  HasParent<"AffineForOp">
]> {
  let summary = "Hold loop parameters";
  let description = [{
    This HLS.loop_param operation holds parameters for loop region.
  }];

   let arguments = (ins
    // Pragma configuration parameters
    BoolAttr : $enable_pipeline,
    UI32Attr : $initial_interval,
    UI32Attr : $unroll_factor,

    // Performance parameters
    UI32Attr : $loop_bound,
    UI32Attr : $nonproc_latency,
    UI32Attr : $iteration_latency,
    UI32Attr : $latency,

    // Resource utilization parameters
    UI32Attr : $lut,
    UI32Attr : $dsp,
    UI32Attr : $bram,

   // Pipeline-related attributes.
    DefaultValuedAttr<BoolAttr, "false"> : $pipeline,
    DefaultValuedAttr<UI32Attr, "1"> : $pipeline_II,

    // Loop-related attributes.
    DefaultValuedAttr<BoolAttr, "false"> : $flatten,
    DefaultValuedAttr<BoolAttr, "false"> : $unroll
  );
  let assemblyFormat = [{attr-dict}];
  let extraClassDeclaration = [{
    
  }];
}



#endif // DIALECT_HLS_PARAMOPS_TD
