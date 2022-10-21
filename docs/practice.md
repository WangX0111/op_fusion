# MLIR 算子融合实践

目标

1. 先寻找是否有类似项目可以借鉴
2. 是否有其他框架的类似项目，然后考虑移植问题
3. 是否需要自己从头开始手写



MLIR的学习过程如下：

1. 学习MLIR基本模块；
2. 学习MLIR提供的Dialects，各个Dialects的定位，以及为弥补软硬件gap，提供的这些gap的分类和关联。

关于MLIR基本模块学习过程如下：

1. Dialect, Attribute, Type, Operation；想象如果自己去实现，该怎么设计类；
2. DialectConversion；想象在自己实现的前四个模块上，如何实现DialectConversion；
3. Interface, Constraint, Trait；同样，想象自己会怎么增加这些功能；
4. Transformation, Concalization；
5. Region, Block：基于1. 设计的Operation，以及4. 增加的Transformation，想象如何对Operation进行抽象，提取出Region和Block的概念；
6. Pass；
7. 最后才是ODS和DRR。



两个语句都使用了矩阵A，如果将他们合并成一个算子，则只需要从内存中load A一次，而非两次。理论上讲这种fusion并不困难，尤其是当B和C的shape完全一样的时候，譬如在计算A的一个小块乘B的一个小块的时候，再把C的一个小块load进来就行，实现对A的reuse。但是我不知道实际深度学习、或者科学计算应用中，这样的情况是否好合并？即合并后是否能更高效？我可能想得比较简单，有知道的小伙伴们欢迎留言告知。

### 一些Research Problem

可以看到，虽然考虑的算子、依赖情况越多，fusion的问题已经越来越复杂了。另外还有一些比较高阶的问题，譬如如果有多种fusion的可能，如何选择最优的fusion方案？这里就需要一个cost model以及对问题进行[建模](https://www.zhihu.com/search?q=建模&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"article"%2C"sourceId"%3A"561627225"})成数学优化问题。再譬如如果有稀疏的算子、譬如稀疏矩阵乘法，那应该如何去与其他算子合并呢



## 方案

### Rewrite

这一模块用于算子的融合库

通过ONNX的Canonicalization框架，match特定类型的算子组合，并进行rewrite融合

可以用于生成算子库，将指定的算子融合，这些算子一般是最常见的？

目前ONNX-MLIR现有的融合库已经足够多，当发现需要自定义的融合规则是，添加起来也很方便。另外若需要在融合中添加自己代码，如添加计时等，需要写pass。

### Pass

这一模块用于算子的通用处理，如算子处理，计算图优化与扩展

##### 计算图

基于数学特性进行图形重写，如删除不必要操作，消除中间结果，算子替换

生成融合策略，暂定采用启发式算法，选取种子后递归的与后继探索，最后与前导进行探索

通过数据流树DFT生成融合代码，怎么高效处理分支是个问题

其他优化，如对数据索引进行优化，对主导算子进行优化

##### 算子处理

在pass中注册fusion pass，为每个算子根据类型赋值TI

pass中调用计算图的处理

进行效果分析

### CostModel

这一模块用于算子的融合选取

为每个算子增加两个属性：类型，阻抗

类型有6种： OneToOne = 1, OneToMany = 2, ManyToMany = 3, Shuffle = 4, Reorganize = 5, UNDEFINED

阻抗设置为：OneToOne = 1, OneToMany = 2, ManyToMany = 3, Shuffle = 1.5, Reorganize = 1.5

目前暂定融合阻抗TI为算子相乘，融合情况如下：

| TI    | fusion                 |
| ----- | ---------------------- |
| 0     | undefine               |
| [1,2] | directly               |
| (2,6) | need further profiling |
| [6,9] | unprofitable           |

特殊情况
first op = ManyToMany，second op = OneToMany，这时候TI=6，但是是可以考虑的

## 实验过程

### ONNX模型

```python
import onnx 
from onnx import helper 
from onnx import TensorProto 
 
# input and output 
a = helper.make_tensor_value_info('a', TensorProto.FLOAT, [10, 10]) 
x = helper.make_tensor_value_info('x', TensorProto.FLOAT, [10, 10]) 
b = helper.make_tensor_value_info('b', TensorProto.FLOAT, [10, 10]) 
output = helper.make_tensor_value_info('output', TensorProto.FLOAT, [10, 10]) 
 
# Mul 
mul = helper.make_node('Mul', ['a', 'x'], ['c']) 
 
# Add 
add = helper.make_node('Add', ['c', 'b'], ['output']) 
 
# graph and model 
graph = helper.make_graph([mul, add], 'linear_func', [a, x, b], [output]) 
model = helper.make_model(graph) 
 
# save model 
onnx.checker.check_model(model) 
print(model) 
onnx.save(model, 'linear_func.onnx') 
```

![linear_func.onnx](http://cdn.qiniu.kyky.tech/uPic/2022/10/17/linear_func.onnx.png)

### ONNX-MLIR使用

The usage of `onnx-mlir` is as such:

```
OVERVIEW: ONNX-MLIR modular optimizer driver

USAGE: onnx-mlir [options] <input file>

OPTIONS:
Generic Options:
  --help        - Display available options (--help-hidden for more)
  --help-list   - Display list of available options (--help-list-hidden for more)
  --version     - Display the version of this program
  
ONNX-MLIR Options:
These are frontend options.
  Choose target to emit:
​      --EmitONNXBasic - Ingest ONNX and emit the basic ONNX operations without inferred shapes.
​      --EmitONNXIR    - Ingest ONNX and emit corresponding ONNX dialect.
​      --EmitMLIR      - Lower the input to MLIR built-in transformation dialect
​      --EmitLLVMIR    - Lower the input to LLVM IR (LLVM MLIR dialect).
​      --EmitObj       - Compile the input to an object file.      
​      --EmitLib       - Compile and link the input into a shared library (default).
​      --EmitJNI       - Compile the input to a jar file.

  Optimization levels:
​      --O0           - Optimization level 0 (default).
​      --O1           - Optimization level 1.
​      --O2           - Optimization level 2.
​      --O3           - Optimization level 3.
```

#### EmitONNXIR

```
module attributes {llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-darwin21.4.0"} {
  func.func @main_graph(%arg0: tensor<10x10xf32>, %arg1: tensor<10x10xf32>, %arg2: tensor<10x10xf32>) -> tensor<10x10xf32> attributes {input_names = ["a", "x", "b"], output_names = ["output"]} {
    %0 = "onnx.Mul"(%arg0, %arg1) : (tensor<10x10xf32>, tensor<10x10xf32>) -> tensor<10x10xf32>
    %1 = "onnx.Add"(%0, %arg2) : (tensor<10x10xf32>, tensor<10x10xf32>) -> tensor<10x10xf32>
    return %1 : tensor<10x10xf32>
  }
  "onnx.EntryPoint"() {func = @main_graph} : () -> ()
}
```

#### EmitMLIR

```mlir
module attributes {llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-darwin21.4.0"} {
  func.func @main_graph(%arg0: memref<10x10xf32>, %arg1: memref<10x10xf32>, %arg2: memref<10x10xf32>) -> memref<10x10xf32> attributes {input_names = ["a", "x", "b"], llvm.emit_c_interface, output_names = ["output"]} {
    %0 = memref.alloc() {alignment = 16 : i64} : memref<10x10xf32>
    affine.for %arg3 = 0 to 10 {
      affine.for %arg4 = 0 to 10 {
        %2 = affine.load %arg0[%arg3, %arg4] : memref<10x10xf32>
        %3 = affine.load %arg1[%arg3, %arg4] : memref<10x10xf32>
        %4 = arith.mulf %2, %3 : f32
        affine.store %4, %0[%arg3, %arg4] : memref<10x10xf32>
      }
    }
    %1 = memref.alloc() {alignment = 16 : i64} : memref<10x10xf32>
    affine.for %arg3 = 0 to 10 {
      affine.for %arg4 = 0 to 10 {
        %2 = affine.load %0[%arg3, %arg4] : memref<10x10xf32>
        %3 = affine.load %arg2[%arg3, %arg4] : memref<10x10xf32>
        %4 = arith.addf %2, %3 : f32
        affine.store %4, %1[%arg3, %arg4] : memref<10x10xf32>
      }
    }
    return %1 : memref<10x10xf32>
  }
  "krnl.entry_point"() {func = @main_graph, numInputs = 3 : i32, numOutputs = 1 : i32, signature = "[    { \22type\22 : \22f32\22 , \22dims\22 : [10 , 10] , \22name\22 : \22a\22 }\0A ,    { \22type\22 : \22f32\22 , \22dims\22 : [10 , 10] , \22name\22 : \22x\22 }\0A ,    { \22type\22 : \22f32\22 , \22dims\22 : [10 , 10] , \22name\22 : \22b\22 }\0A\0A]\00@[   { \22type\22 : \22f32\22 , \22dims\22 : [10 , 10] , \22name\22 : \22output\22 }\0A\0A]\00"} : () -> ()
}

```



#### EmitLLVMIR

```
module attributes {llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-darwin21.4.0"} {
  llvm.func @strncmp(!llvm.ptr<i8>, !llvm.ptr<i8>, i64) -> i32
  llvm.mlir.global external constant @_entry_point_0("run_main_graph\00")
  llvm.mlir.global external constant @_entry_point_0_in_sig("[    { \22type\22 : \22f32\22 , \22dims\22 : [10 , 10] , \22name\22 : \22a\22 }\0A ,    { \22type\22 : \22f32\22 , \22dims\22 : [10 , 10] , \22name\22 : \22x\22 }\0A ,    { \22type\22 : \22f32\22 , \22dims\22 : [10 , 10] , \22name\22 : \22b\22 }\0A\0A]\00")
  llvm.mlir.global external constant @_entry_point_0_out_sig("[   { \22type\22 : \22f32\22 , \22dims\22 : [10 , 10] , \22name\22 : \22output\22 }\0A\0A]\00")
  llvm.func @omTensorListGetSize(!llvm.ptr<i8>) -> i64
  llvm.func @omTensorPrint(!llvm.ptr<i8>, !llvm.ptr<i8>)
  llvm.func @omTensorListGetOmtArray(!llvm.ptr<i8>) -> !llvm.ptr<ptr<i8>>
  llvm.func @omTensorSetDataType(!llvm.ptr<i8>, i64)
  llvm.func @omTensorGetDataType(!llvm.ptr<i8>) -> i64
  llvm.func @omTensorGetStrides(!llvm.ptr<i8>) -> !llvm.ptr<i64>
  llvm.func @omTensorGetShape(!llvm.ptr<i8>) -> !llvm.ptr<i64>
  llvm.func @omTensorGetRank(!llvm.ptr<i8>) -> i64
  llvm.func @omTensorSetDataPtr(!llvm.ptr<i8>, i64, !llvm.ptr<i8>, !llvm.ptr<i8>)
  llvm.func @omTensorGetDataPtr(!llvm.ptr<i8>) -> !llvm.ptr<i8>
  llvm.func @omTensorCreateUntyped(i64) -> !llvm.ptr<i8>
  llvm.func @omTensorListCreateWithOwnership(!llvm.ptr<ptr<i8>>, i64, i64) -> !llvm.ptr<i8>
  llvm.func @free(!llvm.ptr<i8>)
  llvm.func @malloc(i64) -> !llvm.ptr<i8>
  llvm.func @main_graph(%arg0: !llvm.ptr<f32>, %arg1: !llvm.ptr<f32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr<f32>, %arg8: !llvm.ptr<f32>, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr<f32>, %arg15: !llvm.ptr<f32>, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> attributes {input_names = ["a", "x", "b"], llvm.emit_c_interface, output_names = ["output"]} {
    %0 = llvm.mlir.constant(16 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(10 : index) : i64
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.mlir.null : !llvm.ptr<f32>
    %5 = llvm.getelementptr %4[100] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %6 = llvm.ptrtoint %5 : !llvm.ptr<f32> to i64
    %7 = llvm.add %6, %0  : i64
    %8 = llvm.call @malloc(%7) : (i64) -> !llvm.ptr<i8>
    %9 = llvm.bitcast %8 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %10 = llvm.ptrtoint %9 : !llvm.ptr<f32> to i64
    %11 = llvm.sub %0, %3  : i64
    %12 = llvm.add %10, %11  : i64
    %13 = llvm.urem %12, %0  : i64
    %14 = llvm.sub %12, %13  : i64
    %15 = llvm.inttoptr %14 : i64 to !llvm.ptr<f32>
    llvm.br ^bb1(%1 : i64)
  ^bb1(%16: i64):  // 2 preds: ^bb0, ^bb5
    %17 = llvm.icmp "slt" %16, %2 : i64
    llvm.cond_br %17, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%1 : i64)
  ^bb3(%18: i64):  // 2 preds: ^bb2, ^bb4
    %19 = llvm.icmp "slt" %18, %2 : i64
    llvm.cond_br %19, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %20 = llvm.mul %16, %2  : i64
    %21 = llvm.add %20, %18  : i64
    %22 = llvm.getelementptr %arg1[%21] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %23 = llvm.load %22 : !llvm.ptr<f32>
    %24 = llvm.mul %16, %2  : i64
    %25 = llvm.add %24, %18  : i64
    %26 = llvm.getelementptr %arg8[%25] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %27 = llvm.load %26 : !llvm.ptr<f32>
    %28 = llvm.fmul %23, %27  : f32
    %29 = llvm.mul %16, %2  : i64
    %30 = llvm.add %29, %18  : i64
    %31 = llvm.getelementptr %15[%30] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %28, %31 : !llvm.ptr<f32>
    %32 = llvm.add %18, %3  : i64
    llvm.br ^bb3(%32 : i64)
  ^bb5:  // pred: ^bb3
    %33 = llvm.add %16, %3  : i64
    llvm.br ^bb1(%33 : i64)
  ^bb6:  // pred: ^bb1
    %34 = llvm.mlir.null : !llvm.ptr<f32>
    %35 = llvm.getelementptr %34[100] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %36 = llvm.ptrtoint %35 : !llvm.ptr<f32> to i64
    %37 = llvm.add %36, %0  : i64
    %38 = llvm.call @malloc(%37) : (i64) -> !llvm.ptr<i8>
    %39 = llvm.bitcast %38 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %40 = llvm.ptrtoint %39 : !llvm.ptr<f32> to i64
    %41 = llvm.sub %0, %3  : i64
    %42 = llvm.add %40, %41  : i64
    %43 = llvm.urem %42, %0  : i64
    %44 = llvm.sub %42, %43  : i64
    %45 = llvm.inttoptr %44 : i64 to !llvm.ptr<f32>
    %46 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %47 = llvm.insertvalue %39, %46[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.insertvalue %45, %47[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %49 = llvm.insertvalue %1, %48[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %50 = llvm.insertvalue %2, %49[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %51 = llvm.insertvalue %2, %50[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %52 = llvm.insertvalue %2, %51[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %53 = llvm.insertvalue %3, %52[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb7(%1 : i64)
  ^bb7(%54: i64):  // 2 preds: ^bb6, ^bb11
    %55 = llvm.icmp "slt" %54, %2 : i64
    llvm.cond_br %55, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%1 : i64)
  ^bb9(%56: i64):  // 2 preds: ^bb8, ^bb10
    %57 = llvm.icmp "slt" %56, %2 : i64
    llvm.cond_br %57, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %58 = llvm.mul %54, %2  : i64
    %59 = llvm.add %58, %56  : i64
    %60 = llvm.getelementptr %15[%59] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %61 = llvm.load %60 : !llvm.ptr<f32>
    %62 = llvm.mul %54, %2  : i64
    %63 = llvm.add %62, %56  : i64
    %64 = llvm.getelementptr %arg15[%63] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %65 = llvm.load %64 : !llvm.ptr<f32>
    %66 = llvm.fadd %61, %65  : f32
    %67 = llvm.mul %54, %2  : i64
    %68 = llvm.add %67, %56  : i64
    %69 = llvm.getelementptr %45[%68] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %66, %69 : !llvm.ptr<f32>
    %70 = llvm.add %56, %3  : i64
    llvm.br ^bb9(%70 : i64)
  ^bb11:  // pred: ^bb9
    %71 = llvm.add %54, %3  : i64
    llvm.br ^bb7(%71 : i64)
  ^bb12:  // pred: ^bb7
    llvm.call @free(%8) : (!llvm.ptr<i8>) -> ()
    llvm.return %53 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
  }
  llvm.func @_mlir_ciface_main_graph(%arg0: !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>, %arg1: !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>, %arg2: !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>, %arg3: !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>) attributes {input_names = ["a", "x", "b"], llvm.emit_c_interface, output_names = ["output"]} {
    %0 = llvm.load %arg1 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %1 = llvm.extractvalue %0[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.extractvalue %0[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.extractvalue %0[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.extractvalue %0[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.extractvalue %0[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.extractvalue %0[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.extractvalue %0[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.load %arg2 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %9 = llvm.extractvalue %8[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = llvm.extractvalue %8[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.extractvalue %8[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.extractvalue %8[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.extractvalue %8[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.extractvalue %8[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.extractvalue %8[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.load %arg3 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %17 = llvm.extractvalue %16[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.extractvalue %16[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.extractvalue %16[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.extractvalue %16[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.extractvalue %16[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.extractvalue %16[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.extractvalue %16[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.call @main_graph(%1, %2, %3, %4, %5, %6, %7, %9, %10, %11, %12, %13, %14, %15, %17, %18, %19, %20, %21, %22, %23) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    llvm.store %24, %arg0 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.return
  }
  llvm.func @run_main_graph(%arg0: !llvm.ptr<i8>) -> !llvm.ptr<i8> {
    %0 = llvm.mlir.constant(8 : i64) : i64
    %1 = llvm.mlir.constant(2 : i64) : i64
    %2 = llvm.mlir.constant(0 : i64) : i64
    %3 = llvm.mlir.constant(1 : i64) : i64
    %4 = llvm.call @omTensorListGetOmtArray(%arg0) : (!llvm.ptr<i8>) -> !llvm.ptr<ptr<i8>>
    %5 = llvm.alloca %3 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %6 = llvm.load %4 : !llvm.ptr<ptr<i8>>
    %7 = llvm.alloca %3 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %8 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %9 = llvm.call @omTensorGetDataPtr(%6) : (!llvm.ptr<i8>) -> !llvm.ptr<i8>
    %10 = llvm.bitcast %9 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %11 = llvm.insertvalue %10, %8[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %10, %11[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %2, %12[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.call @omTensorGetShape(%6) : (!llvm.ptr<i8>) -> !llvm.ptr<i64>
    %15 = llvm.call @omTensorGetStrides(%6) : (!llvm.ptr<i8>) -> !llvm.ptr<i64>
    %16 = llvm.load %14 : !llvm.ptr<i64>
    %17 = llvm.insertvalue %16, %13[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.load %15 : !llvm.ptr<i64>
    %19 = llvm.insertvalue %18, %17[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.getelementptr %14[1] : (!llvm.ptr<i64>) -> !llvm.ptr<i64>
    %21 = llvm.load %20 : !llvm.ptr<i64>
    %22 = llvm.insertvalue %21, %19[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.getelementptr %15[1] : (!llvm.ptr<i64>) -> !llvm.ptr<i64>
    %24 = llvm.load %23 : !llvm.ptr<i64>
    %25 = llvm.insertvalue %24, %22[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.store %25, %7 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %26 = llvm.getelementptr %4[1] : (!llvm.ptr<ptr<i8>>) -> !llvm.ptr<ptr<i8>>
    %27 = llvm.load %26 : !llvm.ptr<ptr<i8>>
    %28 = llvm.alloca %3 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %29 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %30 = llvm.call @omTensorGetDataPtr(%27) : (!llvm.ptr<i8>) -> !llvm.ptr<i8>
    %31 = llvm.bitcast %30 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %32 = llvm.insertvalue %31, %29[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.insertvalue %31, %32[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %34 = llvm.insertvalue %2, %33[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.call @omTensorGetShape(%27) : (!llvm.ptr<i8>) -> !llvm.ptr<i64>
    %36 = llvm.call @omTensorGetStrides(%27) : (!llvm.ptr<i8>) -> !llvm.ptr<i64>
    %37 = llvm.load %35 : !llvm.ptr<i64>
    %38 = llvm.insertvalue %37, %34[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.load %36 : !llvm.ptr<i64>
    %40 = llvm.insertvalue %39, %38[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %41 = llvm.getelementptr %35[1] : (!llvm.ptr<i64>) -> !llvm.ptr<i64>
    %42 = llvm.load %41 : !llvm.ptr<i64>
    %43 = llvm.insertvalue %42, %40[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %44 = llvm.getelementptr %36[1] : (!llvm.ptr<i64>) -> !llvm.ptr<i64>
    %45 = llvm.load %44 : !llvm.ptr<i64>
    %46 = llvm.insertvalue %45, %43[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.store %46, %28 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %47 = llvm.getelementptr %4[2] : (!llvm.ptr<ptr<i8>>) -> !llvm.ptr<ptr<i8>>
    %48 = llvm.load %47 : !llvm.ptr<ptr<i8>>
    %49 = llvm.alloca %3 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %50 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %51 = llvm.call @omTensorGetDataPtr(%48) : (!llvm.ptr<i8>) -> !llvm.ptr<i8>
    %52 = llvm.bitcast %51 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %53 = llvm.insertvalue %52, %50[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %54 = llvm.insertvalue %52, %53[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %55 = llvm.insertvalue %2, %54[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %56 = llvm.call @omTensorGetShape(%48) : (!llvm.ptr<i8>) -> !llvm.ptr<i64>
    %57 = llvm.call @omTensorGetStrides(%48) : (!llvm.ptr<i8>) -> !llvm.ptr<i64>
    %58 = llvm.load %56 : !llvm.ptr<i64>
    %59 = llvm.insertvalue %58, %55[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %60 = llvm.load %57 : !llvm.ptr<i64>
    %61 = llvm.insertvalue %60, %59[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %62 = llvm.getelementptr %56[1] : (!llvm.ptr<i64>) -> !llvm.ptr<i64>
    %63 = llvm.load %62 : !llvm.ptr<i64>
    %64 = llvm.insertvalue %63, %61[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %65 = llvm.getelementptr %57[1] : (!llvm.ptr<i64>) -> !llvm.ptr<i64>
    %66 = llvm.load %65 : !llvm.ptr<i64>
    %67 = llvm.insertvalue %66, %64[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.store %67, %49 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.call @_mlir_ciface_main_graph(%5, %7, %28, %49) : (!llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>, !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>, !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>, !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>) -> ()
    %68 = llvm.load %5 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %69 = llvm.call @malloc(%0) : (i64) -> !llvm.ptr<i8>
    %70 = llvm.bitcast %69 : !llvm.ptr<i8> to !llvm.ptr<ptr<i8>>
    %71 = llvm.call @omTensorCreateUntyped(%1) : (i64) -> !llvm.ptr<i8>
    %72 = llvm.extractvalue %68[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %73 = llvm.bitcast %72 : !llvm.ptr<f32> to !llvm.ptr<i8>
    %74 = llvm.extractvalue %68[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %75 = llvm.bitcast %74 : !llvm.ptr<f32> to !llvm.ptr<i8>
    llvm.call @omTensorSetDataPtr(%71, %3, %73, %75) : (!llvm.ptr<i8>, i64, !llvm.ptr<i8>, !llvm.ptr<i8>) -> ()
    llvm.call @omTensorSetDataType(%71, %3) : (!llvm.ptr<i8>, i64) -> ()
    %76 = llvm.call @omTensorGetShape(%71) : (!llvm.ptr<i8>) -> !llvm.ptr<i64>
    %77 = llvm.call @omTensorGetStrides(%71) : (!llvm.ptr<i8>) -> !llvm.ptr<i64>
    %78 = llvm.extractvalue %68[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.store %78, %76 : !llvm.ptr<i64>
    %79 = llvm.extractvalue %68[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.store %79, %77 : !llvm.ptr<i64>
    %80 = llvm.extractvalue %68[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %81 = llvm.getelementptr %76[1] : (!llvm.ptr<i64>) -> !llvm.ptr<i64>
    llvm.store %80, %81 : !llvm.ptr<i64>
    %82 = llvm.extractvalue %68[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %83 = llvm.getelementptr %77[1] : (!llvm.ptr<i64>) -> !llvm.ptr<i64>
    llvm.store %82, %83 : !llvm.ptr<i64>
    llvm.store %71, %70 : !llvm.ptr<ptr<i8>>
    %84 = llvm.call @omTensorListCreateWithOwnership(%70, %3, %3) : (!llvm.ptr<ptr<i8>>, i64, i64) -> !llvm.ptr<i8>
    llvm.return %84 : !llvm.ptr<i8>
  }
  llvm.mlir.global internal constant @_entry_point_arrays() : !llvm.array<2 x ptr<i8>> {
    %0 = llvm.mlir.undef : !llvm.array<2 x ptr<i8>>
    %1 = llvm.mlir.addressof @_entry_point_0 : !llvm.ptr<array<15 x i8>>
    %2 = llvm.getelementptr %1[0, 0] : (!llvm.ptr<array<15 x i8>>) -> !llvm.ptr<i8>
    %3 = llvm.insertvalue %2, %0[0] : !llvm.array<2 x ptr<i8>> 
    %4 = llvm.mlir.null : !llvm.ptr<i8>
    %5 = llvm.insertvalue %4, %3[1] : !llvm.array<2 x ptr<i8>> 
    llvm.return %5 : !llvm.array<2 x ptr<i8>>
  }
  llvm.func @omQueryEntryPoints(%arg0: !llvm.ptr<i64>) -> !llvm.ptr<ptr<i8>> {
    %0 = llvm.mlir.constant(1 : i64) : i64
    %1 = llvm.mlir.null : !llvm.ptr<i64>
    %2 = llvm.icmp "ne" %arg0, %1 : !llvm.ptr<i64>
    llvm.cond_br %2, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    llvm.store %0, %arg0 : !llvm.ptr<i64>
    llvm.br ^bb2
  ^bb2:  // 2 preds: ^bb0, ^bb1
    %3 = llvm.mlir.addressof @_entry_point_arrays : !llvm.ptr<array<2 x ptr<i8>>>
    %4 = llvm.bitcast %3 : !llvm.ptr<array<2 x ptr<i8>>> to !llvm.ptr<ptr<i8>>
    llvm.return %4 : !llvm.ptr<ptr<i8>>
  }
  llvm.func @omInputSignature(%arg0: !llvm.ptr<i8>) -> !llvm.ptr<i8> {
    %0 = llvm.mlir.constant(15 : i64) : i64
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.addressof @_entry_point_0 : !llvm.ptr<array<15 x i8>>
    %3 = llvm.getelementptr %2[0, 0] : (!llvm.ptr<array<15 x i8>>) -> !llvm.ptr<i8>
    %4 = llvm.call @strncmp(%arg0, %3, %0) : (!llvm.ptr<i8>, !llvm.ptr<i8>, i64) -> i32
    %5 = llvm.icmp "eq" %4, %1 : i32
    llvm.cond_br %5, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %6 = llvm.mlir.addressof @_entry_point_0_in_sig : !llvm.ptr<array<185 x i8>>
    %7 = llvm.bitcast %6 : !llvm.ptr<array<185 x i8>> to !llvm.ptr<i8>
    llvm.return %7 : !llvm.ptr<i8>
  ^bb2:  // pred: ^bb0
    %8 = llvm.mlir.null : !llvm.ptr<i8>
    llvm.return %8 : !llvm.ptr<i8>
  }
  llvm.func @omOutputSignature(%arg0: !llvm.ptr<i8>) -> !llvm.ptr<i8> {
    %0 = llvm.mlir.constant(15 : i64) : i64
    %1 = llvm.mlir.constant(0 : i32) : i32
    %2 = llvm.mlir.addressof @_entry_point_0 : !llvm.ptr<array<15 x i8>>
    %3 = llvm.getelementptr %2[0, 0] : (!llvm.ptr<array<15 x i8>>) -> !llvm.ptr<i8>
    %4 = llvm.call @strncmp(%arg0, %3, %0) : (!llvm.ptr<i8>, !llvm.ptr<i8>, i64) -> i32
    %5 = llvm.icmp "eq" %4, %1 : i32
    llvm.cond_br %5, ^bb1, ^bb2
  ^bb1:  // pred: ^bb0
    %6 = llvm.mlir.addressof @_entry_point_0_out_sig : !llvm.ptr<array<67 x i8>>
    %7 = llvm.bitcast %6 : !llvm.ptr<array<67 x i8>> to !llvm.ptr<i8>
    llvm.return %7 : !llvm.ptr<i8>
  ^bb2:  // pred: ^bb0
    %8 = llvm.mlir.null : !llvm.ptr<i8>
    llvm.return %8 : !llvm.ptr<i8>
  }
}
```



#### instrument

```
 ./build/Debug/bin/onnx-mlir  --instrument-onnx-ops="ALL" --InstrumentBeforeOp --InstrumentAfterOp --InstrumentReportTime linear_func.onnx
```

没有输出，原因未知



### fusion

#### rewrite

ONNX模型如下

![linear_func.onnx (1)](http://cdn.qiniu.kyky.tech/uPic/2022/10/17/linear_func.onnx%20(1).png)input.mlir

执行`--EmitONNXIR`，不进行rewrite的情况

```
module attributes {llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-darwin21.4.0"} {
  func.func @main_graph(%arg0: tensor<10x10xf32>, %arg1: tensor<10x10xf32>, %arg2: tensor<10x10xf32>) -> tensor<10x10xf32> attributes {input_names = ["a", "x", "b"], output_names = ["output"]} {
    %0 = "onnx.MatMul"(%arg0, %arg1) : (tensor<10x10xf32>, tensor<10x10xf32>) -> tensor<*xf32>
    %1 = "onnx.Add"(%0, %arg2) : (tensor<*xf32>, tensor<10x10xf32>) -> tensor<10x10xf32>
    return %1 : tensor<10x10xf32>
  }
  "onnx.EntryPoint"() {func = @main_graph} : () -> ()
}

```

rewrite规则为

` onnx.add(onnx.Gemm(%X, %Y, None), %Z) = onnx.Gemm(%X, %Y, %Z)`

rewrite后的输出

```
module attributes {llvm.data_layout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-apple-darwin21.4.0"} {
  func.func @main_graph(%arg0: tensor<10x10xf32>, %arg1: tensor<10x10xf32>, %arg2: tensor<10x10xf32>) -> tensor<10x10xf32> attributes {input_names = ["a", "x", "b"], output_names = ["output"]} {
    %0 = "onnx.Gemm"(%arg0, %arg1, %arg2) {alpha = 1.000000e+00 : f32, beta = 1.000000e+00 : f32, transA = 0 : si64, transB = 0 : si64} : (tensor<10x10xf32>, tensor<10x10xf32>, tensor<10x10xf32>) -> tensor<10x10xf32>
    return %0 : tensor<10x10xf32>
  }
  "onnx.EntryPoint"() {func = @main_graph} : () -> ()
}

```

#### Pass

#### CostModel



### 测试

##### gdb

```
Reading symbols from build/Debug/bin/run-onnx-lib...
(No debugging symbols found in build/Debug/bin/run-onnx-lib)
(gdb)  b run_main_graph
Function "run_main_graph" not defined.
Make breakpoint pending on future shared library load? (y or [n]) y
Breakpoint 1 (run_main_graph) pending.
(gdb) run add.so 
Starting program: /Users/wangchenhao/Documents/Enflame/workSpace/onnx-mlir/build/Debug/bin/run-onnx-lib ../linear_func.so
```

报错gdb签名失败

```
Starting program: /Users/wangchenhao/Documents/Enflame/workSpace/onnx-mlir/build/Debug/bin/run-onnx-lib ../linear_func.so
Note: this version of macOS has System Integrity Protection.
Because `startup-with-shell' is enabled, gdb has worked around this by
caching a copy of your shell.  The shell used by "run" is now:
    /Users/wangchenhao/Library/Caches/gdb/bin/zsh
Unable to find Mach task port for process-id 49332: (os/kern) failure (0x5).
 (please check gdb is codesigned - see taskgated(8))
```

这是由于mac开启了安全模式，尝试在系统证书中添加了签名

仍然出现签名问题

```
Reading symbols from build/Debug/bin/run-onnx-lib...
(No debugging symbols found in build/Debug/bin/run-onnx-lib)
(gdb)  b run_main_graph
Function "run_main_graph" not defined.
Make breakpoint pending on future shared library load? (y or [n]) y
Breakpoint 1 (run_main_graph) pending.
(gdb) run add.so 
Starting program: /Users/wangchenhao/Documents/Enflame/workSpace/onnx-mlir/build/Debug/bin/run-onnx-lib add.so
Unable to find Mach task port for process-id 70697: (os/kern) failure (0x5).
 (please check gdb is codesigned - see taskgated(8))
```

最后只能尝试关闭mac的SIP

todo





## 问题

1. instrument怎么不生效
2. rewriter不生效，以及mlir diag怎么打印