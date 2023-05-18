module {
  llvm.func @malloc(i64) -> !llvm.ptr<i8>
  llvm.func @matmul_linalg(%arg0: !llvm.ptr<f32>, %arg1: !llvm.ptr<f32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr<f32>, %arg8: !llvm.ptr<f32>, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr<f32>, %arg15: !llvm.ptr<f32>, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64) {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.insertvalue %arg5, %4[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg6, %6[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = builtin.unrealized_conversion_cast %7 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<8x8xf32>
    %9 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %10 = llvm.insertvalue %arg7, %9[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %arg8, %10[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %arg9, %11[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %arg10, %12[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg12, %13[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg11, %14[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.insertvalue %arg13, %15[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = builtin.unrealized_conversion_cast %16 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<8x8xf32>
    %18 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %19 = llvm.insertvalue %arg14, %18[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %arg15, %19[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %arg16, %20[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %arg17, %21[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %arg19, %22[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.insertvalue %arg18, %23[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.insertvalue %arg20, %24[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = builtin.unrealized_conversion_cast %25 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<8x8xf32>
    %27 = llvm.mlir.constant(8 : index) : i64
    %28 = llvm.mlir.constant(1 : index) : i64
    %29 = llvm.mlir.constant(8 : index) : i64
    %30 = llvm.mlir.constant(0 : index) : i64
    %31 = builtin.unrealized_conversion_cast %8 : memref<8x8xf32> to !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %32 = builtin.unrealized_conversion_cast %17 : memref<8x8xf32> to !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %33 = builtin.unrealized_conversion_cast %26 : memref<8x8xf32> to !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    llvm.br ^bb1(%30 : i64)
  ^bb1(%34: i64):  // 2 preds: ^bb0, ^bb11
    %35 = llvm.icmp "slt" %34, %29 : i64
    llvm.cond_br %35, ^bb2(%30 : i64), ^bb12
  ^bb2(%36: i64):  // 2 preds: ^bb1, ^bb10
    %37 = llvm.icmp "slt" %36, %29 : i64
    llvm.cond_br %37, ^bb3(%30 : i64), ^bb11
  ^bb3(%38: i64):  // 2 preds: ^bb2, ^bb9
    %39 = llvm.icmp "slt" %38, %28 : i64
    llvm.cond_br %39, ^bb4(%30 : i64), ^bb10
  ^bb4(%40: i64):  // 2 preds: ^bb3, ^bb8
    %41 = llvm.icmp "slt" %40, %28 : i64
    llvm.cond_br %41, ^bb5, ^bb9
  ^bb5:  // pred: ^bb4
    %42 = llvm.add %38, %34  : i64
    %43 = builtin.unrealized_conversion_cast %42 : i64 to index
    %44 = builtin.unrealized_conversion_cast %43 : index to i64
    %45 = llvm.add %40, %36  : i64
    %46 = builtin.unrealized_conversion_cast %45 : i64 to index
    %47 = builtin.unrealized_conversion_cast %46 : index to i64
    llvm.br ^bb6(%30 : i64)
  ^bb6(%48: i64):  // 2 preds: ^bb5, ^bb7
    %49 = builtin.unrealized_conversion_cast %48 : i64 to index
    %50 = builtin.unrealized_conversion_cast %49 : index to i64
    %51 = llvm.icmp "slt" %48, %29 : i64
    llvm.cond_br %51, ^bb7, ^bb8
  ^bb7:  // pred: ^bb6
    %52 = llvm.extractvalue %31[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %53 = llvm.mul %44, %27  : i64
    %54 = llvm.add %53, %50  : i64
    %55 = llvm.getelementptr %52[%54] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %56 = llvm.load %55 : !llvm.ptr<f32>
    %57 = llvm.extractvalue %32[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %58 = llvm.mul %50, %27  : i64
    %59 = llvm.add %58, %47  : i64
    %60 = llvm.getelementptr %57[%59] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %61 = llvm.load %60 : !llvm.ptr<f32>
    %62 = llvm.extractvalue %33[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %63 = llvm.mul %44, %27  : i64
    %64 = llvm.add %63, %47  : i64
    %65 = llvm.getelementptr %62[%64] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %66 = llvm.load %65 : !llvm.ptr<f32>
    %67 = llvm.fmul %56, %61  : f32
    %68 = llvm.fadd %66, %67  : f32
    %69 = llvm.extractvalue %33[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %70 = llvm.mul %44, %27  : i64
    %71 = llvm.add %70, %47  : i64
    %72 = llvm.getelementptr %69[%71] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %68, %72 : !llvm.ptr<f32>
    %73 = llvm.add %48, %28  : i64
    llvm.br ^bb6(%73 : i64)
  ^bb8:  // pred: ^bb6
    %74 = llvm.add %40, %28  : i64
    llvm.br ^bb4(%74 : i64)
  ^bb9:  // pred: ^bb4
    %75 = llvm.add %38, %28  : i64
    llvm.br ^bb3(%75 : i64)
  ^bb10:  // pred: ^bb3
    %76 = llvm.add %36, %28  : i64
    llvm.br ^bb2(%76 : i64)
  ^bb11:  // pred: ^bb2
    %77 = llvm.add %34, %28  : i64
    llvm.br ^bb1(%77 : i64)
  ^bb12:  // pred: ^bb1
    llvm.return
  }
  llvm.func @main() {
    %0 = llvm.mlir.constant(2 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(0 : index) : i64
    %3 = llvm.mlir.constant(8 : index) : i64
    %4 = llvm.mlir.constant(1 : index) : i64
    %5 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %6 = llvm.mlir.constant(8 : index) : i64
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.null : !llvm.ptr<f32>
    %9 = llvm.getelementptr %8[64] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %10 = llvm.ptrtoint %9 : !llvm.ptr<f32> to i64
    %11 = llvm.call @malloc(%10) : (i64) -> !llvm.ptr<i8>
    %12 = llvm.bitcast %11 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %13 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %14 = llvm.insertvalue %12, %13[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %12, %14[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.insertvalue %1, %15[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %17 = llvm.insertvalue %6, %16[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.insertvalue %6, %17[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %6, %18[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %7, %19[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = builtin.unrealized_conversion_cast %20 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<8x8xf32>
    %22 = llvm.mlir.null : !llvm.ptr<f32>
    %23 = llvm.getelementptr %22[64] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %24 = llvm.ptrtoint %23 : !llvm.ptr<f32> to i64
    %25 = llvm.call @malloc(%24) : (i64) -> !llvm.ptr<i8>
    %26 = llvm.bitcast %25 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %27 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %28 = llvm.insertvalue %26, %27[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %29 = llvm.insertvalue %26, %28[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.insertvalue %1, %29[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %31 = llvm.insertvalue %6, %30[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %32 = llvm.insertvalue %6, %31[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.insertvalue %6, %32[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %34 = llvm.insertvalue %7, %33[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = builtin.unrealized_conversion_cast %34 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<8x8xf32>
    %36 = llvm.mlir.null : !llvm.ptr<f32>
    %37 = llvm.getelementptr %36[64] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %38 = llvm.ptrtoint %37 : !llvm.ptr<f32> to i64
    %39 = llvm.call @malloc(%38) : (i64) -> !llvm.ptr<i8>
    %40 = llvm.bitcast %39 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %41 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %42 = llvm.insertvalue %40, %41[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %43 = llvm.insertvalue %40, %42[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %44 = llvm.insertvalue %1, %43[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %45 = llvm.insertvalue %6, %44[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %46 = llvm.insertvalue %6, %45[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %47 = llvm.insertvalue %6, %46[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.insertvalue %7, %47[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %49 = builtin.unrealized_conversion_cast %48 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> to memref<8x8xf32>
    %50 = llvm.alloca %7 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %20, %50 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %51 = llvm.bitcast %50 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %52 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %53 = llvm.insertvalue %0, %52[0] : !llvm.struct<(i64, ptr<i8>)> 
    %54 = llvm.insertvalue %51, %53[1] : !llvm.struct<(i64, ptr<i8>)> 
    %55 = builtin.unrealized_conversion_cast %54 : !llvm.struct<(i64, ptr<i8>)> to memref<*xf32>
    %56 = llvm.alloca %7 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %34, %56 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %57 = llvm.bitcast %56 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %58 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %59 = llvm.insertvalue %0, %58[0] : !llvm.struct<(i64, ptr<i8>)> 
    %60 = llvm.insertvalue %57, %59[1] : !llvm.struct<(i64, ptr<i8>)> 
    %61 = builtin.unrealized_conversion_cast %60 : !llvm.struct<(i64, ptr<i8>)> to memref<*xf32>
    %62 = llvm.alloca %7 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %48, %62 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %63 = llvm.bitcast %62 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %64 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %65 = llvm.insertvalue %0, %64[0] : !llvm.struct<(i64, ptr<i8>)> 
    %66 = llvm.insertvalue %63, %65[1] : !llvm.struct<(i64, ptr<i8>)> 
    %67 = builtin.unrealized_conversion_cast %66 : !llvm.struct<(i64, ptr<i8>)> to memref<*xf32>
    %68 = llvm.mlir.null : !llvm.ptr<f32>
    %69 = llvm.getelementptr %68[1] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %70 = llvm.ptrtoint %69 : !llvm.ptr<f32> to i64
    %71 = llvm.extractvalue %54[0] : !llvm.struct<(i64, ptr<i8>)> 
    %72 = llvm.extractvalue %54[1] : !llvm.struct<(i64, ptr<i8>)> 
    llvm.call @mgpuMemHostRegisterMemRef(%71, %72, %70) : (i64, !llvm.ptr<i8>, i64) -> ()
    %73 = llvm.mlir.null : !llvm.ptr<f32>
    %74 = llvm.getelementptr %73[1] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %75 = llvm.ptrtoint %74 : !llvm.ptr<f32> to i64
    %76 = llvm.extractvalue %60[0] : !llvm.struct<(i64, ptr<i8>)> 
    %77 = llvm.extractvalue %60[1] : !llvm.struct<(i64, ptr<i8>)> 
    llvm.call @mgpuMemHostRegisterMemRef(%76, %77, %75) : (i64, !llvm.ptr<i8>, i64) -> ()
    %78 = llvm.mlir.null : !llvm.ptr<f32>
    %79 = llvm.getelementptr %78[1] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %80 = llvm.ptrtoint %79 : !llvm.ptr<f32> to i64
    %81 = llvm.extractvalue %66[0] : !llvm.struct<(i64, ptr<i8>)> 
    %82 = llvm.extractvalue %66[1] : !llvm.struct<(i64, ptr<i8>)> 
    llvm.call @mgpuMemHostRegisterMemRef(%81, %82, %80) : (i64, !llvm.ptr<i8>, i64) -> ()
    llvm.br ^bb1(%2 : i64)
  ^bb1(%83: i64):  // 2 preds: ^bb0, ^bb8
    %84 = llvm.icmp "slt" %83, %3 : i64
    llvm.cond_br %84, ^bb2(%2 : i64), ^bb9(%2 : i64)
  ^bb2(%85: i64):  // 2 preds: ^bb1, ^bb7
    %86 = llvm.icmp "slt" %85, %3 : i64
    llvm.cond_br %86, ^bb3(%2 : i64), ^bb8
  ^bb3(%87: i64):  // 2 preds: ^bb2, ^bb6
    %88 = llvm.icmp "slt" %87, %4 : i64
    llvm.cond_br %88, ^bb4(%2 : i64), ^bb7
  ^bb4(%89: i64):  // 2 preds: ^bb3, ^bb5
    %90 = llvm.icmp "slt" %89, %4 : i64
    llvm.cond_br %90, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %91 = llvm.add %87, %83  : i64
    %92 = builtin.unrealized_conversion_cast %91 : i64 to index
    %93 = builtin.unrealized_conversion_cast %92 : index to i64
    %94 = llvm.add %89, %85  : i64
    %95 = builtin.unrealized_conversion_cast %94 : i64 to index
    %96 = builtin.unrealized_conversion_cast %95 : index to i64
    %97 = llvm.mul %93, %6  : i64
    %98 = llvm.add %97, %96  : i64
    %99 = llvm.getelementptr %12[%98] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %5, %99 : !llvm.ptr<f32>
    %100 = llvm.add %89, %4  : i64
    llvm.br ^bb4(%100 : i64)
  ^bb6:  // pred: ^bb4
    %101 = llvm.add %87, %4  : i64
    llvm.br ^bb3(%101 : i64)
  ^bb7:  // pred: ^bb3
    %102 = llvm.add %85, %4  : i64
    llvm.br ^bb2(%102 : i64)
  ^bb8:  // pred: ^bb2
    %103 = llvm.add %83, %4  : i64
    llvm.br ^bb1(%103 : i64)
  ^bb9(%104: i64):  // 2 preds: ^bb1, ^bb16
    %105 = llvm.icmp "slt" %104, %3 : i64
    llvm.cond_br %105, ^bb10(%2 : i64), ^bb17(%2 : i64)
  ^bb10(%106: i64):  // 2 preds: ^bb9, ^bb15
    %107 = llvm.icmp "slt" %106, %3 : i64
    llvm.cond_br %107, ^bb11(%2 : i64), ^bb16
  ^bb11(%108: i64):  // 2 preds: ^bb10, ^bb14
    %109 = llvm.icmp "slt" %108, %4 : i64
    llvm.cond_br %109, ^bb12(%2 : i64), ^bb15
  ^bb12(%110: i64):  // 2 preds: ^bb11, ^bb13
    %111 = llvm.icmp "slt" %110, %4 : i64
    llvm.cond_br %111, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %112 = llvm.add %108, %104  : i64
    %113 = builtin.unrealized_conversion_cast %112 : i64 to index
    %114 = builtin.unrealized_conversion_cast %113 : index to i64
    %115 = llvm.add %110, %106  : i64
    %116 = builtin.unrealized_conversion_cast %115 : i64 to index
    %117 = builtin.unrealized_conversion_cast %116 : index to i64
    %118 = llvm.mul %114, %6  : i64
    %119 = llvm.add %118, %117  : i64
    %120 = llvm.getelementptr %26[%119] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %5, %120 : !llvm.ptr<f32>
    %121 = llvm.add %110, %4  : i64
    llvm.br ^bb12(%121 : i64)
  ^bb14:  // pred: ^bb12
    %122 = llvm.add %108, %4  : i64
    llvm.br ^bb11(%122 : i64)
  ^bb15:  // pred: ^bb11
    %123 = llvm.add %106, %4  : i64
    llvm.br ^bb10(%123 : i64)
  ^bb16:  // pred: ^bb10
    %124 = llvm.add %104, %4  : i64
    llvm.br ^bb9(%124 : i64)
  ^bb17(%125: i64):  // 2 preds: ^bb9, ^bb24
    %126 = llvm.icmp "slt" %125, %3 : i64
    llvm.cond_br %126, ^bb18(%2 : i64), ^bb25
  ^bb18(%127: i64):  // 2 preds: ^bb17, ^bb23
    %128 = llvm.icmp "slt" %127, %3 : i64
    llvm.cond_br %128, ^bb19(%2 : i64), ^bb24
  ^bb19(%129: i64):  // 2 preds: ^bb18, ^bb22
    %130 = llvm.icmp "slt" %129, %4 : i64
    llvm.cond_br %130, ^bb20(%2 : i64), ^bb23
  ^bb20(%131: i64):  // 2 preds: ^bb19, ^bb21
    %132 = llvm.icmp "slt" %131, %4 : i64
    llvm.cond_br %132, ^bb21, ^bb22
  ^bb21:  // pred: ^bb20
    %133 = llvm.add %129, %125  : i64
    %134 = builtin.unrealized_conversion_cast %133 : i64 to index
    %135 = builtin.unrealized_conversion_cast %134 : index to i64
    %136 = llvm.add %131, %127  : i64
    %137 = builtin.unrealized_conversion_cast %136 : i64 to index
    %138 = builtin.unrealized_conversion_cast %137 : index to i64
    %139 = llvm.mul %135, %6  : i64
    %140 = llvm.add %139, %138  : i64
    %141 = llvm.getelementptr %40[%140] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %5, %141 : !llvm.ptr<f32>
    %142 = llvm.add %131, %4  : i64
    llvm.br ^bb20(%142 : i64)
  ^bb22:  // pred: ^bb20
    %143 = llvm.add %129, %4  : i64
    llvm.br ^bb19(%143 : i64)
  ^bb23:  // pred: ^bb19
    %144 = llvm.add %127, %4  : i64
    llvm.br ^bb18(%144 : i64)
  ^bb24:  // pred: ^bb18
    %145 = llvm.add %125, %4  : i64
    llvm.br ^bb17(%145 : i64)
  ^bb25:  // pred: ^bb17
    %146 = llvm.extractvalue %20[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %147 = llvm.extractvalue %20[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %148 = llvm.extractvalue %20[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %149 = llvm.extractvalue %20[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %150 = llvm.extractvalue %20[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %151 = llvm.extractvalue %20[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %152 = llvm.extractvalue %20[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %153 = llvm.extractvalue %34[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %154 = llvm.extractvalue %34[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %155 = llvm.extractvalue %34[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %156 = llvm.extractvalue %34[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %157 = llvm.extractvalue %34[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %158 = llvm.extractvalue %34[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %159 = llvm.extractvalue %34[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %160 = llvm.extractvalue %48[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %161 = llvm.extractvalue %48[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %162 = llvm.extractvalue %48[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %163 = llvm.extractvalue %48[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %164 = llvm.extractvalue %48[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %165 = llvm.extractvalue %48[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %166 = llvm.extractvalue %48[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @matmul_linalg(%146, %147, %148, %149, %150, %151, %152, %153, %154, %155, %156, %157, %158, %159, %160, %161, %162, %163, %164, %165, %166) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) -> ()
    llvm.return
  }
  llvm.func @mgpuMemHostRegisterMemRef(i64, !llvm.ptr<i8>, i64)
}

