module {
  llvm.func @malloc(i64) -> !llvm.ptr<i8>
  llvm.func @printMemrefF32(i64, !llvm.ptr<i8>) attributes {sym_visibility = "private"}
  llvm.func @matmul_linalg(%arg0: !llvm.ptr<f32>, %arg1: !llvm.ptr<f32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr<f32>, %arg8: !llvm.ptr<f32>, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr<f32>, %arg15: !llvm.ptr<f32>, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64) {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.insertvalue %arg5, %4[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.insertvalue %arg6, %6[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %8 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %9 = llvm.insertvalue %arg7, %8[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %10 = llvm.insertvalue %arg8, %9[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.insertvalue %arg9, %10[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %12 = llvm.insertvalue %arg10, %11[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.insertvalue %arg12, %12[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %14 = llvm.insertvalue %arg11, %13[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %arg13, %14[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %17 = llvm.insertvalue %arg14, %16[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.insertvalue %arg15, %17[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %arg16, %18[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %arg17, %19[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %arg19, %20[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %arg18, %21[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %arg20, %22[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.mlir.constant(0 : index) : i64
    %25 = llvm.mlir.constant(8 : index) : i64
    %26 = llvm.mlir.constant(1 : index) : i64
    llvm.br ^bb1(%24 : i64)
  ^bb1(%27: i64):  // 2 preds: ^bb0, ^bb8
    %28 = llvm.icmp "slt" %27, %25 : i64
    llvm.cond_br %28, ^bb2, ^bb9
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%24 : i64)
  ^bb3(%29: i64):  // 2 preds: ^bb2, ^bb7
    %30 = llvm.icmp "slt" %29, %25 : i64
    llvm.cond_br %30, ^bb4, ^bb8
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%24 : i64)
  ^bb5(%31: i64):  // 2 preds: ^bb4, ^bb6
    %32 = llvm.icmp "slt" %31, %25 : i64
    llvm.cond_br %32, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %33 = llvm.mlir.constant(8 : index) : i64
    %34 = llvm.mul %27, %33  : i64
    %35 = llvm.add %34, %31  : i64
    %36 = llvm.getelementptr %arg1[%35] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %37 = llvm.load %36 : !llvm.ptr<f32>
    %38 = llvm.mlir.constant(8 : index) : i64
    %39 = llvm.mul %31, %38  : i64
    %40 = llvm.add %39, %29  : i64
    %41 = llvm.getelementptr %arg8[%40] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %42 = llvm.load %41 : !llvm.ptr<f32>
    %43 = llvm.mlir.constant(8 : index) : i64
    %44 = llvm.mul %27, %43  : i64
    %45 = llvm.add %44, %29  : i64
    %46 = llvm.getelementptr %arg15[%45] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %47 = llvm.load %46 : !llvm.ptr<f32>
    %48 = llvm.fmul %37, %42  : f32
    %49 = llvm.fadd %47, %48  : f32
    %50 = llvm.mlir.constant(8 : index) : i64
    %51 = llvm.mul %27, %50  : i64
    %52 = llvm.add %51, %29  : i64
    %53 = llvm.getelementptr %arg15[%52] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %49, %53 : !llvm.ptr<f32>
    %54 = llvm.add %31, %26  : i64
    llvm.br ^bb5(%54 : i64)
  ^bb7:  // pred: ^bb5
    %55 = llvm.add %29, %26  : i64
    llvm.br ^bb3(%55 : i64)
  ^bb8:  // pred: ^bb3
    %56 = llvm.add %27, %26  : i64
    llvm.br ^bb1(%56 : i64)
  ^bb9:  // pred: ^bb1
    llvm.return
  }
  llvm.func @main() {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(8 : index) : i64
    %2 = llvm.mlir.constant(1 : index) : i64
    %3 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %4 = llvm.mlir.constant(8 : index) : i64
    %5 = llvm.mlir.constant(8 : index) : i64
    %6 = llvm.mlir.constant(1 : index) : i64
    %7 = llvm.mlir.constant(64 : index) : i64
    %8 = llvm.mlir.null : !llvm.ptr<f32>
    %9 = llvm.getelementptr %8[64] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %10 = llvm.ptrtoint %9 : !llvm.ptr<f32> to i64
    %11 = llvm.call @malloc(%10) : (i64) -> !llvm.ptr<i8>
    %12 = llvm.bitcast %11 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %13 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %14 = llvm.insertvalue %12, %13[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %15 = llvm.insertvalue %12, %14[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %16 = llvm.mlir.constant(0 : index) : i64
    %17 = llvm.insertvalue %16, %15[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %18 = llvm.insertvalue %4, %17[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %5, %18[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %5, %19[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %6, %20[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.mlir.constant(8 : index) : i64
    %23 = llvm.mlir.constant(8 : index) : i64
    %24 = llvm.mlir.constant(1 : index) : i64
    %25 = llvm.mlir.constant(64 : index) : i64
    %26 = llvm.mlir.null : !llvm.ptr<f32>
    %27 = llvm.getelementptr %26[64] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %28 = llvm.ptrtoint %27 : !llvm.ptr<f32> to i64
    %29 = llvm.call @malloc(%28) : (i64) -> !llvm.ptr<i8>
    %30 = llvm.bitcast %29 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %31 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %32 = llvm.insertvalue %30, %31[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.insertvalue %30, %32[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %34 = llvm.mlir.constant(0 : index) : i64
    %35 = llvm.insertvalue %34, %33[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %36 = llvm.insertvalue %22, %35[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.insertvalue %23, %36[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %38 = llvm.insertvalue %23, %37[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.insertvalue %24, %38[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.mlir.constant(8 : index) : i64
    %41 = llvm.mlir.constant(8 : index) : i64
    %42 = llvm.mlir.constant(1 : index) : i64
    %43 = llvm.mlir.constant(64 : index) : i64
    %44 = llvm.mlir.null : !llvm.ptr<f32>
    %45 = llvm.getelementptr %44[64] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %46 = llvm.ptrtoint %45 : !llvm.ptr<f32> to i64
    %47 = llvm.call @malloc(%46) : (i64) -> !llvm.ptr<i8>
    %48 = llvm.bitcast %47 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %49 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %50 = llvm.insertvalue %48, %49[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %51 = llvm.insertvalue %48, %50[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %52 = llvm.mlir.constant(0 : index) : i64
    %53 = llvm.insertvalue %52, %51[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %54 = llvm.insertvalue %40, %53[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %55 = llvm.insertvalue %41, %54[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %56 = llvm.insertvalue %41, %55[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %57 = llvm.insertvalue %42, %56[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %58 = llvm.mlir.constant(1 : index) : i64
    %59 = llvm.alloca %58 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %21, %59 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %60 = llvm.bitcast %59 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %61 = llvm.mlir.constant(2 : index) : i64
    %62 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %63 = llvm.insertvalue %61, %62[0] : !llvm.struct<(i64, ptr<i8>)> 
    %64 = llvm.insertvalue %60, %63[1] : !llvm.struct<(i64, ptr<i8>)> 
    %65 = llvm.mlir.constant(1 : index) : i64
    %66 = llvm.alloca %65 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %39, %66 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %67 = llvm.bitcast %66 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %68 = llvm.mlir.constant(2 : index) : i64
    %69 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %70 = llvm.insertvalue %68, %69[0] : !llvm.struct<(i64, ptr<i8>)> 
    %71 = llvm.insertvalue %67, %70[1] : !llvm.struct<(i64, ptr<i8>)> 
    %72 = llvm.mlir.constant(1 : index) : i64
    %73 = llvm.alloca %72 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %57, %73 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %74 = llvm.bitcast %73 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %75 = llvm.mlir.constant(2 : index) : i64
    %76 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %77 = llvm.insertvalue %75, %76[0] : !llvm.struct<(i64, ptr<i8>)> 
    %78 = llvm.insertvalue %74, %77[1] : !llvm.struct<(i64, ptr<i8>)> 
    %79 = llvm.mlir.null : !llvm.ptr<f32>
    %80 = llvm.getelementptr %79[1] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %81 = llvm.ptrtoint %80 : !llvm.ptr<f32> to i64
    llvm.call @mgpuMemHostRegisterMemRef(%61, %60, %81) : (i64, !llvm.ptr<i8>, i64) -> ()
    %82 = llvm.mlir.null : !llvm.ptr<f32>
    %83 = llvm.getelementptr %82[1] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %84 = llvm.ptrtoint %83 : !llvm.ptr<f32> to i64
    llvm.call @mgpuMemHostRegisterMemRef(%68, %67, %84) : (i64, !llvm.ptr<i8>, i64) -> ()
    %85 = llvm.mlir.null : !llvm.ptr<f32>
    %86 = llvm.getelementptr %85[1] : (!llvm.ptr<f32>) -> !llvm.ptr<f32>
    %87 = llvm.ptrtoint %86 : !llvm.ptr<f32> to i64
    llvm.call @mgpuMemHostRegisterMemRef(%75, %74, %87) : (i64, !llvm.ptr<i8>, i64) -> ()
    llvm.br ^bb1(%0 : i64)
  ^bb1(%88: i64):  // 2 preds: ^bb0, ^bb5
    %89 = llvm.icmp "slt" %88, %1 : i64
    llvm.cond_br %89, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%0 : i64)
  ^bb3(%90: i64):  // 2 preds: ^bb2, ^bb4
    %91 = llvm.icmp "slt" %90, %1 : i64
    llvm.cond_br %91, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %92 = llvm.mlir.constant(8 : index) : i64
    %93 = llvm.mul %88, %92  : i64
    %94 = llvm.add %93, %90  : i64
    %95 = llvm.getelementptr %12[%94] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %3, %95 : !llvm.ptr<f32>
    %96 = llvm.add %90, %2  : i64
    llvm.br ^bb3(%96 : i64)
  ^bb5:  // pred: ^bb3
    %97 = llvm.add %88, %2  : i64
    llvm.br ^bb1(%97 : i64)
  ^bb6:  // pred: ^bb1
    llvm.br ^bb7(%0 : i64)
  ^bb7(%98: i64):  // 2 preds: ^bb6, ^bb11
    %99 = llvm.icmp "slt" %98, %1 : i64
    llvm.cond_br %99, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%0 : i64)
  ^bb9(%100: i64):  // 2 preds: ^bb8, ^bb10
    %101 = llvm.icmp "slt" %100, %1 : i64
    llvm.cond_br %101, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %102 = llvm.mlir.constant(8 : index) : i64
    %103 = llvm.mul %98, %102  : i64
    %104 = llvm.add %103, %100  : i64
    %105 = llvm.getelementptr %30[%104] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %3, %105 : !llvm.ptr<f32>
    %106 = llvm.add %100, %2  : i64
    llvm.br ^bb9(%106 : i64)
  ^bb11:  // pred: ^bb9
    %107 = llvm.add %98, %2  : i64
    llvm.br ^bb7(%107 : i64)
  ^bb12:  // pred: ^bb7
    llvm.br ^bb13(%0 : i64)
  ^bb13(%108: i64):  // 2 preds: ^bb12, ^bb17
    %109 = llvm.icmp "slt" %108, %1 : i64
    llvm.cond_br %109, ^bb14, ^bb18
  ^bb14:  // pred: ^bb13
    llvm.br ^bb15(%0 : i64)
  ^bb15(%110: i64):  // 2 preds: ^bb14, ^bb16
    %111 = llvm.icmp "slt" %110, %1 : i64
    llvm.cond_br %111, ^bb16, ^bb17
  ^bb16:  // pred: ^bb15
    %112 = llvm.mlir.constant(8 : index) : i64
    %113 = llvm.mul %108, %112  : i64
    %114 = llvm.add %113, %110  : i64
    %115 = llvm.getelementptr %48[%114] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %3, %115 : !llvm.ptr<f32>
    %116 = llvm.add %110, %2  : i64
    llvm.br ^bb15(%116 : i64)
  ^bb17:  // pred: ^bb15
    %117 = llvm.add %108, %2  : i64
    llvm.br ^bb13(%117 : i64)
  ^bb18:  // pred: ^bb13
    llvm.call @matmul_linalg(%12, %12, %16, %4, %5, %5, %6, %30, %30, %34, %22, %23, %23, %24, %48, %48, %52, %40, %41, %41, %42) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) -> ()
    %118 = llvm.mlir.constant(1 : index) : i64
    %119 = llvm.alloca %118 x !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> : (i64) -> !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    llvm.store %57, %119 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>>
    %120 = llvm.bitcast %119 : !llvm.ptr<struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>> to !llvm.ptr<i8>
    %121 = llvm.mlir.constant(2 : index) : i64
    %122 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %123 = llvm.insertvalue %121, %122[0] : !llvm.struct<(i64, ptr<i8>)> 
    %124 = llvm.insertvalue %120, %123[1] : !llvm.struct<(i64, ptr<i8>)> 
    llvm.call @printMemrefF32(%121, %120) : (i64, !llvm.ptr<i8>) -> ()
    llvm.return
  }
  llvm.func @mgpuMemHostRegisterMemRef(i64, !llvm.ptr<i8>, i64)
}

