include "mlir/IR/OpBase.td"
include "mlir/Interfaces/SideEffects.td"

def KateKrnl_Dialect : Dialect {
    let name = "katekrnl";
    let cppNamespace = "katekrnl";
}

class KateKrnl_Op<string mnemonic, list<OpTrait> traits = []> :
    Op<KateKrnl_Dialect, mnemonic, traits>;

def ConvOp : KateKrnl_Op<"conv", [NoSideEffect]> {
    let summary = "conv";

    let description = [{
        Convolution Operation.
    }];

    let arguments = (ins AnyTypeOf<[AnyMemRef, AnyTensor]>:$ifmap,
                     DefaultValuedAttr<AnyI32ElementsAttr, "0">:$kernel_value,
                     DefaultValuedAttr<I32ArrayAttr, "{}">:$kernel_shape,
                     DefaultValuedAttr<I32ArrayAttr, "{}">:$pads,
                     OptionalAttr<I32ArrayAttr>:$dilations,
                     OptionalAttr<I32ArrayAttr>:$strides,
                     OptionalAttr<I32Attr>:$group);

    let results = (outs AnyTypeOf<[AnyMemRef, AnyTensor]>:$ofmap);
    
    let verifier = [{ return ::verify(*this); }];
}

def MaxPoolOp : FpgaKrnl_Op<"maxpool", [NoSideEffect]> {
    let summary = "maxpool";

    let description = [{
        Max Pooling Operation.
    }];

    let arguments = (ins AnyTypeOf<[AnyMemRef, AnyTensor]>:$ifmap,
                     DefaultValuedAttr<I32ArrayAttr, "{}">:$kernel_shape,
                     DefaultValuedAttr<I32ArrayAttr, "{}">:$pads,
                     OptionalAttr<I32ArrayAttr>:$dilations,
                     OptionalAttr<I32ArrayAttr>:$strides);

    let results = (outs AnyTypeOf<[AnyMemRef, AnyTensor]>:$ofmap);
    
    let verifier = [{ return ::verify(*this); }];
    
}