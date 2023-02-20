#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0, d1)[s0, s1] -> (d0 * s1 + s0 + d1)>
#map2 = affine_map<(d0)[s0] -> (d0 + 1, s0 - 1)>
#map3 = affine_map<(d0)[s0] -> (d0, s0 - 1)>
#map4 = affine_map<(d0, d1) -> (0)>
#map5 = affine_map<(d0) -> (d0 + 16)>
#map6 = affine_map<(d0) -> (d0 + 32)>
#map7 = affine_map<(d0) -> (d0 + 48)>
module {
  func.func private @printMemrefF32(memref<*xf32>)
  func.func @matmul(%arg0: memref<?x?xf32>, %arg1: memref<?x?xf32>, %arg2: memref<?x?xf32>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c0_0 = arith.constant 0 : index
    %dim = memref.dim %arg0, %c0_0 : memref<?x?xf32>
    %c1_1 = arith.constant 1 : index
    %dim_2 = memref.dim %arg1, %c1_1 : memref<?x?xf32>
    %c1_3 = arith.constant 1 : index
    %dim_4 = memref.dim %arg0, %c1_3 : memref<?x?xf32>
    affine.for %arg3 = #map(%c0) to #map(%dim_2) step 64 {
      affine.for %arg4 = #map(%c0) to #map(%dim) step 2 {
        %subview = memref.subview %arg0[%arg4, %c0] [%c1, %dim_4] [%c1, %c1] : memref<?x?xf32> to memref<?x?xf32, #map1>
        %0 = affine.min #map2(%arg4)[%dim]
        %subview_5 = memref.subview %arg0[%0, %c0] [%c1, %dim_4] [%c1, %c1] : memref<?x?xf32> to memref<?x?xf32, #map1>
        %1 = affine.min #map3(%arg4)[%dim]
        %subview_6 = memref.subview %arg2[%1, %c0] [%c1, %dim_2] [%c1, %c1] : memref<?x?xf32> to memref<?x?xf32, #map1>
        %2 = affine.min #map2(%arg4)[%dim]
        %subview_7 = memref.subview %arg2[%2, %c0] [%c1, %dim_2] [%c1, %c1] : memref<?x?xf32> to memref<?x?xf32, #map1>
        affine.for %arg5 = #map(%c0) to #map(%dim_4) {
          %cst = arith.constant 0.000000e+00 : f32
          %3 = vector.transfer_read %subview[%c0, %arg5], %cst {permutation_map = #map4} : memref<?x?xf32, #map1>, vector<16xf32>
          %cst_8 = arith.constant 0.000000e+00 : f32
          %4 = vector.transfer_read %subview_5[%c0, %arg5], %cst_8 {permutation_map = #map4} : memref<?x?xf32, #map1>, vector<16xf32>
          %5 = affine.apply #map(%arg3)
          %cst_9 = arith.constant 0.000000e+00 : f32
          %6 = vector.transfer_read %subview_6[%c0, %5], %cst_9 : memref<?x?xf32, #map1>, vector<16xf32>
          %7 = affine.apply #map5(%arg3)
          %cst_10 = arith.constant 0.000000e+00 : f32
          %8 = vector.transfer_read %subview_6[%c0, %7], %cst_10 : memref<?x?xf32, #map1>, vector<16xf32>
          %9 = affine.apply #map6(%arg3)
          %cst_11 = arith.constant 0.000000e+00 : f32
          %10 = vector.transfer_read %subview_6[%c0, %9], %cst_11 : memref<?x?xf32, #map1>, vector<16xf32>
          %11 = affine.apply #map7(%arg3)
          %cst_12 = arith.constant 0.000000e+00 : f32
          %12 = vector.transfer_read %subview_6[%c0, %11], %cst_12 : memref<?x?xf32, #map1>, vector<16xf32>
          %13 = affine.apply #map(%arg3)
          %cst_13 = arith.constant 0.000000e+00 : f32
          %14 = vector.transfer_read %subview_7[%c0, %13], %cst_13 : memref<?x?xf32, #map1>, vector<16xf32>
          %15 = affine.apply #map5(%arg3)
          %cst_14 = arith.constant 0.000000e+00 : f32
          %16 = vector.transfer_read %subview_7[%c0, %15], %cst_14 : memref<?x?xf32, #map1>, vector<16xf32>
          %17 = affine.apply #map6(%arg3)
          %cst_15 = arith.constant 0.000000e+00 : f32
          %18 = vector.transfer_read %subview_7[%c0, %17], %cst_15 : memref<?x?xf32, #map1>, vector<16xf32>
          %19 = affine.apply #map7(%arg3)
          %cst_16 = arith.constant 0.000000e+00 : f32
          %20 = vector.transfer_read %subview_7[%c0, %19], %cst_16 : memref<?x?xf32, #map1>, vector<16xf32>
          %cst_17 = arith.constant 0.000000e+00 : f32
          %21 = vector.transfer_read %arg1[%arg5, %arg3], %cst_17 : memref<?x?xf32>, vector<16xf32>
          %22 = affine.apply #map5(%arg3)
          %cst_18 = arith.constant 0.000000e+00 : f32
          %23 = vector.transfer_read %arg1[%arg5, %22], %cst_18 : memref<?x?xf32>, vector<16xf32>
          %24 = affine.apply #map6(%arg3)
          %cst_19 = arith.constant 0.000000e+00 : f32
          %25 = vector.transfer_read %arg1[%arg5, %24], %cst_19 : memref<?x?xf32>, vector<16xf32>
          %26 = affine.apply #map7(%arg3)
          %cst_20 = arith.constant 0.000000e+00 : f32
          %27 = vector.transfer_read %arg1[%arg5, %26], %cst_20 : memref<?x?xf32>, vector<16xf32>
          %28 = vector.fma %3, %21, %6 : vector<16xf32>
          %29 = vector.fma %3, %23, %8 : vector<16xf32>
          %30 = vector.fma %3, %25, %10 : vector<16xf32>
          %31 = vector.fma %3, %27, %12 : vector<16xf32>
          %32 = vector.fma %4, %21, %14 : vector<16xf32>
          %33 = vector.fma %4, %23, %16 : vector<16xf32>
          %34 = vector.fma %4, %25, %18 : vector<16xf32>
          %35 = vector.fma %4, %27, %20 : vector<16xf32>
          %36 = affine.apply #map(%arg3)
          vector.transfer_write %28, %subview_6[%c0, %36] : vector<16xf32>, memref<?x?xf32, #map1>
          %37 = affine.apply #map5(%arg3)
          vector.transfer_write %29, %subview_6[%c0, %37] : vector<16xf32>, memref<?x?xf32, #map1>
          %38 = affine.apply #map6(%arg3)
          vector.transfer_write %30, %subview_6[%c0, %38] : vector<16xf32>, memref<?x?xf32, #map1>
          %39 = affine.apply #map7(%arg3)
          vector.transfer_write %31, %subview_6[%c0, %39] : vector<16xf32>, memref<?x?xf32, #map1>
          %40 = affine.apply #map(%arg3)
          vector.transfer_write %32, %subview_7[%c0, %40] : vector<16xf32>, memref<?x?xf32, #map1>
          %41 = affine.apply #map5(%arg3)
          vector.transfer_write %33, %subview_7[%c0, %41] : vector<16xf32>, memref<?x?xf32, #map1>
          %42 = affine.apply #map6(%arg3)
          vector.transfer_write %34, %subview_7[%c0, %42] : vector<16xf32>, memref<?x?xf32, #map1>
          %43 = affine.apply #map7(%arg3)
          vector.transfer_write %35, %subview_7[%c0, %43] : vector<16xf32>, memref<?x?xf32, #map1>
        }
      }
    }
    return
  }
  func.func @main() {
    %c4 = arith.constant 4 : index
    %c4_0 = arith.constant 4 : index
    %c4_1 = arith.constant 4 : index
    %cst = arith.constant 1.000000e+00 : f32
    %alloc = memref.alloc(%c4, %c4_1) : memref<?x?xf32>
    %alloc_2 = memref.alloc(%c4_1, %c4_0) : memref<?x?xf32>
    %alloc_3 = memref.alloc(%c4, %c4_0) : memref<?x?xf32>
    linalg.fill ins(%cst : f32) outs(%alloc : memref<?x?xf32>)
    linalg.fill ins(%cst : f32) outs(%alloc_2 : memref<?x?xf32>)
    linalg.fill ins(%cst : f32) outs(%alloc_3 : memref<?x?xf32>)
    call @matmul(%alloc, %alloc_2, %alloc_3) : (memref<?x?xf32>, memref<?x?xf32>, memref<?x?xf32>) -> ()
    %cast = memref.cast %alloc_3 : memref<?x?xf32> to memref<*xf32>
    call @printMemrefF32(%cast) : (memref<*xf32>) -> ()
    memref.dealloc %alloc_3 : memref<?x?xf32>
    memref.dealloc %alloc_2 : memref<?x?xf32>
    memref.dealloc %alloc : memref<?x?xf32>
    return
  }
}

