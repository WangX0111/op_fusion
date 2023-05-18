//  mlir-opt wmma-matmul-f32.mlir \
//  | mlir-opt -gpu-kernel-outlining \
//  | mlir-opt -pass-pipeline='builtin.module(gpu.module(strip-debuginfo,convert-gpu-to-nvvm,gpu-to-cubin{chip=sm_70}))' \
//  | mlir-opt --convert-scf-to-cf -gpu-to-llvm \
//  | mlir-cpu-runner \
//     -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_c_runner_utils.so \
//     -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_runner_utils.so \
//     -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_cuda_runtime.so \
//    --entry-point-result=void 


func.func @main() {
  %0 = memref.alloc() : memref<32x32xf16>
  %22 = memref.alloc() : memref<32x32xf32>
  %1 = memref.alloc() : memref<32x32xf32>

  %f1 = arith.constant 1.0e+00 : f16
  %f0 = arith.constant 0.0e+00 : f32
  %c0 = arith.constant 0 : index
  %c16 = arith.constant 16 : index
  %c32 = arith.constant 32 : index
  %c1 = arith.constant 1 : index

  // Intialize the Input matrix with ones.
  scf.for %arg0 = %c0 to %c16 step %c1 {
    scf.for %arg1 = %c0 to %c16 step %c1 {
      memref.store %f1, %0[%arg0, %arg1] : memref<32x32xf16>
    }
  }
  // Intialize the accumulator matrix with zeros.
  scf.for %arg0 = %c0 to %c16 step %c1 {
    scf.for %arg1 = %c0 to %c16 step %c1 {
      memref.store %f0, %22[%arg0, %arg1] : memref<32x32xf32>
    }
  }

  %2 = memref.cast %0 : memref<32x32xf16> to memref<*xf16>
  %33 = memref.cast %22 : memref<32x32xf32> to memref<*xf32>
  %3 = memref.cast %1 : memref<32x32xf32> to memref<*xf32>
  gpu.host_register %2 : memref<*xf16>
  gpu.host_register %33 : memref<*xf32>

  gpu.launch blocks(%bx, %by, %bz) in (%grid_x = %c1, %grid_y = %c1, %grid_z = %c1)
             threads(%tx, %ty, %tz) in (%block_x = %c32, %block_y = %c1, %block_z = %c1) {
    %A = gpu.subgroup_mma_load_matrix %0[%c0, %c0] {leadDimension = 32 : index} : memref<32x32xf16> -> !gpu.mma_matrix<32x32xf16, "AOp">
    %B = gpu.subgroup_mma_load_matrix %0[%c0, %c0] {leadDimension = 32 : index} : memref<32x32xf16> -> !gpu.mma_matrix<32x32xf16, "BOp">
    %C = gpu.subgroup_mma_load_matrix %22[%c0, %c0] {leadDimension = 32 : index} : memref<16x16xf16> -> !gpu.mma_matrix<16x16xf16, "COp">

    %R = gpu.subgroup_mma_compute %A, %B, %C : !gpu.mma_matrix<32x32xf16, "AOp">, !gpu.mma_matrix<32x32xf16, "BOp"> -> !gpu.mma_matrix<32x32xf32, "COp">

    gpu.subgroup_mma_store_matrix %R, %22[%c0, %c0] {leadDimension = 32 : index}: !gpu.mma_matrix<32x32xf32, "COp">, memref<32x32xf32>
    gpu.terminator
  }
  // Print the memref after computation.
  call @printMemrefF32(%33) : (memref<*xf32>) -> ()
  // CHECK: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16],
  // CHECK-NEXT: [16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16,   16]
  return
}

func.func private @printMemrefF32(memref<*xf32>)
