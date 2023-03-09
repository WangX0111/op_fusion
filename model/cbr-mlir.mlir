#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0, d1) -> (d0 * 16 + d1)>
#map2 = affine_map<(d0) -> (d0 * -2 + 1, 0)>
#map3 = affine_map<(d0) -> (d0 * -2 + 13, 3)>
#map4 = affine_map<(d0, d1) -> (d1 * -2 + 1, 0)>
#map5 = affine_map<(d0, d1) -> (d1 * -2 + 13, 3)>
#map6 = affine_map<(d0, d1) -> (d0 + d1 * 3)>
#map7 = affine_map<(d0, d1) -> (d0 + d1 * 2 - 1)>
#map8 = affine_map<(d0, d1) -> (d0 * 32 + d1)>
#map9 = affine_map<(d0) -> (d0 * -2 + 7, 3)>
#map10 = affine_map<(d0, d1) -> (d1 * -2 + 7, 3)>
#map11 = affine_map<(d0, d1) -> (d0 + d1 * 16)>
module attributes {llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {
  func.func @main_graph(%arg0: memref<?x3x12x12xf32>) -> memref<?x32x3x3xf32> attributes {input_names = ["input"], llvm.emit_c_interface, output_names = ["output"]} {
    %cst = arith.constant 0.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %0 = "krnl.global"() {name = "constant_0", shape = [16, 3, 3, 3], value = dense_resource<__elided__> : tensor<16x3x3x3xf32>} : () -> memref<16x3x3x3xf32>
    %1 = "krnl.global"() {name = "constant_1", shape = [16], value = dense<[0.173129767, -0.166705459, -0.140663907, -0.191498682, -0.0474105179, -0.0786130726, 0.0464374907, -0.175091252, -0.0470892899, -0.13934426, 0.15589343, -0.144915342, 0.0695649907, 0.134439379, 0.0844307691, -0.135046378]> : tensor<16xf32>} : () -> memref<16xf32>
    %2 = "krnl.global"() {name = "constant_2", shape = [32, 16, 3, 3], value = dense_resource<__elided__> : tensor<32x16x3x3xf32>} : () -> memref<32x16x3x3xf32>
    %3 = "krnl.global"() {name = "constant_3", shape = [32], value = dense<[-0.0386761092, 0.0446468666, -0.0355843604, 0.0290286783, -0.0478844345, -0.0490023121, 0.0210491158, -0.0233633239, 0.0693316534, -0.0712310597, 0.0600212179, 0.0120764961, 0.0513812937, 0.0247947127, 0.0399321504, 0.0149124218, 0.0280254278, 0.0669608042, 0.0074705407, -4.354800e-02, -0.0373291299, -0.0335916616, -0.0304098502, -0.0757252648, -0.0145248249, -0.0230194665, 0.0622831545, 6.762220e-02, 0.0154365124, -0.0280950051, -0.018469112, -0.0590913929]> : tensor<32xf32>} : () -> memref<32xf32>
    %dim = memref.dim %arg0, %c0 : memref<?x3x12x12xf32>
    %alloc = memref.alloc(%dim) {alignment = 16 : i64} : memref<?x16x6x6xf32>
    %alloca = memref.alloca() : memref<f32>
    affine.for %arg1 = 0 to #map(%dim) {
      affine.for %arg2 = 0 to 1 {
        affine.for %arg3 = 0 to 16 {
          %4 = affine.apply #map1(%arg2, %arg3)
          affine.for %arg4 = 0 to 6 {
            affine.for %arg5 = 0 to 6 {
              affine.store %cst, %alloca[] : memref<f32>
              affine.for %arg6 = 0 to 3 {
                affine.for %arg7 = max #map2(%arg4) to min #map3(%arg4) {
                  affine.for %arg8 = max #map4(%arg4, %arg5) to min #map5(%arg4, %arg5) {
                    %8 = affine.apply #map6(%arg6, %arg2)
                    %9 = affine.apply #map7(%arg7, %arg4)
                    %10 = affine.apply #map7(%arg8, %arg5)
                    %11 = affine.load %arg0[%arg1, %8, %9, %10] : memref<?x3x12x12xf32>
                    %12 = affine.load %0[%4, %arg6, %arg7, %arg8] : memref<16x3x3x3xf32>
                    %13 = affine.load %alloca[] : memref<f32>
                    %14 = arith.mulf %11, %12 : f32
                    %15 = arith.addf %13, %14 : f32
                    affine.store %15, %alloca[] : memref<f32>
                  }
                }
              }
              %5 = affine.load %alloca[] : memref<f32>
              %6 = affine.load %1[%4] : memref<16xf32>
              %7 = arith.addf %5, %6 : f32
              affine.store %7, %alloc[%arg1, %4, %arg4, %arg5] : memref<?x16x6x6xf32>
            }
          }
        }
      }
    }
    %alloc_0 = memref.alloc(%dim) {alignment = 16 : i64} : memref<?x16x6x6xf32>
    affine.for %arg1 = 0 to #map(%dim) {
      affine.for %arg2 = 0 to 16 {
        affine.for %arg3 = 0 to 6 {
          affine.for %arg4 = 0 to 6 {
            %4 = affine.load %alloc[%arg1, %arg2, %arg3, %arg4] : memref<?x16x6x6xf32>
            %5 = arith.cmpf oge, %4, %cst : f32
            %6 = arith.select %5, %4, %cst : f32
            affine.store %6, %alloc_0[%arg1, %arg2, %arg3, %arg4] : memref<?x16x6x6xf32>
          }
        }
      }
    }
    %alloc_1 = memref.alloc(%dim) {alignment = 16 : i64} : memref<?x32x3x3xf32>
    %alloca_2 = memref.alloca() : memref<f32>
    affine.for %arg1 = 0 to #map(%dim) {
      affine.for %arg2 = 0 to 1 {
        affine.for %arg3 = 0 to 32 {
          %4 = affine.apply #map8(%arg2, %arg3)
          affine.for %arg4 = 0 to 3 {
            affine.for %arg5 = 0 to 3 {
              affine.store %cst, %alloca_2[] : memref<f32>
              affine.for %arg6 = 0 to 16 {
                affine.for %arg7 = max #map2(%arg4) to min #map9(%arg4) {
                  affine.for %arg8 = max #map4(%arg4, %arg5) to min #map10(%arg4, %arg5) {
                    %8 = affine.apply #map11(%arg6, %arg2)
                    %9 = affine.apply #map7(%arg7, %arg4)
                    %10 = affine.apply #map7(%arg8, %arg5)
                    %11 = affine.load %alloc_0[%arg1, %8, %9, %10] : memref<?x16x6x6xf32>
                    %12 = affine.load %2[%4, %arg6, %arg7, %arg8] : memref<32x16x3x3xf32>
                    %13 = affine.load %alloca_2[] : memref<f32>
                    %14 = arith.mulf %11, %12 : f32
                    %15 = arith.addf %13, %14 : f32
                    affine.store %15, %alloca_2[] : memref<f32>
                  }
                }
              }
              %5 = affine.load %alloca_2[] : memref<f32>
              %6 = affine.load %3[%4] : memref<32xf32>
              %7 = arith.addf %5, %6 : f32
              affine.store %7, %alloc_1[%arg1, %4, %arg4, %arg5] : memref<?x32x3x3xf32>
            }
          }
        }
      }
    }
    %alloc_3 = memref.alloc(%dim) {alignment = 16 : i64} : memref<?x32x3x3xf32>
    affine.for %arg1 = 0 to #map(%dim) {
      affine.for %arg2 = 0 to 32 {
        affine.for %arg3 = 0 to 3 {
          affine.for %arg4 = 0 to 3 {
            %4 = affine.load %alloc_1[%arg1, %arg2, %arg3, %arg4] : memref<?x32x3x3xf32>
            %5 = arith.cmpf oge, %4, %cst : f32
            %6 = arith.select %5, %4, %cst : f32
            affine.store %6, %alloc_3[%arg1, %arg2, %arg3, %arg4] : memref<?x32x3x3xf32>
          }
        }
      }
    }
    return %alloc_3 : memref<?x32x3x3xf32>
  }
  "krnl.entry_point"() {func = @main_graph, numInputs = 1 : i32, numOutputs = 1 : i32, signature = "[    { \22type\22 : \22f32\22 , \22dims\22 : [-1 , 3 , 12 , 12] , \22name\22 : \22input\22 }\0A\0A]\00@[   { \22type\22 : \22f32\22 , \22dims\22 : [-1 , 32 , 3 , 3] , \22name\22 : \22output\22 }\0A\0A]\00"} : () -> ()
}
