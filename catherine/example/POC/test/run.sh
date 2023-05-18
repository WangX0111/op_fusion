#!/bin/sh
if [ "$#" -ne 2 ]; then
    echo "Usage: ./jit.sh <filename> <compile-or-run>" >&2
    echo "       <compile-or-run>" >&2
    echo "       * 0 if running file through partial pass chain" >&2
    echo "       * 1 if running file through full pass chain" >&2
    echo "       * 2 if measuring time" >&2
    echo "       * 3 if running the generated assembly" >&2
    exit 1
fi

fname=$1
corr=$2

export LLVM_INSTALL_DIR=/home/ustc/llvm
export LD_LIBRARY_PATH=$LLVM_INSTALL_DIR/build/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export PATH=$LLVM_INSTALL_DIR/build/bin/:$PATH

if [ "$corr" -eq 0 ]; then
    mlir-opt $1 \
          --convert-linalg-to-parallel-loops \
          --convert-parallel-loops-to-gpu \
          --gpu-map-parallel-loops \
          --gpu-kernel-outlining \
          --lower-affine \
          --convert-scf-to-cf \
          --canonicalize | \
           mlir-opt --pass-pipeline='builtin.module(gpu.module(strip-debuginfo,convert-gpu-to-nvvm,reconcile-unrealized-casts,gpu-to-cubin))' | \
           mlir-opt --gpu-to-llvm --reconcile-unrealized-casts \
          --mlir-print-ir-after-failure > exout.llvm

    mlir-translate exout.llvm --mlir-to-llvmir > exout.ll
    opt exout.ll -O3 -S | llc -O3 -o exout.s

elif [ "$corr" -eq 1 ]; then
    mlir-opt $1 \
          --convert-linalg-to-parallel-loops \
          --convert-parallel-loops-to-gpu \
          --gpu-map-parallel-loops \
          --gpu-kernel-outlining \
          --canonicalize \
          --lower-affine \
          --convert-scf-to-cf \
          --arith-expand \
          --convert-math-to-llvm \
          --convert-math-to-libm \
          --convert-linalg-to-llvm \
          --finalize-memref-to-llvm \
          --convert-arith-to-llvm \
          --convert-func-to-llvm \
          --convert-cf-to-llvm | \
          mlir-opt --pass-pipeline='builtin.module(gpu.module(strip-debuginfo,convert-gpu-to-nvvm,reconcile-unrealized-casts,gpu-to-cubin))' | \
          mlir-opt --gpu-to-llvm --reconcile-unrealized-casts \
          > exout.llvm

    mlir-translate exout.llvm --mlir-to-llvmir > exout.ll
    opt exout.ll -O3 -S | llc -O3 -o exout.s

elif [ "$corr" -eq 2 ]; then
    mlir-cpu-runner  exout.llvm \
          --shared-libs=$LLVM_INSTALL_DIR/build/lib/libmlir_cuda_runtime.so \
          --shared-libs=$LLVM_INSTALL_DIR/build/lib/libmlir_runner_utils.so \
          --shared-libs=$LLVM_INSTALL_DIR/build/lib/libmlir_c_runner_utils.so \
          --entry-point-result=void 

    # mlir-opt wmma-matmul-f32.mlir \
    # | mlir-opt -gpu-kernel-outlining \
    # | mlir-opt -pass-pipeline='builtin.module(gpu.module(strip-debuginfo,convert-gpu-to-nvvm,gpu-to-cubin{chip=sm_70}))' \
    # | mlir-opt --convert-scf-to-cf -gpu-to-llvm \
    # | mlir-cpu-runner \
    #     -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_c_runner_utils.so \
    #     -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_runner_utils.so \
    #     -shared-libs=/home/ustc/wang/llvm-project/build/lib/libmlir_cuda_runtime.so \
    # --entry-point-result=void 

else
    as -o exout.o exout.s
    clang++ exout.o -no-pie -L/home/ustc/llvm/build/lib -o exec -lcuda -lmlir_cuda_runtime -lmlir_runner_utils -lmlir_c_runner_utils 
    ./exec
fi