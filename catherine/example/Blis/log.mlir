module attributes {llvm.data_layout = ""} {
  func.func @main(%arg0: tensor<2x3xf64>, %arg1: tensor<3x4xf64>) -> tensor<2x4xf64> {
    %0 = "blis.matmul"(%arg0, %arg1) : (tensor<2x3xf64>, tensor<3x4xf64>) -> tensor<2x4xf64>
    return %0 : tensor<2x4xf64>
  }
}

