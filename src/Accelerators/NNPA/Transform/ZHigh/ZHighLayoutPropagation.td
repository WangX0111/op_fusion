// SPDX-License-Identifier: Apache-2.0

//===------- ZHighLayoutPropagation.td - Pattern Match for ZHighDialect ---===//
//
// Copyright 2019-2020 The IBM Research Authors.
//
// =============================================================================
//
// Defines language-specific pattern match optimizations for ZHigh using
// Declarative Rewrite Rules (DRR) specified using TableGen records.
//
//===----------------------------------------------------------------------===//

#ifndef ZHIGH_LAYOUT_PROPAGATION
#define ZHIGH_LAYOUT_PROPAGATION

#ifndef OP_BASE
include "src/Dialect/ONNX/ONNX.td"
include "src/Accelerators/NNPA/Dialect/ZHigh/ZHigh.td"
#endif // OP_BASE

/// Note: The DRR definition used for defining patterns is shown below:
///
/// class Pattern<
///    dag sourcePattern, list<dag> resultPatterns,
///    list<dag> additionalConstraints = [],
///    dag benefitsAdded = (addBenefit 0)
/// >;

//===----------------------------------------------------------------------===//
// Pattern-Match and Rewrite
//===----------------------------------------------------------------------===//

// Check values of an ArrayAttr.
def IsPermToNHWC:
  Constraint<CPred<"$_self.getValue().size() == 4 && "
                   "($_self.getValue()[0]).cast<IntegerAttr>().getInt() == 0 && "
                   "($_self.getValue()[1]).cast<IntegerAttr>().getInt() == 2 && "
                   "($_self.getValue()[2]).cast<IntegerAttr>().getInt() == 3 && "
                   "($_self.getValue()[3]).cast<IntegerAttr>().getInt() == 1">,
                 "Permutation is [0, 2, 3, 1]">;

// Check values of an ArrayAttr.
def IsPermToNCHW:
  Constraint<CPred<"$_self.getValue().size() == 4 && "
                   "($_self.getValue()[0]).cast<IntegerAttr>().getInt() == 0 && "
                   "($_self.getValue()[1]).cast<IntegerAttr>().getInt() == 3 && "
                   "($_self.getValue()[2]).cast<IntegerAttr>().getInt() == 1 && "
                   "($_self.getValue()[3]).cast<IntegerAttr>().getInt() == 2">,
                 "Permutation is [0, 3, 1, 2]">;

def GetLayout : NativeCodeCall<
  "convertDataLayoutToStringAttr($_builder, ::onnx_mlir::zhigh::getZTensorLayout($0.getType()))"
>;

def IsNHWC: Constraint<
  CPred<"getZTensorLayout($0.getType()) == ::onnx_mlir::zhigh::ZTensorEncodingAttr::DataLayout::NHWC">,
  "Check if a value is NHWC"
>;

def IsNotNHWC: Constraint<
  CPred<"getZTensorLayout($0.getType()) != ::onnx_mlir::zhigh::ZTensorEncodingAttr::DataLayout::NHWC">,
  "Check if a value is not NHWC"
>;

def NCHWtoNHWC :
  NativeCodeCall<"emitONNXTranspose($_loc, $_builder, $0, 0, 2, 3, 1)">;

def NHWCtoNCHW:
  NativeCodeCall<"emitONNXTranspose($_loc, $_builder, $0, 0, 3, 1, 2)">;

// If the inputs of zhigh.add transitively/originally come from zAIU tensors
// in NHWC layout, then use the original zAIU tensors for zhigh.add.
// In other words, propagate the layout NHWC down, so that other rules can be
// applied to remove stick/unstick pairs.

def AddLayoutPropagatePattern3 : Pat<
  (ZHighAddOp
     (ZHighStickOp (ZHighUnstickOp $x), $stickLayout),
     $y),
  (ZHighStickOp
     (ZHighUnstickOp
       (ZHighAddOp
         $x,
         (ZHighStickOp (ZHighUnstickOp $y), (GetLayout $x)),
         (returnType $x))),
     $stickLayout),
  [(IsNHWC $x), (IsNotNHWC $y)]
>;

def AddLayoutPropagatePattern4 : Pat<
  (ZHighAddOp
     $x,
     (ZHighStickOp (ZHighUnstickOp $y), $stickLayout)),
  (ZHighStickOp
     (ZHighUnstickOp
       (ZHighAddOp
         $y,
         (ZHighStickOp (ZHighUnstickOp $x), (GetLayout $y)),
         (returnType $y))),
     $stickLayout),
  [(IsNHWC $y), (IsNotNHWC $x)]
>;

// If the inputs of zhigh.sub transitively/originally come from zAIU tensors
// in NHWC layout, then use the original zAIU tensors for zhigh.sub.
// In other words, propagate the layout NHWC down, so that other rules can be
// applied to remove stick/unstick pairs.

def SubLayoutPropagatePattern3 : Pat<
  (ZHighSubOp
     (ZHighStickOp (ZHighUnstickOp $x), $stickLayout),
     $y),
  (ZHighStickOp
     (ZHighUnstickOp
       (ZHighSubOp
         $x,
         (ZHighStickOp (ZHighUnstickOp $y), (GetLayout $x)),
         (returnType $x))),
     $stickLayout),
  [(IsNHWC $x), (IsNotNHWC $y)]
>;

def SubLayoutPropagatePattern4 : Pat<
  (ZHighSubOp
     $x,
     (ZHighStickOp (ZHighUnstickOp $y), $stickLayout)),
  (ZHighStickOp
     (ZHighUnstickOp
       (ZHighSubOp
         $y,
         (ZHighStickOp (ZHighUnstickOp $x), (GetLayout $y)),
         (returnType $y))),
     $stickLayout),
  [(IsNHWC $y), (IsNotNHWC $x)]
>;

// If the inputs of zhigh.mul transitively/originally come from zAIU tensors
// in NHWC layout, then use the original zAIU tensors for zhigh.mul.
// In other words, propagate the layout NHWC down, so that other rules can be
// applied to remove stick/unstick pairs.

def MulLayoutPropagatePattern3 : Pat<
  (ZHighMulOp
     (ZHighStickOp (ZHighUnstickOp $x), $stickLayout),
     $y),
  (ZHighStickOp
     (ZHighUnstickOp
       (ZHighMulOp
         $x,
         (ZHighStickOp (ZHighUnstickOp $y), (GetLayout $x)),
         (returnType $x))),
     $stickLayout),
  [(IsNHWC $x), (IsNotNHWC $y)]
>;

def MulLayoutPropagatePattern4 : Pat<
  (ZHighMulOp
     $x,
     (ZHighStickOp (ZHighUnstickOp $y), $stickLayout)),
  (ZHighStickOp
     (ZHighUnstickOp
       (ZHighMulOp
         $y,
         (ZHighStickOp (ZHighUnstickOp $x), (GetLayout $y)),
         (returnType $y))),
     $stickLayout),
  [(IsNHWC $y), (IsNotNHWC $x)]
>;

// If the inputs of zhigh.div transitively/originally come from zAIU tensors
// in NHWC layout, then use the original zAIU tensors for zhigh.div.
// In other words, propagate the layout NHWC down, so that other rules can be
// applied to remove stick/unstick pairs.

def DivLayoutPropagatePattern3 : Pat<
  (ZHighDivOp
     (ZHighStickOp (ZHighUnstickOp $x), $stickLayout),
     $y),
  (ZHighStickOp
     (ZHighUnstickOp
       (ZHighDivOp
         $x,
         (ZHighStickOp (ZHighUnstickOp $y), (GetLayout $x)),
         (returnType $x))),
     $stickLayout),
  [(IsNHWC $x), (IsNotNHWC $y)]
>;

def DivLayoutPropagatePattern4 : Pat<
  (ZHighDivOp
     $x,
     (ZHighStickOp (ZHighUnstickOp $y), $stickLayout)),
  (ZHighStickOp
     (ZHighUnstickOp
       (ZHighDivOp
         $y,
         (ZHighStickOp (ZHighUnstickOp $x), (GetLayout $y)),
         (returnType $y))),
     $stickLayout),
  [(IsNHWC $y), (IsNotNHWC $x)]
>;


// If the input of zhigh.relu transitively/originally comes from a zAIU tensor
// in NHWC layout, then use the original zAIU tensor for zhigh.relu.
// In other words, propagate the layout NHWC down, so that other rules can be
// applied to remove stick/unstick pairs.
def ReluLayoutPropagatePattern : Pat<
  (ZHighReluOp (ZHighStickOp (ZHighUnstickOp $x), $layout)),
  (ZHighStickOp (ZHighUnstickOp (ZHighReluOp $x, (returnType $x))), $layout),
  [(IsNHWC $x)]
>;

#endif // ZHIGH_LAYOUT_PROPAGATION


