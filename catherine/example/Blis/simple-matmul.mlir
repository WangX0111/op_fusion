// module {
//   func.func @main(%A : memref<2088x2048xf64>, %B: memref<2048x2048xf64>, %C: memref<2088x2048xf64>)  {
//     "blis.matmul" ( %A, %B, %C ) : ( memref<2088x2048xf64>, memref<2048x2048xf64>, memref<2088x2048xf64> ) -> ()
//   return
//   }
// }
 #k0 = affine_map<(d0, d1) -> (d0, d1 + 1)>
      #k1 = affine_map<(d0, d1) -> (d0 + 1, d1)>
module {
  
  func.func @matmul_linalg(%arg0: memref<8x8xf32>, %arg1: memref<8x8xf32>, %arg2: memref<8x8xf32>) {
    
    %c0 = arith.constant 0 : index
    %c8 = arith.constant 8 : index
    %0 = arith.subi %c8, %c0 : index
    %c1 = arith.constant 1 : index
    %c0_0 = arith.constant 0 : index
    %c8_1 = arith.constant 8 : index
    %1 = arith.subi %c8_1, %c0_0 : index
    %c1_2 = arith.constant 1 : index
    %c0_3 = arith.constant 0 : index
    %c8_4 = arith.constant 8 : index
    %2 = arith.subi %c8_4, %c0_3 : index
    %c1_5 = arith.constant 1 : index
    %c1_6 = arith.constant 1 : index
    gpu.launch blocks(%arg3, %arg4, %arg5) in (%arg9 = %0, %arg10 = %1, %arg11 = %2) threads(%arg6, %arg7, %arg8) in (%arg12 = %c1_6, %arg13 = %c1_6, %arg14 = %c1_6) {
      %3 = arith.addi %c0, %arg12 : index
      %4 = arith.addi %c0_0, %arg4 : index
      %5 = arith.addi %c0_3, %arg5 : index
      // %18 = arith.index_cast %3 : i32 to index
     
      // %sym3 = affine.apply #map0(%3)
      // %sym5 = affine.apply #map1(%5)
      %6 = affine.load %arg0[ %3 , %c0 ] : memref<8x8xf32>
      %7 = affine.load %arg1[%5, %4] : memref<8x8xf32>
      %8 = affine.load %arg2[%3, %4] : memref<8x8xf32>
      %9 = arith.mulf %6, %7 : f32
      %10 = arith.addf %8, %9 : f32
      affine.store %10, %arg2[%3, %4] : memref<8x8xf32>
      gpu.terminator
    }
    return
  }
  func.func @main() {
    %alloc = memref.alloc() : memref<8x8xf32>
    %alloc_0 = memref.alloc() : memref<8x8xf32>
    %alloc_1 = memref.alloc() : memref<8x8xf32>
    call @matmul_linalg(%alloc, %alloc_0, %alloc_1) : (memref<8x8xf32>, memref<8x8xf32>, memref<8x8xf32>) -> ()
    return
  }
}