
from PyRuntime import ExecutionSession
import numpy as np
import time
import cv2
 
#model = '/Users/wangchenhao/Documents/Enflame/workSpace/op_fusion/resnet50-v1-12.so'
model = '/Users/wangchenhao/Documents/Enflame/workSpace/test/tvm-resnet50-v1-12.so'

session = ExecutionSession(model)

print("input signature in json", session.input_signature())
print("output signature in json", session.output_signature())

#Create an input arbitrarily filled of 1.0 values(file has the actual values).
# input = np.full((1, 1, 28, 28), 1, np.dtype(np.float32))
img   = cv2.imread("script/kitten.jpg")
input = np.array(img, np.dtype(np.float32))
start_time = time.time()
outputs = session.run(input)
print(outputs)
print("--- %s seconds ---" % (time.time() - start_time))