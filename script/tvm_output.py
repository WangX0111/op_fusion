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
batch_size = 1
num_class = 1000
image_shape = (3, 224, 224)
data_shape = (batch_size,) + image_shape
out_shape = (batch_size, num_class)

# onnx_model = onnx.load('super_resolution_0.2.onnx')
onnx_model = onnx.load('../resnet50-v1-12.onnx')
#img = Image.open('kitten.jpg').resize((128, 128))
# img = Image.open('kitten.jpg').resize((128, 128))

img = Image.open("cat.png").resize(( 224, 224))
(im_width, im_height) = img.size
img_ycbcr = img.convert("YCbCr")  # convert to YCbCr
img_y, img_cb, img_cr = img_ycbcr.split()
print(np.array(img_y).shape)
np_array = np.array(img)
reshaped = np_array.reshape((1, 3, im_width, im_height))
print(reshaped.shape)

# Compile the model with relay¶
target = "llvm"

input_name = "data"
shape_dict = {input_name: reshaped.shape}
print(shape_dict)
mod, params = relay.frontend.from_onnx(onnx_model, shape_dict)

with tvm.transform.PassContext(opt_level=1):
    executor = relay.build_module.create_executor(
        "graph", mod, tvm.cpu(0), target, params
    ).evaluate()

# Execute on TVM¶
dtype = "float32"
tvm_output = executor(tvm.nd.array(reshaped.astype(dtype))).numpy()