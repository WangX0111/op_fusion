// RUN: mlir-opt %s -convert-linalg-to-loops -convert-scf-to-cf -convert-linalg-to-llvm -convert-memref-to-llvm -convert-func-to-llvm -reconcile-unrealized-casts | \
// RUN: mlir-cpu-runner -O3 -e main -entry-point-result=void \
// RUN:   -shared-libs=%mlir_lib_dir/libmlir_runner_utils%shlibext \
// RUN: | FileCheck %s
func.func private @printMemrefF32(memref<*xf32>)

#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> (d0 + 128)>
#map2 = affine_map<(d0, d1, d2) -> (d0)>
#map3 = affine_map<(d0, d1, d2) -> (d2)>
#map4 = affine_map<(d0) -> (d0 + 64)>
#map5 = affine_map<(d0, d1, d2) -> (d1)>
#map6 = affine_map<(d0, d1, d2, d3) -> (d0)>
#map7 = affine_map<(d0, d1, d2, d3) -> (d1)>

#mapt = affine_map<(d0) -> (d0)>
#mapt1 = affine_map<(d0)[s0] -> (d0 + 128, s0)>
#mapt2 = affine_map<(d0)[s0] -> (d0 + 64, s0)>

func.func @matmul(%A: memref<?x?xf32>, %B: memref<?x?xf32>) -> (memref<?x?xf32>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %f0 = arith.constant 0.0 : f32
  %x = memref.dim %A, %c0 : memref<?x?xf32>
  %y = memref.dim %B, %c1 : memref<?x?xf32>
  %C = memref.alloc(%x, %y) : memref<?x?xf32>
  linalg.fill ins(%f0 : f32) outs(%C : memref<?x?xf32>)
  linalg.matmul ins(%A, %B: memref<?x?xf32>, memref<?x?xf32>)
                outs(%C: memref<?x?xf32>)
  return %C : memref<?x?xf32>
}


func.func @matmul_affine(%arg0: memref<?x?xf32>, %arg1: memref<?x?xf32>) -> memref<?x?xf32> {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cst = arith.constant 0.000000e+00 : f32
  %dim = memref.dim %arg0, %c0 : memref<?x?xf32>
  %dim_0 = memref.dim %arg1, %c1 : memref<?x?xf32>
  %alloc = memref.alloc(%dim, %dim_0) : memref<?x?xf32>
  affine.for %arg2 = 0 to %dim {
    affine.for %arg3 = 0 to %dim_0 {
      affine.store %cst, %alloc[%arg2, %arg3] : memref<?x?xf32>
    }
  }
  %dim_1 = memref.dim %arg0, %c0 : memref<?x?xf32>
  %dim_2 = memref.dim %arg0, %c1 : memref<?x?xf32>
  %dim_3 = memref.dim %arg1, %c1 : memref<?x?xf32>
  affine.for %arg2 = 0 to %dim_1 {
    affine.for %arg3 = 0 to %dim_3 {
      affine.for %arg4 = 0 to %dim_2 {
        %0 = affine.load %arg0[%arg2, %arg4] : memref<?x?xf32>
        %1 = affine.load %arg1[%arg4, %arg3] : memref<?x?xf32>
        %2 = affine.load %alloc[%arg2, %arg3] : memref<?x?xf32>
        %3 = arith.mulf %0, %1 : f32
        %4 = arith.addf %2, %3 : f32
        affine.store %4, %alloc[%arg2, %arg3] : memref<?x?xf32>
      }
    }
  }
  return %alloc : memref<?x?xf32>
}

func.func @matmul_tile(%arg0: memref<?x?xf32>, %arg1: memref<?x?xf32>) -> memref<?x?xf32> {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cst = arith.constant 0.000000e+00 : f32
  %dim = memref.dim %arg0, %c0 : memref<?x?xf32>
  %dim_0 = memref.dim %arg1, %c1 : memref<?x?xf32>
  %alloc = memref.alloc(%dim, %dim_0) : memref<?x?xf32>
  affine.for %arg2 = 0 to %dim step 128 {
    affine.for %arg3 = 0 to %dim_0 step 128 {
      affine.for %arg4 = #mapt(%arg2) to min #mapt1(%arg2)[%dim] {
        affine.for %arg5 = #mapt(%arg3) to min #mapt1(%arg3)[%dim_0] {
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
        affine.for %arg5 = #mapt(%arg2) to min #mapt1(%arg2)[%dim_1] {
          affine.for %arg6 = #mapt(%arg3) to min #mapt1(%arg3)[%dim_3] {
            affine.for %arg7 = #mapt(%arg4) to min #mapt2(%arg4)[%dim_2] {
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

func.func @matmul_buf(%arg0: memref<8192x8192xf16>, %arg1: memref<8192x8192xf16>, %arg2: memref<8192x8192xf32>) {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c1_0 = arith.constant 1 : index
    %c0_1 = arith.constant 0 : index
    %c64 = arith.constant 64 : index
    %c0_2 = arith.constant 0 : index
    %c64_3 = arith.constant 64 : index
    %c0_4 = arith.constant 0 : index
    %c0_5 = arith.constant 0 : index
    affine.for %arg3 = 0 to 8192 step 128 {
      affine.for %arg4 = 0 to 8192 step 128 {
        affine.for %arg5 = 0 to 8192 step 64 {
          affine.for %arg6 = #map(%arg3) to #map1(%arg3) {
            %0 = affine.apply #map2(%arg6, %arg3, %arg5)
            %1 = affine.apply #map3(%arg6, %arg3, %arg5)
            %alloc = memref.alloc() : memref<1x64xf16, 1>
            affine.for %arg7 = #map(%arg5) to #map4(%arg5) {
              %2 = affine.load %arg0[%arg6, %arg7] : memref<8192x8192xf16>
              affine.store %2, %alloc[0, %arg7 - %arg5] : memref<1x64xf16, 1>
            }
            affine.for %arg7 = #map(%arg4) to #map1(%arg4) {
              %2 = affine.apply #map5(%arg7, %arg5, %arg4)
              %3 = affine.apply #map2(%arg7, %arg5, %arg4)
              %alloc_6 = memref.alloc() : memref<64x1xf16, 1>
              affine.for %arg8 = #map(%arg5) to #map4(%arg5) {
                %10 = affine.load %arg1[%arg8, %arg7] : memref<8192x8192xf16>
                affine.store %10, %alloc_6[%arg8 - %arg5, 0] : memref<64x1xf16, 1>
              }
              %4 = affine.apply #map6(%arg6, %arg7, %arg3, %arg4)
              %5 = affine.apply #map7(%arg6, %arg7, %arg3, %arg4)
              %alloc_7 = memref.alloc() : memref<1x1xf32, 1>
              %6 = affine.load %arg2[%arg6, %arg7] : memref<8192x8192xf32>
              affine.store %6, %alloc_7[0, 0] : memref<1x1xf32, 1>
              affine.for %arg8 = #map(%arg5) to #map4(%arg5) {
                %10 = affine.load %alloc[0, -%arg5 + %arg8] : memref<1x64xf16, 1>
                %11 = affine.load %alloc_6[-%arg5 + %arg8, 0] : memref<64x1xf16, 1>
                %12 = affine.load %alloc_7[0, 0] : memref<1x1xf32, 1>
                %13 = arith.extf %10 : f16 to f32
                %14 = arith.extf %11 : f16 to f32
                %15 = arith.mulf %13, %14 : f32
                %16 = arith.addf %12, %15 : f32
                affine.store %16, %alloc_7[0, 0] : memref<1x1xf32, 1>
              }
              %7 = affine.apply #map6(%arg6, %arg7, %arg3, %arg4)
              %8 = affine.apply #map7(%arg6, %arg7, %arg3, %arg4)
              %9 = affine.load %alloc_7[0, 0] : memref<1x1xf32, 1>
              affine.store %9, %arg2[%arg6, %arg7] : memref<8192x8192xf32>
              memref.dealloc %alloc_7 : memref<1x1xf32, 1>
              memref.dealloc %alloc_6 : memref<64x1xf16, 1>
            }
            memref.dealloc %alloc : memref<1x64xf16, 1>
          }
        }
      }
    }
    return
  }


func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index

  %m = arith.constant 800 : index
  %n1 = arith.constant 800 : index
  %n2 = arith.constant 800 : index
  // %p = arith.constant 300 : index
  %num_flops_total_f = arith.constant 1.0e+9 : f64

  %val1 = arith.constant 13.0 : f32
  %val2 = arith.constant 17.0 : f32
  %A = memref.alloc(%m, %n1) : memref<?x?xf32>
  %B = memref.alloc(%n1, %n2) : memref<?x?xf32>
  // %C = memref.alloc(%n2, %p) : memref<?x?xf32>
  linalg.fill ins(%val1 : f32) outs(%A : memref<?x?xf32>)
  linalg.fill ins(%val1 : f32) outs(%B : memref<?x?xf32>)
  // linalg.fill ins(%val2 : f32) outs(%C : memref<?x?xf32>)
  memref.store %val1, %B[%c0, %c0] : memref<?x?xf32>
  %t_start = call @rtclock() : () -> f64
  %D = call @matmul(%A, %B) : (memref<?x?xf32>, memref<?x?xf32>) -> memref<?x?xf32>
  // %E = call @matmul(%D, %C) : (memref<?x?xf32>, memref<?x?xf32>) -> memref<?x?xf32>
  %t_end = call @rtclock() : () -> f64
  %t = arith.subf %t_end, %t_start : f64
  vector.print %t : f64 

  // num_flops_per_iter = 2*M*N*K
  %f1 = arith.muli %m, %n1 : index
  %f2 = arith.muli %f1, %n2 : index
  %num_flops_per_iter = arith.muli %c2, %f2 : index

  // num_flops_total = num_flops_per_iter * num_reps
  %num_flops_total = arith.muli %num_flops_per_iter, %c1: index
  vector.print %num_flops_total : index

  %flops_per_s = arith.divf %num_flops_total_f, %t : f64
  vector.print %flops_per_s : f64

  call @printFlops(%flops_per_s) : (f64) -> ()

  //***********************Affine*******************************//
  %t_start_affine = call @rtclock() : () -> f64
  call @matmul_affine(%A, %B) : (memref<?x?xf32>, memref<?x?xf32>) -> memref<?x?xf32>
  %t_end_affine = call @rtclock() : () -> f64
  %t_affine = arith.subf %t_end_affine, %t_start_affine : f64
  vector.print %t_affine : f64 

  %flops_per_s_affine = arith.divf %num_flops_total_f, %t_affine : f64

  call @printFlops(%flops_per_s_affine) : (f64) -> ()

  //***********************Tile*******************************//

  %t_start_tile = call @rtclock() : () -> f64
  call @matmul_tile(%A, %B) : (memref<?x?xf32>, memref<?x?xf32>) -> memref<?x?xf32>
  %t_end_tile = call @rtclock() : () -> f64
  %t_tile = arith.subf %t_end_tile, %t_start_tile : f64
  vector.print %t_tile : f64 

  %flops_per_s_tile = arith.divf %num_flops_total_f, %t_tile : f64

  call @printFlops(%flops_per_s_tile) : (f64) -> ()

  //***********************Bufferize*******************************//
  %t_start_buf = call @rtclock() : () -> f64
  call @matmul_tile(%A, %B) : (memref<?x?xf32>, memref<?x?xf32>) -> memref<?x?xf32>
  %t_end_buf = call @rtclock() : () -> f64
  %t_buf = arith.subf %t_end_buf, %t_start_buf : f64
  vector.print %t_buf : f64 

  %flops_per_s_buf = arith.divf %num_flops_total_f, %t_buf : f64

  call @printFlops(%flops_per_s_buf) : (f64) -> ()

  memref.dealloc %A : memref<?x?xf32>
  memref.dealloc %B : memref<?x?xf32>
  // memref.dealloc %C : memref<?x?xf32>
  memref.dealloc %D : memref<?x?xf32>
  // memref.dealloc %E : memref<?x?xf32>
  return
}

func.func private @printFlops(f64)
func.func private @rtclock() -> f64
