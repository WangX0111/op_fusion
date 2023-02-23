// mlir-opt -hopt='vect=true,copy=true,unroll=true,scalrep=true' dgemm-tiled-benchmark.mlir -convert-linalg-to-loops -lower-affine -convert-scf-to-std -convert-std-to-llvm='use-aligned-alloc=1'  -canonicalize  | mlir-cpu-runner  -O3  -e main -time -reps=5   -entry-point-result=void    -shared-libs=lib/libmlir

// Driver for the matmul with initialization and GFLOPS reporting.
func.func @main() {
  %A = memref.alloc() : memref<2088x2048xf64>
  // Align %B and %C since these are shape cast to vector types.
  %B = memref.alloc() {alignment = 32} : memref<2048x2048xf64>
  %C = memref.alloc() {alignment = 32} : memref<2088x2048xf64>

  %cf1 = arith.constant 1.00000e+00 : f64
  // %A = arith.constant dense<[1.00000e+00]> : memref<2088x2048xf64>
  // %B = arith.constant dense<1.0> : memref<2048x2048xf64>

  linalg.fill
   ins(%cf1 : f64)
  outs(%A : memref<2088x2048xf64>)

  linalg.fill
   ins(%cf1 : f64)
  outs(%B : memref<2048x2048xf64>)


  %reps = arith.constant 5 : index

  %t_start = call @rtclock() : () -> (f64)
  affine.for %ti = 0 to %reps {
    // %C = arith.constant dense<1.0> : memref<2088x2048xf64>
    linalg.fill
     ins(%cf1 : f64)
    outs(%C : memref<2088x2048xf64>)
    func.call @matmul(%A, %B, %C) : (memref<2088x2048xf64>, memref<2048x2048xf64>, memref<2088x2048xf64>) -> ()
  }
  %t_end = call @rtclock() : () -> (f64)
  %pC = memref.cast %C : memref<2088x2048xf64> to memref<*xf64>
  call @print_memref_f64(%pC): (memref<*xf64>) -> ()

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

#K_UB = affine_map<(d0) -> (480, d0 * -480 + 2048)>
#I_LB = affine_map<(d0) -> (d0 * 110)>
#I_UB = affine_map<(d0) -> (696, d0 * 110 + 110)>

// This is a pre-tiled matmul loop nest matching the OpenBLAS/BLIS
// tiling strategy with L3 tiling being ignored:
// (i, j, k) -> (k, i, jj, ii, kk, jjR, iiR)
// With L3 tiling, this would have been:
// (i, j, k) -> (j, k, i, jj, ii, kk, jjR, iiR)
func.func @matmul(%arg0: memref<2088x2048xf64>, %arg1: memref<2048x2048xf64>, %arg2: memref<2088x2048xf64>) {
  affine.for %k = 0 to 5 {
    affine.for %i = 0 to 7 {
      affine.for %jj = 0 to 128 {
        affine.for %ii = #I_LB(%i) to min #I_UB(%i) {
          affine.for %kk = 0 to min #K_UB(%k) {
            affine.for %jjR = 0 to 16 {
              affine.for %iiR = 0 to 3 {
                %0 = affine.load %arg0[%ii * 3 + %iiR, %k * 480 + %kk] : memref<2088x2048xf64>
                %1 = affine.load %arg1[%k * 480 + %kk, %jj * 16 + %jjR] : memref<2048x2048xf64>
                %2 = affine.load %arg2[%ii * 3 + %iiR, %jj * 16 + %jjR] : memref<2088x2048xf64>
                %3 = arith.mulf %0, %1 : f64
                %4 = arith.addf %3, %2 : f64
                affine.store %4, %arg2[%ii * 3 + %iiR, %jj * 16 + %jjR] : memref<2088x2048xf64>
              } {poly_name = "iiR"}
            } {poly_name = "jjR"}
          } {poly_name = "k"}
        } {poly_name = "iR"}
      } {poly_name = "jR"}
    } {poly_name = "iC"}
  } {class = "blis.matmul", poly_name = "kC", M_C = 330 : i32, N_C = 2048 : i32, K_C = 480 : i32, M_R = 3 : i32, N_R = 4 : i32, K_U = 4 : i32}
  return
}

func.func private @print_flops(f64)
func.func private @rtclock() -> f64
func.func private @print_memref_f64(memref<*xf64>)
