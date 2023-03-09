import torch
import torch.nn as nn
import numpy as np

class Model(nn.Module):
    def __init__(self):
        super(Model,self).__init__()
        self.conv1 = nn.Conv2d(3, 16, kernel_size=3, stride=2, padding=1)
        self.conv2 = nn.Conv2d(16, 32, kernel_size=3, stride=2, padding=1)
        self.bn1 = nn.BatchNorm2d(16)
        self.bn2 = nn.BatchNorm2d(32)  
        self.relu1 = nn.ReLU(inplace=True)
        self.relu2 = nn.ReLU(inplace=True)
    def forward(self, x):
        x = self.conv1(x)
        x = self.bn1(x)
        x = self.relu1(x)
        x = self.conv2(x)
        x = self.bn2(x)
        x = self.relu2(x)
        return x

model=Model()
model.eval() 

x=torch.randn((1,3,12,12))

torch.onnx.export(model, # 搭建的网络
    x, # 输入张量
    'model.onnx', # 输出模型名称
    input_names=["input"], # 输入命名
    output_names=["output"], # 输出命名
    dynamic_axes={'input':{0:'batch'}, 'output':{0:'batch'}}  # 动态轴
)