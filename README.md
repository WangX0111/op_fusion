# MLIR Operator Fusion
MLIR (Multi-Level Intermediate Representation) is a high-level representation used in machine learning compilers. This project focuses on the implementation of operator fusion in MLIR.

Operator fusion is a technique that combines multiple operations into a single operation, thereby reducing the overhead of individual operations and improving overall performance. This is especially important in machine learning, where the majority of computations are matrix operations and multiple operations are often performed on the same data.

The main goal of this project is to implement a set of optimizations in MLIR that will allow for the fusion of common operators, such as matrix multiplication, elementwise addition, and activation functions.

To achieve this, we will leverage the modular design of MLIR, as well as its powerful pattern-matching and transformation capabilities, to implement a set of generic and specific fusion rules.

We will also implement a pass manager to run the fusion optimizations, and evaluate the performance of the resulting fused operations.

Getting started To get started with the project, you will need to clone the repository and install the required dependencies.

$ git clone https://github.com/WangX0111/op_fusion.git $ cd op_fusion

Contributing We welcome contributions to this project! If you're interested in contributing, please take a look at the contributing guidelines.

License This project is licensed under the Apache 2.0 license. See LICENSE for more information.

## Build llvm & mlir

This is an example work-flow and configuration to get and build the LLVM source:

* ``cmake -S llvm -B build -G <generator> -DLLVM_ENABLE_PROJECTS='llvm;mlir' [options]``

   Some common build system generators are:

   * ``Ninja`` --- for generating [Ninja](https://ninja-build.org)
     build files. Most llvm developers use Ninja.
   * ``Unix Makefiles`` --- for generating make-compatible parallel makefiles.
   * ``Visual Studio`` --- for generating Visual Studio projects and
     solutions.
   * ``Xcode`` --- for generating Xcode projects.

   Some Common options:

   * ``-DCMAKE_INSTALL_PREFIX=directory`` --- Specify for *directory* the full
     path name of where you want the LLVM tools and libraries to be installed
     (default ``/usr/local``).

   * ``-DCMAKE_BUILD_TYPE=type`` --- Valid options for *type* are Debug,
     Release, RelWithDebInfo, and MinSizeRel. Default is Debug.

   * ``-DLLVM_ENABLE_ASSERTIONS=On`` --- Compile with assertion checks enabled
     (default is Yes for Debug builds, No for all other build types).

 * ``cmake --build build [-- [options] <target>]`` or your build system specified above
   directly.

   * The default target (i.e. ``ninja`` or ``make``) will build all of LLVM.

   * The ``check-all`` target (i.e. ``ninja check-all``) will run the
     regression tests to ensure everything is in working order.

   * CMake will generate targets for each tool and library, and most
     LLVM sub-projects generate their own ``check-<project>`` target.

   * Running a serial build will be **slow**.  To improve speed, try running a
     parallel build.  That's done by default in Ninja; for ``make``, use the option
     ``-j NNN``, where ``NNN`` is the number of parallel jobs, e.g. the number of
     CPUs you have.

 * For more information see [CMake](https://llvm.org/docs/CMake.html)

## Build standalone

`cd catherine && ./build.sh`