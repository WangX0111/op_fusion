func @main() {
  %A = memref.alloc() : memref<2048x2048xf64>
  %B = memref.alloc() : memref<2048x2048xf64>
  %C = memref.alloc() : memref<2048x2048xf64>
//   %B = memref.alloc() {alignment = 32} : memref<2048x2048xf64>
//   %C = memref.alloc() {alignment = 32} : memref<2048x2048xf64>

  %cf1 = constant 1.00000e+00 : f64

//   linalg.fill(%A, %cf1) : memref<2048x2048xf64>, f64
//   linalg.fill(%B, %cf1) : memref<2048x2048xf64>, f64
//   linalg.fill(%C, %cf1) : memref<2048x2048xf64>, f64
  linalg.fill(%cf1, %A) : f64, memref<2048x2048xf64>
  linalg.fill(%cf1, %B) : f64, memref<2048x2048xf64>
  linalg.fill(%cf1, %C) : f64, memref<2048x2048xf64>
  call @matmul(%A, %B, %C) : (memref<2048x2048xf64>, memref<2048x2048xf64>, memref<2048x2048xf64>) -> ()
 %pC = memref.cast %C : memref<2048x2048xf64> to memref<*xf64>
  call @print_memref_f64(%pC): (memref<*xf64>) -> ()

//   call @print_memref_2d_f64(%C): (memref<2048x2048xf64>) -> ()
  return
}

// C += A * B.
func @matmul(%A: memref<2048x2048xf64>, %B: memref<2048x2048xf64>, %C: memref<2048x2048xf64>) {
  affine.for %arg3 = 0 to 2048 {
    affine.for %arg4 = 0 to 2048 {
      affine.for %arg5 = 0 to 2048 {
        %a = affine.load %A[%arg3, %arg5] : memref<2048x2048xf64>
        %b = affine.load %B[%arg5, %arg4] : memref<2048x2048xf64>
        %ci = affine.load %C[%arg3, %arg4] : memref<2048x2048xf64>
        %p = mulf %a, %b : f64
        %co = addf %ci, %p : f64
        affine.store %co, %C[%arg3, %arg4] : memref<2048x2048xf64>
      }
    }
  }
  return
}


func private @print_memref_f64(memref<*xf64>)
