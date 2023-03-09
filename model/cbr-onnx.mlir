module attributes {llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {
  func.func @main_graph(%arg0: tensor<?x3x12x12xf32>) -> tensor<?x32x3x3xf32> attributes {input_names = ["input"], output_names = ["output"]} {
    %0 = onnx.Constant dense_resource<__elided__> : tensor<16x3x3x3xf32>
    %1 = onnx.Constant dense<[0.173129767, -0.166705459, -0.140663907, -0.191498682, -0.0474105179, -0.0786130726, 0.0464374907, -0.175091252, -0.0470892899, -0.13934426, 0.15589343, -0.144915342, 0.0695649907, 0.134439379, 0.0844307691, -0.135046378]> : tensor<16xf32>
    %2 = onnx.Constant dense_resource<__elided__> : tensor<32x16x3x3xf32>
    %3 = onnx.Constant dense<[-0.0386761092, 0.0446468666, -0.0355843604, 0.0290286783, -0.0478844345, -0.0490023121, 0.0210491158, -0.0233633239, 0.0693316534, -0.0712310597, 0.0600212179, 0.0120764961, 0.0513812937, 0.0247947127, 0.0399321504, 0.0149124218, 0.0280254278, 0.0669608042, 0.0074705407, -4.354800e-02, -0.0373291299, -0.0335916616, -0.0304098502, -0.0757252648, -0.0145248249, -0.0230194665, 0.0622831545, 6.762220e-02, 0.0154365124, -0.0280950051, -0.018469112, -0.0590913929]> : tensor<32xf32>
    %4 = "onnx.Conv"(%arg0, %0, %1) {auto_pad = "NOTSET", dilations = [1, 1], group = 1 : si64, kernel_shape = [3, 3], onnx_node_name = "/conv1/Conv", pads = [1, 1, 1, 1], strides = [2, 2]} : (tensor<?x3x12x12xf32>, tensor<16x3x3x3xf32>, tensor<16xf32>) -> tensor<?x16x6x6xf32>
    %5 = "onnx.Relu"(%4) {onnx_node_name = "/relu1/Relu"} : (tensor<?x16x6x6xf32>) -> tensor<?x16x6x6xf32>
    %6 = "onnx.Conv"(%5, %2, %3) {auto_pad = "NOTSET", dilations = [1, 1], group = 1 : si64, kernel_shape = [3, 3], onnx_node_name = "/conv2/Conv", pads = [1, 1, 1, 1], strides = [2, 2]} : (tensor<?x16x6x6xf32>, tensor<32x16x3x3xf32>, tensor<32xf32>) -> tensor<?x32x3x3xf32>
    %7 = "onnx.Relu"(%6) {onnx_node_name = "/relu2/Relu"} : (tensor<?x32x3x3xf32>) -> tensor<?x32x3x3xf32>
    return %7 : tensor<?x32x3x3xf32>
  }
  "onnx.EntryPoint"() {func = @main_graph} : () -> ()
}
