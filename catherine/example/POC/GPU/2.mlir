module {
  llvm.func @malloc(i64) -> !llvm.ptr<i8>
  func.func @matmul_linalg(%arg0: memref<8x8xf32>, %arg1: memref<8x8xf32>, %arg2: memref<8x8xf32>) {
    %0 = llvm.mlir.constant(8 : index) : i64
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index
    %c0 = arith.constant 0 : index
    %1 = builtin.unrealized_conversion_cast %arg0 : memref<8x8xf32> to !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %2 = builtin.unrealized_conversion_cast %arg1 : memref<8x8xf32> to !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %3 = builtin.unrealized_conversion_cast %arg2 : memref<8x8xf32> to !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    cf.br ^bb1(%c0 : index)
  ^bb1(%4: index):  // 2 preds: ^bb0, ^bb11
    %5 = arith.cmpi slt, %4, %c8 : index
    cf.cond_br %5, ^bb2(%c0 : index), ^bb12
  ^bb2(%6: index):  // 2 preds: ^bb1, ^bb10
    %7 = arith.cmpi slt, %6, %c8 : index
    cf.cond_br %7, ^bb3(%c0 : index), ^bb11
  ^bb3(%8: index):  // 2 preds: ^bb2, ^bb9
    %9 = arith.cmpi slt, %8, %c1 : index
    cf.cond_br %9, ^bb4(%c0 : index), ^bb10
  ^bb4(%10: index):  // 2 preds: ^bb3, ^bb8
    %11 = arith.cmpi slt, %10, %c1 : index
    cf.cond_br %11, ^bb5, ^bb9
  ^bb5:  // pred: ^bb4
    %12 = arith.addi %8, %4 : index
    %13 = builtin.unrealized_conversion_cast %12 : index to i64
    %14 = arith.addi %10, %6 : index
    %15 = builtin.unrealized_conversion_cast %14 : index to i64
    cf.br ^bb6(%c0 : index)
  ^bb6(%16: index):  // 2 preds: ^bb5, ^bb7
    %17 = builtin.unrealized_conversion_cast %16 : index to i64
    %18 = arith.cmpi slt, %16, %c8 : index
    cf.cond_br %18, ^bb7, ^bb8
  ^bb7:  // pred: ^bb6
    %19 = llvm.extractvalue %1[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.mul %13, %0  : i64
    %21 = llvm.add %20, %17  : i64
    %22 = llvm.getelementptr %19[%21] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %23 = llvm.load %22 : !llvm.ptr<f32>
    %24 = llvm.extractvalue %2[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.mul %17, %0  : i64
    %26 = llvm.add %25, %15  : i64
    %27 = llvm.getelementptr %24[%26] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %28 = llvm.load %27 : !llvm.ptr<f32>
    %29 = llvm.extractvalue %3[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.mul %13, %0  : i64
    %31 = llvm.add %30, %15  : i64
    %32 = llvm.getelementptr %29[%31] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %33 = llvm.load %32 : !llvm.ptr<f32>
    %34 = arith.mulf %23, %28 : f32
    %35 = arith.addf %33, %34 : f32
    %36 = llvm.extractvalue %3[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.mul %13, %0  : i64
    %38 = llvm.add %37, %15  : i64
    %39 = llvm.getelementptr %36[%38] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %35, %39 : !llvm.ptr<f32>
    %40 = arith.addi %16, %c1 : index
    cf.br ^bb6(%40 : index)
  ^bb8:  // pred: ^bb6
    %41 = arith.addi %10, %c1 : index
    cf.br ^bb4(%41 : index)
  ^bb9:  // pred: ^bb4
    %42 = arith.addi %8, %c1 : index
    cf.br ^bb3(%42 : index)
  ^bb10:  // pred: ^bb3
    %43 = arith.addi %6, %c1 : index
    cf.br ^bb2(%43 : index)
  ^bb11:  // pred: ^bb2
    %44 = arith.addi %4, %c1 : index
    cf.br ^bb1(%44 : index)
  ^bb12:  // pred: ^bb1
    return
  }
  func.func @main() {
    %0 = llvm.mlir.constant(2 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %c0 = arith.constant 0 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 1.000000e+00 : f32
    %2 = llvm.mlir.constant(8 : index) : i64
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.mlir.null : !llvm.ptr<f32>
    %5 = llvm.getelementptr %4[64] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %6 = llvm.ptrtoint %5 : !llvm.ptr<f32> to i64
    %7 = llvm.call @malloc(%6) : (i64) -> !llvm.ptr<i8>
    %8 = llvm.bitcast %7 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %9 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %10 = llvm.insertvalue %8, %9[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %8, %10[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %1, %11[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %2, %12[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %2, %13[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %2, %14[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.insertvalue %3, %15[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = builtin.unrealized_conversion_cast %16 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<8x8xf32>
    %18 = llvm.mlir.null : !llvm.ptr<f32>
    %19 = llvm.getelementptr %18[64] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %20 = llvm.ptrtoint %19 : !llvm.ptr<f32> to i64
    %21 = llvm.call @malloc(%20) : (i64) -> !llvm.ptr<i8>
    %22 = llvm.bitcast %21 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %23 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %24 = llvm.insertvalue %22, %23[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.insertvalue %22, %24[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.insertvalue %1, %25[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %27 = llvm.insertvalue %2, %26[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %28 = llvm.insertvalue %2, %27[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %29 = llvm.insertvalue %2, %28[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.insertvalue %3, %29[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %31 = builtin.unrealized_conversion_cast %30 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<8x8xf32>
    %32 = llvm.mlir.null : !llvm.ptr<f32>
    %33 = llvm.getelementptr %32[64] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %34 = llvm.ptrtoint %33 : !llvm.ptr<f32> to i64
    %35 = llvm.call @malloc(%34) : (i64) -> !llvm.ptr<i8>
    %36 = llvm.bitcast %35 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %37 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %38 = llvm.insertvalue %36, %37[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.insertvalue %36, %38[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.insertvalue %1, %39[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %41 = llvm.insertvalue %2, %40[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %42 = llvm.insertvalue %2, %41[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %43 = llvm.insertvalue %2, %42[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %44 = llvm.insertvalue %3, %43[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %45 = builtin.unrealized_conversion_cast %44 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<8x8xf32>
    %46 = llvm.alloca %3 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %16, %46 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %47 = llvm.bitcast %46 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %48 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %49 = llvm.insertvalue %0, %48[0] : !llvm.struct<(i64, ptr<i8>)> 
    %50 = llvm.insertvalue %47, %49[1] : !llvm.struct<(i64, ptr<i8>)> 
    %51 = builtin.unrealized_conversion_cast %50 : !llvm.struct<(i64, ptr<i8>)> to memref<*xf32>
    %52 = llvm.alloca %3 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %30, %52 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %53 = llvm.bitcast %52 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %54 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %55 = llvm.insertvalue %0, %54[0] : !llvm.struct<(i64, ptr<i8>)> 
    %56 = llvm.insertvalue %53, %55[1] : !llvm.struct<(i64, ptr<i8>)> 
    %57 = builtin.unrealized_conversion_cast %56 : !llvm.struct<(i64, ptr<i8>)> to memref<*xf32>
    %58 = llvm.alloca %3 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %44, %58 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %59 = llvm.bitcast %58 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %60 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %61 = llvm.insertvalue %0, %60[0] : !llvm.struct<(i64, ptr<i8>)> 
    %62 = llvm.insertvalue %59, %61[1] : !llvm.struct<(i64, ptr<i8>)> 
    %63 = builtin.unrealized_conversion_cast %62 : !llvm.struct<(i64, ptr<i8>)> to memref<*xf32>
    gpu.host_register %51 : memref<*xf32>
    gpu.host_register %57 : memref<*xf32>
    gpu.host_register %63 : memref<*xf32>
    cf.br ^bb1(%c0 : index)
  ^bb1(%64: index):  // 2 preds: ^bb0, ^bb8
    %65 = arith.cmpi slt, %64, %c8 : index
    cf.cond_br %65, ^bb2(%c0 : index), ^bb9(%c0 : index)
  ^bb2(%66: index):  // 2 preds: ^bb1, ^bb7
    %67 = arith.cmpi slt, %66, %c8 : index
    cf.cond_br %67, ^bb3(%c0 : index), ^bb8
  ^bb3(%68: index):  // 2 preds: ^bb2, ^bb6
    %69 = arith.cmpi slt, %68, %c1 : index
    cf.cond_br %69, ^bb4(%c0 : index), ^bb7
  ^bb4(%70: index):  // 2 preds: ^bb3, ^bb5
    %71 = arith.cmpi slt, %70, %c1 : index
    cf.cond_br %71, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %72 = arith.addi %68, %64 : index
    %73 = builtin.unrealized_conversion_cast %72 : index to i64
    %74 = arith.addi %70, %66 : index
    %75 = builtin.unrealized_conversion_cast %74 : index to i64
    %76 = llvm.mul %73, %2  : i64
    %77 = llvm.add %76, %75  : i64
    %78 = llvm.getelementptr %8[%77] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %cst, %78 : !llvm.ptr<f32>
    %79 = arith.addi %70, %c1 : index
    cf.br ^bb4(%79 : index)
  ^bb6:  // pred: ^bb4
    %80 = arith.addi %68, %c1 : index
    cf.br ^bb3(%80 : index)
  ^bb7:  // pred: ^bb3
    %81 = arith.addi %66, %c1 : index
    cf.br ^bb2(%81 : index)
  ^bb8:  // pred: ^bb2
    %82 = arith.addi %64, %c1 : index
    cf.br ^bb1(%82 : index)
  ^bb9(%83: index):  // 2 preds: ^bb1, ^bb16
    %84 = arith.cmpi slt, %83, %c8 : index
    cf.cond_br %84, ^bb10(%c0 : index), ^bb17(%c0 : index)
  ^bb10(%85: index):  // 2 preds: ^bb9, ^bb15
    %86 = arith.cmpi slt, %85, %c8 : index
    cf.cond_br %86, ^bb11(%c0 : index), ^bb16
  ^bb11(%87: index):  // 2 preds: ^bb10, ^bb14
    %88 = arith.cmpi slt, %87, %c1 : index
    cf.cond_br %88, ^bb12(%c0 : index), ^bb15
  ^bb12(%89: index):  // 2 preds: ^bb11, ^bb13
    %90 = arith.cmpi slt, %89, %c1 : index
    cf.cond_br %90, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %91 = arith.addi %87, %83 : index
    %92 = builtin.unrealized_conversion_cast %91 : index to i64
    %93 = arith.addi %89, %85 : index
    %94 = builtin.unrealized_conversion_cast %93 : index to i64
    %95 = llvm.mul %92, %2  : i64
    %96 = llvm.add %95, %94  : i64
    %97 = llvm.getelementptr %22[%96] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %cst, %97 : !llvm.ptr<f32>
    %98 = arith.addi %89, %c1 : index
    cf.br ^bb12(%98 : index)
  ^bb14:  // pred: ^bb12
    %99 = arith.addi %87, %c1 : index
    cf.br ^bb11(%99 : index)
  ^bb15:  // pred: ^bb11
    %100 = arith.addi %85, %c1 : index
    cf.br ^bb10(%100 : index)
  ^bb16:  // pred: ^bb10
    %101 = arith.addi %83, %c1 : index
    cf.br ^bb9(%101 : index)
  ^bb17(%102: index):  // 2 preds: ^bb9, ^bb24
    %103 = arith.cmpi slt, %102, %c8 : index
    cf.cond_br %103, ^bb18(%c0 : index), ^bb25
  ^bb18(%104: index):  // 2 preds: ^bb17, ^bb23
    %105 = arith.cmpi slt, %104, %c8 : index
    cf.cond_br %105, ^bb19(%c0 : index), ^bb24
  ^bb19(%106: index):  // 2 preds: ^bb18, ^bb22
    %107 = arith.cmpi slt, %106, %c1 : index
    cf.cond_br %107, ^bb20(%c0 : index), ^bb23
  ^bb20(%108: index):  // 2 preds: ^bb19, ^bb21
    %109 = arith.cmpi slt, %108, %c1 : index
    cf.cond_br %109, ^bb21, ^bb22
  ^bb21:  // pred: ^bb20
    %110 = arith.addi %106, %102 : index
    %111 = builtin.unrealized_conversion_cast %110 : index to i64
    %112 = arith.addi %108, %104 : index
    %113 = builtin.unrealized_conversion_cast %112 : index to i64
    %114 = llvm.mul %111, %2  : i64
    %115 = llvm.add %114, %113  : i64
    %116 = llvm.getelementptr %36[%115] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %cst, %116 : !llvm.ptr<f32>
    %117 = arith.addi %108, %c1 : index
    cf.br ^bb20(%117 : index)
  ^bb22:  // pred: ^bb20
    %118 = arith.addi %106, %c1 : index
    cf.br ^bb19(%118 : index)
  ^bb23:  // pred: ^bb19
    %119 = arith.addi %104, %c1 : index
    cf.br ^bb18(%119 : index)
  ^bb24:  // pred: ^bb18
    %120 = arith.addi %102, %c1 : index
    cf.br ^bb17(%120 : index)
  ^bb25:  // pred: ^bb17
    call @matmul_linalg(%17, %31, %45) : (memref<8x8xf32>, memref<8x8xf32>, memref<8x8xf32>) -> ()
    return
  }
}

