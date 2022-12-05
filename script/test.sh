echo "testing $1 $2" 
./build/Debug/bin/onnx-mlir --Emit$1 $2

#./build/Debug/bin/onnx-mlir --instrument-onnx-ops="ALL" --InstrumentBeforeOp --InstrumentAfterOp --InstrumentReportTime 