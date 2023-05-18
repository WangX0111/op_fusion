#ifndef ONNX_REWRITE
#define ONNX_REWRITE

#ifndef OP_BASE
include "third_party/onnx-mlir/src/Dialect/ONNX/ONNX.td"
#endif // OP_BASE


def GemmAlpha : NativeCodeCall<"$_builder.getF32FloatAttr(1.0)">;
def GemmBeta : NativeCodeCall<"$_builder.getF32FloatAttr(1.0)">;
def GemmTransA : NativeCodeCall<"IntegerAttr::get($_builder.getIntegerType(64, /*isSigned=*/true), APInt(64, 0, /*isSigned=*/true))">;
def GemmTransB : NativeCodeCall<"IntegerAttr::get($_builder.getIntegerType(64, /*isSigned=*/true), APInt(64, 0, /*isSigned=*/true))">;

def HasOneUse : Constraint<CPred<"$0.hasOneUse()">>;

// Check the rank of a value is of a given integer.
class HasRankOf<int rank> :
  Constraint<CPred<"$0.getType().isa<ShapedType>() && "
                   "$0.getType().cast<ShapedType>().hasRank() && "
                   "$0.getType().cast<ShapedType>().getRank() == " # rank>>;

// onnx.add(onnx.matmul(%X, %Y), %Z) = onnx.Gemm(%X, %Y, %Z)
def MulAddToGemmOptPattern : Pat<(ONNXAddOp (ONNXMatMulOp:$res $m1, $m2), $m3),
                                 (ONNXGemmOp $m1, $m2, $m3, (GemmAlpha), (GemmBeta), (GemmTransA), (GemmTransB)),
                                 [(HasOneUse $res), (HasRankOf<2> $m1), (HasRankOf<2> $m2)]>;

#endif // ONNX_REWRITE