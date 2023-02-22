module attributes {llvm.data_layout = ""} {
  func.func @main(%arg0: tensor<2x3xf64>, %arg1: tensor<3x4xf64>) -> tensor<2x4xf64> {
    %0 = "blis.matmul"(%arg0, %arg1) {K_C = 480 : i32, K_U = 4 : i32, M_C = 330 : i32, M_R = 3 : i32, N_C = 2048 : i32, N_R = 16 : i32} : (tensor<2x3xf64>, tensor<3x4xf64>) -> tensor<2x4xf64>
    return %0 : tensor<2x4xf64>
  }
}

