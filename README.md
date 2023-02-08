# MLIR Operator Fusion
MLIR (Multi-Level Intermediate Representation) is a high-level representation used in machine learning compilers. This project focuses on the implementation of operator fusion in MLIR.

Operator fusion is a technique that combines multiple operations into a single operation, thereby reducing the overhead of individual operations and improving overall performance. This is especially important in machine learning, where the majority of computations are matrix operations and multiple operations are often performed on the same data.

The main goal of this project is to implement a set of optimizations in MLIR that will allow for the fusion of common operators, such as matrix multiplication, elementwise addition, and activation functions.

To achieve this, we will leverage the modular design of MLIR, as well as its powerful pattern-matching and transformation capabilities, to implement a set of generic and specific fusion rules.

We will also implement a pass manager to run the fusion optimizations, and evaluate the performance of the resulting fused operations.

Getting started
To get started with the project, you will need to clone the repository and install the required dependencies.

$ git clone https://github.com/WangX0111/op_fusion.git
$ cd op_fusion

Contributing
We welcome contributions to this project! If you're interested in contributing, please take a look at the contributing guidelines.

License
This project is licensed under the Apache 2.0 license. See LICENSE for more information.