import onnx 
from onnx import helper 
from onnx import TensorProto 
 
# input and output 
a = helper.make_tensor_value_info('a', TensorProto.FLOAT, [10, 10]) 
x = helper.make_tensor_value_info('x', TensorProto.FLOAT, [10, 10]) 
b = helper.make_tensor_value_info('b', TensorProto.FLOAT, [10, 10]) 
output = helper.make_tensor_value_info('output', TensorProto.FLOAT, [10, 10]) 
 
# Mul 
mul = helper.make_node('MatMul', ['a', 'x'], ['c']) 
 
# Add 
add = helper.make_node('Add', ['c', 'b'], ['output']) 
 
# graph and model 
graph = helper.make_graph([mul, add], 'linear_func', [a, x, b], [output]) 
model = helper.make_model(graph) 
 
# save model 
onnx.checker.check_model(model) 
print(model) 
onnx.save(model, 'linear_func.onnx') 