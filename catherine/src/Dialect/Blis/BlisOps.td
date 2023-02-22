//===----------------------------------------------------------------------===//
// 包含Blis基类和ops的td
//===----------------------------------------------------------------------===//
#ifndef BLIS_OPS
#define BLIS_OPS

include "BlisDialect.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

def BlisMatmulOp : Blis_Op<"matmul"> {
    let summary = "Illustrates how to define an operation.";
    let description = [{
        The "mul" operation performs element-wise multiplication between two
    tensors. The shapes of the tensor operands are expected to match.

        Example:

        ```mlir
       
        ```
    }];

    let arguments = (ins 
      // F64Tensor:$A, F64Tensor:$B, F64Tensor:$C
      Arg<AnyMemRef, "Mult A [NxK]", [MemRead]>:$A,
      Arg<AnyMemRef, "Mult B [KxM]", [MemRead]>:$B,
      Arg<AnyMemRef, "res C [NxM]", [MemRead, MemWrite]>:$C
    ) ;

    
    let assemblyFormat = [{
      `(`
      $A  `,`
      $B  `,`
      $C  
      `)`
      attr-dict 
      `:`
      `(` type($A) `,` type($B)`,` type($C) `)`
    }];
    // let results = (outs F64Tensor);
    // let assemblyFormat = [{
    //     ^{sym_name} {arguments}
    // }];

    // let assemblyFormat = [{
    //     $input attr-dict `:` type($input)
    // }];
}


//===----------------------------------------------------------------------===//
// Test constant operation.
//===----------------------------------------------------------------------===//

def Blis_TestConstantOp : Blis_Op<"test_constant", []> {
  let summary = "Test Constant Operation.";

  let results = (outs AnyInteger:$result);

  let assemblyFormat = [{
    attr-dict `:` type($result)
  }];
}


#endif // BLIS_OPS
