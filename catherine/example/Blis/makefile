#!/bin/bash
BLIS_OPT := ../../build/bin/blis-opt
MLIR_OPT := ../../../../../llvm/build/bin/mlir-opt
MLIR_TRANSLATE := ../../../../../llvm/build/bin/mlir-translate
MLIR_CPU_RUNNER := ../../../../../llvm/build/bin/mlir-cpu-runner
LLC := ../../../../../llvm/build/bin/llc
OPT_FLAG := -O0

ifeq ($(shell uname),Linux)
MLIR_RUNNER_UTILS := ../../../../llvm-project/build/lib/libmlir_runner_utils.so
MLIR_C_RUNNER_UTILS := ../../../../llvm-project/build/lib/libmlir_c_runner_utils.so
MLIR_ASYNC_RUNTIME := ../../../../llvm-projectm/build/lib/libmlir_async_runtime.so
MTRIPLE := x86_64-unknown-linux-gnu
else ifeq ($(shell uname),Darwin)
MLIR_RUNNER_UTILS := ../../../../llvm-project/build/lib/libmlir_runner_utils.dylib
MLIR_C_RUNNER_UTILS := ../../../../llvm-project/build/lib/libmlir_c_runner_utils.dylib
MLIR_ASYNC_RUNTIME := ../../../../llvm-project/build/lib/libmlir_async_runtime.dylib
MTRIPLE := x86_64-apple-darwin
endif

blis:
	@${BLIS_OPT} -hopt  simple-matmul.mlir ${MLIR_OPT_OPTIONS} \
		-convert-linalg-to-loops -lower-affine -convert-scf-to-cf \
		-convert-vector-to-llvm -convert-memref-to-spirv -convert-spirv-to-llvm -convert-arith-to-llvm \
		-convert-func-to-llvm -reconcile-unrealized-casts \
		-o ./log.mlir

linalg-matmul-lower:
	@${MLIR_OPT} linalg-matmul.mlir ${MLIR_OPT_OPTIONS} \
		-convert-linalg-to-loops -lower-affine -convert-scf-to-cf \
		-convert-vector-to-llvm -convert-memref-to-spirv -convert-spirv-to-llvm -convert-arith-to-llvm \
		-convert-func-to-llvm -reconcile-unrealized-casts \
		-o ./log.mlir

linalg-matmul-translate:
	@${MLIR_OPT} linalg-matmul.mlir ${MLIR_OPT_OPTIONS} \
		-convert-linalg-to-loops -lower-affine -convert-scf-to-cf \
		-convert-vector-to-llvm -convert-memref-to-llvm -convert-arith-to-llvm \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_TRANSLATE} --mlir-to-llvmir -o log.ll

linalg-matmul-run:
	@${MLIR_OPT} linalg-matmul.mlir ${MLIR_OPT_OPTIONS} \
		-convert-linalg-to-loops -lower-affine -convert-scf-to-cf \
		-convert-vector-to-llvm -convert-memref-to-llvm -convert-arith-to-llvm \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_CPU_RUNNER} ${OPT_FLAG} -e main -entry-point-result=void -shared-libs=${MLIR_RUNNER_UTILS} -shared-libs=${MLIR_C_RUNNER_UTILS}

linalg-matmul-optimize-lower:
	@${BLIS_OPT} linalg-matmul.mlir ${MLIR_OPT_OPTIONS} \
		--matmul-optimize="vec-size=16 kernel-m=2 kernel-n=4" \
		-o ./log.mlir

linalg-matmul-optimize-translate:
	@${BLIS_OPT} linalg-matmul.mlir ${MLIR_OPT_OPTIONS} \
		--matmul-optimize="vec-size=16 kernel-m=2 kernel-n=4" -convert-linalg-to-loops \
		-lower-affine -convert-scf-to-cf -convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_TRANSLATE} --mlir-to-llvmir -o log.ll

linalg-matmul-optimize-run:
	@${BLIS_OPT} linalg-matmul.mlir ${MLIR_OPT_OPTIONS} \
		--matmul-optimize="vec-size=16 kernel-m=2 kernel-n=4" -convert-linalg-to-loops \
		-lower-affine -convert-scf-to-cf -convert-vector-to-llvm \
		-convert-memref-to-llvm -convert-arith-to-llvm \
		-convert-func-to-llvm -reconcile-unrealized-casts | \
	${MLIR_CPU_RUNNER} ${OPT_FLAG} -e main -entry-point-result=void -shared-libs=${MLIR_RUNNER_UTILS} -shared-libs=${MLIR_C_RUNNER_UTILS}
