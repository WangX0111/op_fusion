
// fuse ops to a group
module {
  func.func @main(%A : memref<2088x2048xf64>, %B: memref<2048x2048xf64>, %C: memref<2088x2048xf64>)  {
    linalg.matmul ins(%A, %B : memref<2088x2048xf64>, memref<2048x2048xf64>) outs(%C : memref<2088x2048xf64>)
  return
  }
}
// func.func @matmul_nn_const_weight_with_epilogue0(%arg1: memref<1024x1024xf32, "cpu">,
//                                                  %arg2: memref<?x1024xf32, "cpu">, %arg3: memref<?x1024xf32, "cpu">,
//                                                  %arg4: memref<f32, "cpu">,
//                                                  %arg5: memref<2xindex, "cpu">) -> (memref<?x1024xf32, "cpu">) {
//   "lmhlo.constant"(%arg1) {disc.device = "cpu", value = dense<-1.0> : tensor<1024x1024xf32>} : (memref<1024x1024xf32, "cpu">) -> ()
//   %c0 = arith.constant 0 : index
//   %d0 = memref.dim %arg2, %c0 : memref<?x1024xf32, "cpu">
//   %t0 = memref.alloc(%d0) {kDiscSymbolicDimAttr = [@S0, @C1024]} : memref<?x1024xf32, "cpu">
//   // TRANSFORM: "lmhlo.fusion"() ({
//   // TRANSFORM-NEXT: lmhlo.constant
//   // TRANSFORM-SAME: value = dense<-1.000000e+00>
//   // TRANSFORM-NEXT: lmhlo.dot_general
//   // TRANSFORM-NEXT: lmhlo.constant
//   // TRANSFORM-SAME: value = dense<1.000000e+00>
//   // TRANSFORM-NEXT: lmhlo.dynamic_broadcast_in_dim
//   // TRANSFORM-NEXT: lmhlo.add
//   // TRANSFORM-NEXT: lmhlo.terminator
//   // TRANSFORM-NEXT: })
//   // TRANSFORM-SAME: disc.fusion_type = "kTransform"
//   "lmhlo.dot_general"(%arg2, %arg1, %t0) {dot_dimension_numbers = #mhlo.dot<lhs_contracting_dimensions = [1], rhs_contracting_dimensions = [0]>} : (memref<?x1024xf32, "cpu">, memref<1024x1024xf32, "cpu">, memref<?x1024xf32, "cpu">) -> ()
//   "lmhlo.constant"(%arg4) {disc.device = "cpu", value = dense<1.0> : tensor<f32>} : (memref<f32, "cpu">) -> ()
//   %t1 = memref.alloc(%d0) {kDiscSymbolicDimAttr = [@S0, @C1024]} : memref<?x1024xf32, "cpu">
//   "lmhlo.dynamic_broadcast_in_dim"(%arg4, %arg5, %t1) {disc.device = "cpu", broadcast_dimensions = dense<[]> : tensor<0xi64>} : (memref<f32, "cpu">, memref<2xindex, "cpu">, memref<?x1024xf32, "cpu">) -> ()
//   %t2 = memref.alloc(%d0) {kDiscSymbolicDimAttr = [@S0, @C1024]} : memref<?x1024xf32, "cpu">
//   "lmhlo.add"(%t0, %t1, %t2) :  (memref<?x1024xf32, "cpu">, memref<?x1024xf32, "cpu">, memref<?x1024xf32, "cpu">) -> ()
//   return %t2 : memref<?x1024xf32, "cpu">
// }

// -----

// judge groups based on rules

// CHECK-LABEL: @fuse_and_duplicate_with_erase
// func.func @fuse_and_duplicate_with_erase(%arg0: memref<2x3xf32, "gpu">) -> (memref<2x3xf32, "gpu">, memref<2x3xf32, "gpu">) {
//   // CHECK: memref.alloc
//   // CHECK: memref.alloc
//   // CHECK: memref.alloc
//   // CHECK: memref.alloc
//   // CHECK: memref.alloc
//   // CHECK: memref.alloc
//   %0 = memref.alloc() : memref<2x3xf32, "gpu">
//   %1 = memref.alloc() : memref<2x3xf32, "gpu">
//   %2 = memref.alloc() : memref<2x3xf32, "gpu">
//   %3 = memref.alloc() : memref<2x3xf32, "gpu">
//   // CHECK-NOT: lmhlo.constant
//   "lmhlo.constant"(%0) {value = dense<0.000000e+00> : tensor<2x3xf32>} : (memref<2x3xf32, "gpu">) -> ()
//   // CHECK: lmhlo.fusion
//   "lmhlo.fusion"() ({
//     // CHECK: lmhlo.constant
//     "lmhlo.abs"(%arg0, %1) : (memref<2x3xf32, "gpu">, memref<2x3xf32, "gpu">) -> ()
//     "lmhlo.add"(%1, %0, %2) : (memref<2x3xf32, "gpu">, memref<2x3xf32, "gpu">, memref<2x3xf32, "gpu">) -> ()
//     "lmhlo.terminator"() : () -> ()
//   }) : () -> ()
//   // CHECK: lmhlo.fusion
//   "lmhlo.fusion"() ({
//     // CHECK: lmhlo.constant
//     "lmhlo.abs"(%0, %1) : (memref<2x3xf32, "gpu">, memref<2x3xf32, "gpu">) -> ()
//     "lmhlo.add"(%1, %arg0, %3) : (memref<2x3xf32, "gpu">, memref<2x3xf32, "gpu">, memref<2x3xf32, "gpu">) -> ()
//     "lmhlo.terminator"() : () -> ()
//   }) : () -> ()
//   return %2, %3 : memref<2x3xf32, "gpu">, memref<2x3xf32, "gpu">
// }
