module {
  func.func @main(%A : memref<2088x2048xf64>, %B: memref<2048x2048xf64>, %C: memref<2088x2048xf64>)  {
    "blis.matmul" ( %A, %B, %C ) : ( memref<2088x2048xf64>, memref<2048x2048xf64>, memref<2088x2048xf64> ) -> ()
 
  return
  }

}