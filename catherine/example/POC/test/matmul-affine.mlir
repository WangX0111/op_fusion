// mlir-opt matmul.mlir --convert-linalg-to-affine-loops
module {
  func.func @matmul(%arg0: memref<8192x8192xf16>, %arg1: memref<8192x8192xf16>, %arg2: memref<8192x8192xf32>) {
    affine.for %arg3 = 0 to 8192 {
      affine.for %arg4 = 0 to 8192 {
        affine.for %arg5 = 0 to 8192 {
          %0 = affine.load %arg0[%arg3, %arg5] : memref<8192x8192xf16>
          %1 = affine.load %arg1[%arg5, %arg4] : memref<8192x8192xf16>
          %2 = affine.load %arg2[%arg3, %arg4] : memref<8192x8192xf32>
          %3 = arith.extf %0 : f16 to f32
          %4 = arith.extf %1 : f16 to f32
          %5 = arith.mulf %3, %4 : f32
          %6 = arith.addf %2, %5 : f32
          affine.store %6, %arg2[%arg3, %arg4] : memref<8192x8192xf32>
        }
      }
    }
    return
  }
}