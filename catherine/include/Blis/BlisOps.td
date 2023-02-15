//===----------------------------------------------------------------------===//
// 包含Blis基类和ops的td
//===----------------------------------------------------------------------===//
#ifndef BLIS_OPS
#define BLIS_OPS

include "BlisDialect.td"
include "/mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

def Blis_MatmulOp : Blis_Op<"matmul"> {
    let summary = "Illustrates how to define an operation.";
    let description = [{
        The "mul" operation performs element-wise multiplication between two
    tensors. The shapes of the tensor operands are expected to match.

        Example:

        ```mlir
       
        ```
    }];

    let arguments = (ins F64Tensor:$lhs, F64Tensor:$rhs);
    let results = (outs F64Tensor);

    // let assemblyFormat = [{
    //     $input attr-dict `:` type($input)
    // }];
}

#endif // BLIS_OPS
