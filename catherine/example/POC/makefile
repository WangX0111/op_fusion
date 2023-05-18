#!/bin/bash
CATHERINE_OPT := ../../build/bin/catherine-opt
MLIR_OPT := ../../../../../llvm/build/bin/mlir-opt
MLIR_TRANSLATE := ../../../../../llvm/build/bin/mlir-translate
MLIR_CPU_RUNNER := ../../../../../llvm/build/bin/mlir-cpu-runner
LLC := ../../../../../llvm/build/bin/llc
OPT_FLAG := -O0

ifeq ($(shell uname),Linux)
MLIR_RUNNER_UTILS := ../../../../llvm-project/build/lib/libmlir_runner_utils.so
MLIR_C_RUNNER_UTILS := ../../../../llvm-project/build/lib/libmlir_c_runner_utils.so
MLIR_CUDA_RUNTIME := ../../../../llvm-project/build/lib/libmlir_cuda_runtime.so
MLIR_ASYNC_RUNTIME := ../../../../llvm-projectm/build/lib/libmlir_async_runtime.so
MTRIPLE := x86_64-unknown-linux-gnu
else ifeq ($(shell uname),Darwin)
MLIR_RUNNER_UTILS := ../../../../llvm-project/build/lib/libmlir_runner_utils.dylib
MLIR_C_RUNNER_UTILS := ../../../../llvm-project/build/lib/libmlir_c_runner_utils.dylib
MLIR_ASYNC_RUNTIME := ../../../../llvm-project/build/lib/libmlir_async_runtime.dylib
MTRIPLE := x86_64-apple-darwin
endif

test:
	@${MLIR_OPT}  poc-test.mlir ${MLIR_OPT_OPTIONS} \
		-convert-linalg-to-loops  -convert-linalg-to-llvm\
		-lower-affine -convert-scf-to-cf -convert-vector-to-llvm \
		-expand-strided-metadata -finalize-memref-to-llvm \
		-convert-arith-to-llvm \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_CPU_RUNNER} ${OPT_FLAG} -e main -entry-point-result=void -shared-libs=${MLIR_RUNNER_UTILS} -shared-libs=${MLIR_C_RUNNER_UTILS}

build:
	@${MLIR_OPT}  poc.mlir ${MLIR_OPT_OPTIONS} \
		-convert-linalg-to-loops  -convert-linalg-to-llvm\
		-lower-affine -convert-scf-to-cf -convert-vector-to-llvm \
		-expand-strided-metadata -finalize-memref-to-llvm \
		-convert-arith-to-llvm \
		-convert-func-to-llvm -reconcile-unrealized-casts > poc-run.mlir

run:
	@${MLIR_CPU_RUNNER} ${OPT_FLAG} poc-run.mlir -e main -entry-point-result=void -shared-libs=${MLIR_RUNNER_UTILS} -shared-libs=${MLIR_C_RUNNER_UTILS}

gpu:
	@${MLIR_CPU_RUNNER} ${OPT_FLAG} matmul-gpu.mlir \
      --entry-point-result=void \ 
	   -shared-libs=${MLIR_RUNNER_UTILS} -shared-libs=${MLIR_C_RUNNER_UTILS} -shared-libs=${MLIR_CUDA_RUNTIME} 

transform:
	@${MLIR_OPT} poc.mlir ${MLIR_OPT_OPTIONS} \
		-convert-linalg-to-loops  \
		-test-transform-dialect-interpreter="transform-file-name="poc-transform.mlir""  -split-input-file -verify-diagnostics  \
		-convert-linalg-to-llvm \
		-lower-affine -convert-scf-to-cf -convert-vector-to-llvm \
		-expand-strided-metadata -finalize-memref-to-llvm \
		-convert-arith-to-llvm \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_CPU_RUNNER} ${OPT_FLAG} -e main -entry-point-result=void -shared-libs=${MLIR_RUNNER_UTILS} -shared-libs=${MLIR_C_RUNNER_UTILS}

auto:
	@./auto/run_matmul_test.sh

