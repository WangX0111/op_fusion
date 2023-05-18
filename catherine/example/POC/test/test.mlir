// RUN: mlir-opt %s -convert-linalg-to-loops -convert-scf-to-cf -convert-linalg-to-llvm -convert-memref-to-llvm -convert-func-to-llvm -reconcile-unrealized-casts | \
// RUN: mlir-cpu-runner -O3 -e main -entry-point-result=void \
// RUN:   -shared-libs=%mlir_lib_dir/libmlir_runner_utils%shlibext \
// RUN: | FileCheck %s
func.func private @printMemrefF32(memref<*xf32>)

// func.func @matmul(%a : memref<8192x8192xf16>, %b : memref<8192x8192xf16>, %c : memref<8192x8192xf32>) {

//     linalg.matmul 
//     ins(%a, %b: memref<8192x8192xf16>, memref<8192x8192xf16>)
//     outs(%c:memref<8192x8192xf32>)
//     return
//     }

#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0) -> (d0 + 128)>
#map2 = affine_map<(d0) -> (d0 + 64)>

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



func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index


  %m = arith.constant 8192 : index
  %n1 = arith.constant 8192 : index
  %n2 = arith.constant 8192 : index
  %num_flops_total_f = arith.constant 1.024e12 : f64

  %val1 = arith.constant 1.0 : f16
  %val2 = arith.constant 1.0 : f32

  %A = memref.alloc() : memref<8192x8192xf16>
  %B = memref.alloc() : memref<8192x8192xf16>
  %C = memref.alloc() : memref<8192x8192xf32>

  linalg.fill ins(%val1 : f16) outs(%A : memref<8192x8192xf16>)
  linalg.fill ins(%val1 : f16) outs(%B : memref<8192x8192xf16>)
  linalg.fill ins(%val2 : f32) outs(%C : memref<8192x8192xf32>)

  %t_start = call @rtclock() : () -> f64
  call @matmul(%A, %B, %C) : (memref<8192x8192xf16>, memref<8192x8192xf16>, memref<8192x8192xf32>) -> ()
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

  memref.dealloc %A : memref<8192x8192xf16>
  memref.dealloc %B : memref<8192x8192xf16>
  memref.dealloc %C : memref<8192x8192xf32>

  return
}

func.func private @printFlops(f64)
func.func private @rtclock() -> f64
