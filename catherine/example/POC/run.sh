onnx-mlir ./nmm.onnx 
g++ --std=c++11 -O3 omrun.cc ./nmm.so -o nmm -I $ONNX_MLIR_INCLUDE
