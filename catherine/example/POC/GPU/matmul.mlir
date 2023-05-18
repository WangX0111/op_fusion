module {
    func.func private @printMemrefF32(memref<*xf32>)
    func.func @matmul_linalg(%A: memref<8000x8000xf32>, %B: memref<8000x8000xf32>, %C: memref<8000x8000xf32>) {
        linalg.matmul ins(%A, %B : memref<8000x8000xf32>, memref<8000x8000xf32>)
            outs(%C: memref<8000x8000xf32>)
        return
    }
    
    func.func @main() {
        %A = memref.alloc() : memref<8000x8000xf32>
        %B = memref.alloc() : memref<8000x8000xf32>
        %C = memref.alloc() : memref<8000x8000xf32>

        %cf1 = arith.constant 1.0 : f32

        %AC = memref.cast %A : memref<8000x8000xf32> to memref<*xf32>
        %BC = memref.cast %B : memref<8000x8000xf32> to memref<*xf32>
        %CC = memref.cast %C : memref<8000x8000xf32> to memref<*xf32>

        gpu.host_register %AC : memref<*xf32>
        gpu.host_register %BC : memref<*xf32>
        gpu.host_register %CC : memref<*xf32>

        linalg.fill ins(%cf1 : f32) outs(%A : memref<8000x8000xf32>) 
        linalg.fill ins(%cf1 : f32) outs(%B : memref<8000x8000xf32>) 
        linalg.fill ins(%cf1 : f32) outs(%C : memref<8000x8000xf32>) 

        call @matmul_linalg(%A, %B, %C) : (memref<8000x8000xf32>, memref<8000x8000xf32>, memref<8000x8000xf32>) -> ()
        %res = memref.cast %C : memref<8000x8000xf32> to memref<*xf32>
        call @printMemrefF32(%res) : (memref<*xf32>) -> ()
        return
    }
}

// func.func private @print_memref_f32(memref<*xf32>)
// func.func private @print_memref_f32(memref<*xf32>)
// func.func private @printMemrefF32(memref<*xf32>) attributes { llvm.emit_c_interface }

// mlir-opt matmul.mlir  --test-linalg-transform-patterns="tile-sizes=4,2"    --convert-linalg-to-parallel-loops  --scf-parallel-loop-tiling  --convert-parallel-loops-to-gpu --gpu-kernel-outlining --lower-affine --convert-scf-to-cf --arith-expand --memref-expand  --convert-vector-to-llvm --finalize-memref-to-llvm --canonicalize > 1.mlir
// mlir-opt 1.mlir -pass-pipeline="builtin.module(gpu.module(strip-debuginfo, convert-gpu-to-nvvm, gpu-to-cubin))" > 2.mlir
// mlir-opt 2.mlir --gpu-to-llvm > 3.mlir
// export MLIR_RUNNER_UTILS="/home/ustc/wang/llvm-project/build/lib/libmlir_runner_utils.so"
// export MLIR_C_RUNNER_UTILS="/home/ustc/wang/llvm-project/build/lib/libmlir_c_runner_utils.so"
// export MLIR_CUDA_RUNTIME="/home/ustc/wang/llvm-project/build/lib/libmlir_cuda_runtime.so"

// mlir-cpu-runner 3.mlir \
//       -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_runner_utils.so \
//       -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_c_runner_utils.so \
//       -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_cuda_runtime.so\
//       --entry-point-result=void

// mlir-opt matmul.mlir  --test-linalg-transform-patterns="tile-sizes=4,2"    --convert-linalg-to-parallel-loops  --scf-parallel-loop-tiling  --lower-affine | \
//  mlir-opt -test-vector-warp-distribute=rewrite-warp-ops-to-scf-if -canonicalize | \
//  mlir-opt -convert-scf-to-cf -convert-cf-to-llvm -convert-vector-to-llvm -convert-arith-to-llvm \
//   -gpu-kernel-outlining |\
//  mlir-opt -pass-pipeline='builtin.module(gpu.module(strip-debuginfo,convert-gpu-to-nvvm,reconcile-unrealized-casts,gpu-to-cubin))' |\
//  mlir-opt -gpu-to-llvm -reconcile-unrealized-casts | \

//  mlir-cpu-runner  -e main -entry-point-result=void \
// -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_runner_utils.so \
//       -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_c_runner_utils.so \
//       -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_cuda_runtime.so