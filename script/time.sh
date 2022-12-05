###### BUILD
# ONNX-MLIR
time ./test.sh Lib resnet50-v1-12.onnx

# TVM
time tvmc compile --target "llvm" --output ../test/tvm-resnet50-v1-12.tar resnet50-v1-12.onnx

###### RUN
# ONNX-MLIR

# TVM
# tvmc run --inputs imagenet_cat.npz --output predictions.npz tvm-resnet50-v1-12.tar
# python3 postprocess.py

##### Optimize
# TVM
# 可以通过--tuner选项指定要使用的调优搜索算法。查看可指定哪些算法：
# tvmc tune --help | grep tuner
#                 [--tuner {ga,gridsearch,random,xgb,xgb_knob,xgb-rank}]
#  --tuner {ga,gridsearch,random,xgb,xgb_knob,xgb-rank}
#                        type of tuner to use when tuning with autotvm.
# 模型调优
# tvmc tune --target "llvm" --output resnet50-v2-7-autotuner_records.json resnet50-v2-7.onnx
# 生成调优模型
# tvmc compile --target "llvm" --tuning-records resnet50-v2-7-autotuner_records.json --output resnet50-v2-7-tvm_autotuned.tar resnet50-v2-7.onnx
# 运行调优模型
# tvmc run --inputs imagenet_cat.npz --output predictions.npz resnet50-v2-7-tvm_autotuned.tar
# python3 postprocess.py
