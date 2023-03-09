module {
  func.func @main(%arg0: memref<2088x2048xf64>, %arg1: memref<2048x2048xf64>, %arg2: memref<2088x2048xf64>) {
    blis.matmul(%arg0, %arg1, %arg2) : (memref<2088x2048xf64>, memref<2048x2048xf64>, memref<2088x2048xf64>)
    return
  }
}

