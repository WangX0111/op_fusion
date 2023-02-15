#! /usr/bin/env bash
test -e build && rm -rf build
mkdir build
cmake -G Ninja -B build -DMLIR_DIR=../../llvm-project/build/lib/cmake/mlir && \
cmake --build build
