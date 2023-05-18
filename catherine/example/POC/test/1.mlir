#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0)[s0] -> (d0 + 128, s0)>
#map2 = affine_map<(d0)[s0] -> (d0 + 64, s0)>
module {
  func.func @matmul(%arg0: memref<?x?xf32>, %arg1: memref<?x?xf32>) -> memref<?x?xf32> {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %dim = memref.dim %arg0, %c0 : memref<?x?xf32>
    %dim_0 = memref.dim %arg1, %c1 : memref<?x?xf32>
    %alloc = memref.alloc(%dim, %dim_0) : memref<?x?xf32>
    affine.for %arg2 = 0 to %dim step 128 {
      affine.for %arg3 = 0 to %dim_0 step 128 {
        affine.for %arg4 = #map(%arg2) to min #map1(%arg2)[%dim] {
          affine.for %arg5 = #map(%arg3) to min #map1(%arg3)[%dim_0] {
            affine.store %cst, %alloc[%arg4, %arg5] : memref<?x?xf32>
          }
        }
      }
    }
    %dim_1 = memref.dim %arg0, %c0 : memref<?x?xf32>
    %dim_2 = memref.dim %arg0, %c1 : memref<?x?xf32>
    %dim_3 = memref.dim %arg1, %c1 : memref<?x?xf32>
    affine.for %arg2 = 0 to %dim_1 step 128 {
      affine.for %arg3 = 0 to %dim_3 step 128 {
        affine.for %arg4 = 0 to %dim_2 step 64 {
          affine.for %arg5 = #map(%arg2) to min #map1(%arg2)[%dim_1] {
            affine.for %arg6 = #map(%arg3) to min #map1(%arg3)[%dim_3] {
              affine.for %arg7 = #map(%arg4) to min #map2(%arg4)[%dim_2] {
                %0 = affine.load %arg0[%arg5, %arg7] : memref<?x?xf32>
                %1 = affine.load %arg1[%arg7, %arg6] : memref<?x?xf32>
                %2 = affine.load %alloc[%arg5, %arg6] : memref<?x?xf32>
                %3 = arith.mulf %0, %1 : f32
                %4 = arith.addf %2, %3 : f32
                affine.store %4, %alloc[%arg5, %arg6] : memref<?x?xf32>
              }
            }
          }
        }
      }
    }
    return %alloc : memref<?x?xf32>
  }
}

