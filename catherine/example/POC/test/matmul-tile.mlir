// The tile sizes are chosen based on the tile-size selection model discussed in Section 5
// The key objective of the tiling is to maximize the ratio of computation operations to memory operations.
// Multi-level tiling using the affineLoopTiling, followed by affineDataCopyGenerate to create copy nests for global to shared data copy

// mlir-opt matmul-affine.mlir --affine-loop-tile="cache-size=48 tile-sizes=128,128,64"


#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> (d0 + 128)>
#map2 = affine_map<(d0) -> (d0 + 64)>
module {
  func.func @matmul(%a: memref<8192x8192xf16>, %b: memref<8192x8192xf16>, %c: memref<8192x8192xf32>) {
    affine.for %arg0 = 0 to 8192 step 128 {
      affine.for %arg1 = 0 to 8192 step 128 {
        affine.for %arg2 = 0 to 8192 step 64 {
          affine.for %arg3 = 0 to 8192 step 64 {
            affine.for %arg4 = 0 to 8192 step 64 {
              affine.for %arg5 = 0 to 8192 step 32 {
                affine.for %arg6 = 0 to 64 {
                  affine.for %arg7 = 0 to 64 {
                    affine.for %arg8 = 0 to 32 {
                      %0 = affine.load %a[%arg0 + %arg3 + %arg6, %arg2 + %arg5 + %arg8] : memref<8192x8192xf16>
                      %1 = affine.load %b[%arg2 + %arg5 + %arg8,%arg1 + %arg4 + %arg7] : memref<8192x8192xf16>
                      %2 = affine.load %c[%arg0 + %arg3 + %arg6, %arg1 + %arg4 + %arg7] : memref<8192x8192xf32>
                      %3 = arith.mulf %0, %1 : f16
                      %4 = arith.extf %3 : f16 to f32
                      %5 = arith.addf %2, %4 : f32
                      affine.store %5, %c[%arg0 + %arg3 + %arg6, %arg1 + %arg4 + %arg7] : memref<8192x8192xf32>
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return
  }
}
