# ONNX_MLIR_ROOT points to the root of the onnx-mlir, 
# under which the include and the build directory lies.
export ONNX_MLIR_ROOT=$(pwd)/catherine/third_party/onnx-mlir
# Define the bin directory where onnx-mlir binary resides. Change only if you
# have a non-standard install.
export ONNX_MLIR_BIN=$ONNX_MLIR_ROOT/build/Debug/bin
# Define the include directory where onnx-mlir runtime include files resides.
# Change only if you have a non-standard install.
export ONNX_MLIR_INCLUDE=$ONNX_MLIR_ROOT/include

# Include ONNX-MLIR executable directories part of $PATH.
export PATH=$ONNX_MLIR_ROOT/build/Debug/bin:$PATH

# Compiler needs to know where to find its runtime. Set ONNX_MLIR_RUNTIME_DIR to proper path.
export ONNX_MLIR_RUNTIME_DIR=$ONNX_MLIR_ROOT/build/Debug/lib

export KATE_ROOT=$(pwd)/catherine

export PATH=$KATE_ROOT/build/bin:$PATH

export PATH=/home/ustc/wang/op_fusion/catherine/build/Debug/bin::$PATH