# MLIR_DIR must be set with cmake option now
source .env

test -d ../build || mkdir ../build
cd ../build

if [[ -z "$pythonLocation" ]]; then
  cmake -G Ninja \
        -DCMAKE_CXX_COMPILER=/usr/bin/c++ \
        -DMLIR_DIR=${MLIR_DIR} \
        ..
    
else
  cmake -G Ninja \
        -DCMAKE_CXX_COMPILER=/usr/bin/c++ \
        -DPython3_ROOT_DIR=$pythonLocation \
        -DMLIR_DIR=${MLIR_DIR} \
        ..
        
fi
cmake --build .

# Run lit tests:
# export LIT_OPTS=-v
# cmake --build . --target check-onnx-lit