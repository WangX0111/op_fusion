import onnx
from PIL import Image
import numpy as np
import tvm
from tvm import te
import tvm.relay as relay
from tvm import rpc
from tvm.contrib import utils, graph_executor as runtime
from tvm.contrib.download import download_testdata
#from mxnet.gluon.model_zoo.vision import get_model

#开始同样是读取.onnx模型

onnx_model = onnx.load('../resnet50-v1-12.onnx')
#img = Image.open('kitten.jpg').resize((128, 128))
# img = Image.open('kitten.jpg').resize((128, 128))

# # 以下的图片读取仅仅是为了测试
# img = np.array(img).transpose((2, 0, 1)).astype('float32')
# #img = np.array(img).astype('float32')
# img = img/255.0    # remember pytorch tensor is 0-1
# x = img[np.newaxis, :]

 # 这里首先在PC的CPU上进行测试 所以使用LLVM进行导出
target = tvm.target.create('llvm')

# input_name = '0'  # change '1' to '0'
# shape_dict = {input_name: x.shape}
sym, params = relay.frontend.from_onnx(onnx_model)

# 这里利用TVM构建出优化后模型的信息
with relay.build_config(opt_level=2):
    graph, lib, params = relay.build_module.build(sym, target, params=params)

# dtype = 'float32'

# from tvm.contrib import graph_runtime

# # 下面的函数导出我们需要的动态链接库 地址可以自己定义
# print("Output model files")
# libpath = "../../test/tvm-resnet50-v1-12.so"
# lib.export_library(libpath)

# create random input
dev = tvm.cuda()
data = np.random.uniform(-1, 1, size=data_shape).astype("float32") #设定随机输入
# create module
module = graph_executor.GraphModule(lib["default"](dev))
# set input and parameters
module.set_input("data", data)
# run
module.run()
# get output
out = module.get_output(0, tvm.nd.empty(out_shape)).numpy()

# Print first 10 elements of output
print(out.flatten()[0:10])

# 下面的函数导出我们神经网络的结构，使用json文件保存
# graph_json_path = "../tvm_output_lib/mobilenet.json"
# with open(graph_json_path, 'w') as fo:
#     fo.write(graph)

# 下面的函数中我们导出神经网络模型的权重参数
# param_path = "../tvm_output_lib/mobilenet.params"
# with open(param_path, 'wb') as fo:
#     fo.write(relay.save_param_dict(params))
# -------------至此导出模型阶段已经结束--------

# 接下来我们加载导出的模型去测试导出的模型是否可以正常工作
# loaded_json = open(graph_json_path).read()
# loaded_lib = tvm.module.load(libpath)
# loaded_params = bytearray(open(param_path, "rb").read())

# 这里执行的平台为CPU
# ctx = tvm.cpu()

# module = graph_runtime.create(loaded_json, loaded_lib, ctx)
# module.load_params(loaded_params)
# module.set_input("0", x)
# module.run()
# out_deploy = module.get_output(0).asnumpy()

# print(out_deploy)