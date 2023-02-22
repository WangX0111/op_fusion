// RUN: mlir-opt -hopt -convert-linalg-to-loops -lower-affine -convert-std-to-llvm %s | mlir-cpu-runner -O3 -e main -entry-point-result=void -shared-libs=%mlir_runner_utils_dir/libmlir_runner_utils%shlibext | FileCheck %s
module {
  func.func @matmul_blis(%arg0: memref<2088x2048xf64>, %arg1: memref<2048x2048xf64>,
            %arg2: memref<2088x2048xf64>) {
    // blis.matmul %A, %B, %C, { }: memref<2088x2048xf64>, memref<2048x2048xf64>, memref<2088x2048xf64>
    return 

    // "blis.matmul"(%arg0, %arg1, %arg2) {
    //   M_C = 330 : i32, N_C = 2048 : i32, K_C = 480 : i32, M_R = 3, N_R = 16 : i32, K_U = 4 : i32
    // } : (memref<2088x2048xf64>, memref<2048x2048xf64>, memref<2088x2048xf64>) -> ()
    // return
  }

  func.func @main() {
    %A = memref.alloc() : memref<2088x2048xf64>
    // Align %B and %C since these are shape cast to vector types.
    %B = memref.alloc() {alignment = 32} : memref<2048x2048xf64>
    %C = memref.alloc() {alignment = 32} : memref<2088x2048xf64>

    %cf1 = arith.constant 1.00000e+00 : f64
    linalg.fill
     ins(%cf1 : f64)
    outs(%A : memref<2088x2048xf64>)

    linalg.fill
     ins(%cf1 : f64)
    outs(%B : memref<2048x2048xf64>)

    %reps = arith.constant 5 : index

    %t_start = call @rtclock() : () -> (f64)
    affine.for %ti = 0 to %reps {
      linalg.fill
       ins(%cf1 : f64)
      outs(%C : memref<2088x2048xf64>)
      blis.matmul ( %A, %B, %C ) : ( memref<2088x2048xf64>, memref<2048x2048xf64>, memref<2088x2048xf64> )

      // call @matmul_blis(%A, %B, %C) : (memref<2088x2048xf64>, memref<2048x2048xf64>, memref<2088x2048xf64>) -> ()
    }
    %t_end = call @rtclock() : () -> (f64)
    // call @print_memref_2d_f64(%C): (memref<2088x2048xf64>) -> ()

    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %M = memref.dim %C, %c0 : memref<2088x2048xf64>
    %N = memref.dim %C, %c1 : memref<2088x2048xf64>
    %K = memref.dim %A, %c1 : memref<2088x2048xf64>

    %t = arith.subf %t_end, %t_start : f64
    %f1 = arith.muli %M, %N : index
    %f2 = arith.muli %f1, %K : index
    // 2*M*N*K.
    %c2 = arith.constant 2 : index
    %f3 = arith.muli %c2, %f2 : index
    %num_flops = arith.muli %reps, %f3 : index
    %num_flops_i = arith.index_cast %num_flops : index to i64
    %num_flops_f = arith.sitofp %num_flops_i : i64 to f64
    %flops = arith.divf %num_flops_f, %t : f64
    call @print_flops(%flops) : (f64) -> ()

    return
  }
  // CHECK: 2049,   2049,   2049,

  func.func private @print_flops(f64) -> ()
  func.func private @rtclock() -> (f64)
  func.func private @print_memref_2d_f64(memref<2088x2048xf64>)

  
}