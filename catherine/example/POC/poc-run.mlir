module attributes {llvm.data_layout = ""} {
  llvm.func @printNewline()
  llvm.func @printF64(f64)
  llvm.func @free(!llvm.ptr<i8>)
  llvm.func @malloc(i64) -> !llvm.ptr<i8>
  llvm.func @printMemrefF32(i64, !llvm.ptr<i8>) attributes {sym_visibility = "private"}
  llvm.func @matmul(%arg0: !llvm.ptr<f32>, %arg1: !llvm.ptr<f32>, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr<f32>, %arg8: !llvm.ptr<f32>, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> {
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
    %16 = llvm.mlir.constant(0 : index) : i64
    %17 = llvm.mlir.constant(1 : index) : i64
    %18 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %19 = llvm.mlir.constant(1 : index) : i64
    %20 = llvm.mlir.constant(0 : index) : i64
    %21 = llvm.extractvalue %7[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.extractvalue %15[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.mul %22, %21  : i64
    %24 = llvm.mlir.null : !llvm.ptr<f32>
    %25 = llvm.getelementptr %24[%23] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %26 = llvm.ptrtoint %25 : !llvm.ptr<f32> to i64
    %27 = llvm.call @malloc(%26) : (i64) -> !llvm.ptr<i8>
    %28 = llvm.bitcast %27 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %29 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %30 = llvm.insertvalue %28, %29[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %31 = llvm.insertvalue %28, %30[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %32 = llvm.insertvalue %16, %31[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.insertvalue %21, %32[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %34 = llvm.insertvalue %22, %33[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.insertvalue %22, %34[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %36 = llvm.insertvalue %17, %35[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%20 : i64)
  ^bb1(%37: i64):  // 2 preds: ^bb0, ^bb5
    %38 = llvm.icmp "slt" %37, %21 : i64
    llvm.cond_br %38, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%20 : i64)
  ^bb3(%39: i64):  // 2 preds: ^bb2, ^bb4
    %40 = llvm.icmp "slt" %39, %22 : i64
    llvm.cond_br %40, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %41 = llvm.mul %37, %22  : i64
    %42 = llvm.add %41, %39  : i64
    %43 = llvm.getelementptr %28[%42] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %18, %43 : !llvm.ptr<f32>
    %44 = llvm.add %39, %19  : i64
    llvm.br ^bb3(%44 : i64)
  ^bb5:  // pred: ^bb3
    %45 = llvm.add %37, %19  : i64
    llvm.br ^bb1(%45 : i64)
  ^bb6:  // pred: ^bb1
    %46 = llvm.extractvalue %7[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %47 = llvm.extractvalue %7[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.extractvalue %15[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb7(%20 : i64)
  ^bb7(%49: i64):  // 2 preds: ^bb6, ^bb14
    %50 = llvm.icmp "slt" %49, %46 : i64
    llvm.cond_br %50, ^bb8, ^bb15
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%20 : i64)
  ^bb9(%51: i64):  // 2 preds: ^bb8, ^bb13
    %52 = llvm.icmp "slt" %51, %48 : i64
    llvm.cond_br %52, ^bb10, ^bb14
  ^bb10:  // pred: ^bb9
    llvm.br ^bb11(%20 : i64)
  ^bb11(%53: i64):  // 2 preds: ^bb10, ^bb12
    %54 = llvm.icmp "slt" %53, %47 : i64
    llvm.cond_br %54, ^bb12, ^bb13
  ^bb12:  // pred: ^bb11
    %55 = llvm.extractvalue %7[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %56 = llvm.extractvalue %7[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %57 = llvm.mul %49, %56  : i64
    %58 = llvm.add %57, %53  : i64
    %59 = llvm.getelementptr %55[%58] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %60 = llvm.load %59 : !llvm.ptr<f32>
    %61 = llvm.extractvalue %15[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %62 = llvm.extractvalue %15[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %63 = llvm.mul %53, %62  : i64
    %64 = llvm.add %63, %51  : i64
    %65 = llvm.getelementptr %61[%64] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %66 = llvm.load %65 : !llvm.ptr<f32>
    %67 = llvm.mul %49, %22  : i64
    %68 = llvm.add %67, %51  : i64
    %69 = llvm.getelementptr %28[%68] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %70 = llvm.load %69 : !llvm.ptr<f32>
    %71 = llvm.fmul %60, %66  : f32
    %72 = llvm.fadd %70, %71  : f32
    %73 = llvm.mul %49, %22  : i64
    %74 = llvm.add %73, %51  : i64
    %75 = llvm.getelementptr %28[%74] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %72, %75 : !llvm.ptr<f32>
    %76 = llvm.add %53, %19  : i64
    llvm.br ^bb11(%76 : i64)
  ^bb13:  // pred: ^bb11
    %77 = llvm.add %51, %19  : i64
    llvm.br ^bb9(%77 : i64)
  ^bb14:  // pred: ^bb9
    %78 = llvm.add %49, %19  : i64
    llvm.br ^bb7(%78 : i64)
  ^bb15:  // pred: ^bb7
    llvm.return %36 : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
  }
  llvm.func @should_not_fuse_graph_node() {
    llvm.return
  }
  llvm.func @should_not_fuse_op() {
    llvm.return
  }
  llvm.func @main() {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(1.700000e+01 : f32) : f32
    %3 = llvm.mlir.constant(1.300000e+01 : f32) : f32
    %4 = llvm.mlir.constant(300 : index) : i64
    %5 = llvm.mlir.constant(400 : index) : i64
    %6 = llvm.mlir.constant(500 : index) : i64
    %7 = llvm.mlir.constant(1000 : index) : i64
    %8 = llvm.mlir.constant(7.168000e+03 : f64) : f64
    %9 = llvm.mlir.constant(1 : index) : i64
    %10 = llvm.mlir.constant(0 : index) : i64
    %11 = llvm.mul %6, %7  : i64
    %12 = llvm.mlir.null : !llvm.ptr<f32>
    %13 = llvm.getelementptr %12[%11] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %14 = llvm.ptrtoint %13 : !llvm.ptr<f32> to i64
    %15 = llvm.call @malloc(%14) : (i64) -> !llvm.ptr<i8>
    %16 = llvm.bitcast %15 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %17 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %18 = llvm.insertvalue %16, %17[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %19 = llvm.insertvalue %16, %18[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %0, %19[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.insertvalue %7, %20[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %22 = llvm.insertvalue %6, %21[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %6, %22[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.insertvalue %1, %23[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.mul %5, %6  : i64
    %26 = llvm.mlir.null : !llvm.ptr<f32>
    %27 = llvm.getelementptr %26[%25] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %28 = llvm.ptrtoint %27 : !llvm.ptr<f32> to i64
    %29 = llvm.call @malloc(%28) : (i64) -> !llvm.ptr<i8>
    %30 = llvm.bitcast %29 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %31 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %32 = llvm.insertvalue %30, %31[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.insertvalue %30, %32[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %34 = llvm.insertvalue %0, %33[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %35 = llvm.insertvalue %6, %34[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %36 = llvm.insertvalue %5, %35[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %37 = llvm.insertvalue %5, %36[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %38 = llvm.insertvalue %1, %37[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.mul %4, %5  : i64
    %40 = llvm.mlir.null : !llvm.ptr<f32>
    %41 = llvm.getelementptr %40[%39] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    %42 = llvm.ptrtoint %41 : !llvm.ptr<f32> to i64
    %43 = llvm.call @malloc(%42) : (i64) -> !llvm.ptr<i8>
    %44 = llvm.bitcast %43 : !llvm.ptr<i8> to !llvm.ptr<f32>
    %45 = llvm.mlir.undef : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %46 = llvm.insertvalue %44, %45[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %47 = llvm.insertvalue %44, %46[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.insertvalue %0, %47[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %49 = llvm.insertvalue %5, %48[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %50 = llvm.insertvalue %4, %49[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %51 = llvm.insertvalue %4, %50[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %52 = llvm.insertvalue %1, %51[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%10 : i64)
  ^bb1(%53: i64):  // 2 preds: ^bb0, ^bb5
    %54 = llvm.icmp "slt" %53, %7 : i64
    llvm.cond_br %54, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%10 : i64)
  ^bb3(%55: i64):  // 2 preds: ^bb2, ^bb4
    %56 = llvm.icmp "slt" %55, %6 : i64
    llvm.cond_br %56, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %57 = llvm.mul %53, %6  : i64
    %58 = llvm.add %57, %55  : i64
    %59 = llvm.getelementptr %16[%58] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %3, %59 : !llvm.ptr<f32>
    %60 = llvm.add %55, %9  : i64
    llvm.br ^bb3(%60 : i64)
  ^bb5:  // pred: ^bb3
    %61 = llvm.add %53, %9  : i64
    llvm.br ^bb1(%61 : i64)
  ^bb6:  // pred: ^bb1
    llvm.br ^bb7(%10 : i64)
  ^bb7(%62: i64):  // 2 preds: ^bb6, ^bb11
    %63 = llvm.icmp "slt" %62, %6 : i64
    llvm.cond_br %63, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%10 : i64)
  ^bb9(%64: i64):  // 2 preds: ^bb8, ^bb10
    %65 = llvm.icmp "slt" %64, %5 : i64
    llvm.cond_br %65, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %66 = llvm.mul %62, %5  : i64
    %67 = llvm.add %66, %64  : i64
    %68 = llvm.getelementptr %30[%67] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %3, %68 : !llvm.ptr<f32>
    %69 = llvm.add %64, %9  : i64
    llvm.br ^bb9(%69 : i64)
  ^bb11:  // pred: ^bb9
    %70 = llvm.add %62, %9  : i64
    llvm.br ^bb7(%70 : i64)
  ^bb12:  // pred: ^bb7
    llvm.br ^bb13(%10 : i64)
  ^bb13(%71: i64):  // 2 preds: ^bb12, ^bb17
    %72 = llvm.icmp "slt" %71, %5 : i64
    llvm.cond_br %72, ^bb14, ^bb18
  ^bb14:  // pred: ^bb13
    llvm.br ^bb15(%10 : i64)
  ^bb15(%73: i64):  // 2 preds: ^bb14, ^bb16
    %74 = llvm.icmp "slt" %73, %4 : i64
    llvm.cond_br %74, ^bb16, ^bb17
  ^bb16:  // pred: ^bb15
    %75 = llvm.mul %71, %4  : i64
    %76 = llvm.add %75, %73  : i64
    %77 = llvm.getelementptr %44[%76] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %2, %77 : !llvm.ptr<f32>
    %78 = llvm.add %73, %9  : i64
    llvm.br ^bb15(%78 : i64)
  ^bb17:  // pred: ^bb15
    %79 = llvm.add %71, %9  : i64
    llvm.br ^bb13(%79 : i64)
  ^bb18:  // pred: ^bb13
    %80 = llvm.mul %10, %5  : i64
    %81 = llvm.add %80, %10  : i64
    %82 = llvm.getelementptr %30[%81] : (!llvm.ptr<f32>, i64) -> !llvm.ptr<f32>
    llvm.store %3, %82 : !llvm.ptr<f32>
    %83 = llvm.call @rtclock() : () -> f64
    %84 = llvm.call @matmul(%16, %16, %0, %7, %6, %6, %1, %30, %30, %0, %6, %5, %5, %1) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %85 = llvm.extractvalue %84[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %86 = llvm.extractvalue %84[1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %87 = llvm.extractvalue %84[2] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %88 = llvm.extractvalue %84[3, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %89 = llvm.extractvalue %84[3, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %90 = llvm.extractvalue %84[4, 0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %91 = llvm.extractvalue %84[4, 1] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %92 = llvm.call @matmul(%85, %86, %87, %88, %89, %90, %91, %44, %44, %0, %5, %4, %4, %1) : (!llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64, !llvm.ptr<f32>, !llvm.ptr<f32>, i64, i64, i64, i64, i64) -> !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)>
    %93 = llvm.call @rtclock() : () -> f64
    %94 = llvm.fsub %93, %83  : f64
    llvm.call @printF64(%94) : (f64) -> ()
    llvm.call @printNewline() : () -> ()
    %95 = llvm.fdiv %8, %94  : f64
    llvm.call @printFlops(%95) : (f64) -> ()
    llvm.call @free(%15) : (!llvm.ptr<i8>) -> ()
    llvm.call @free(%29) : (!llvm.ptr<i8>) -> ()
    llvm.call @free(%43) : (!llvm.ptr<i8>) -> ()
    %96 = llvm.extractvalue %84[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %97 = llvm.bitcast %96 : !llvm.ptr<f32> to !llvm.ptr<i8>
    llvm.call @free(%97) : (!llvm.ptr<i8>) -> ()
    %98 = llvm.extractvalue %92[0] : !llvm.struct<(ptr<f32>, ptr<f32>, i64, array<2 x i64>, array<2 x i64>)> 
    %99 = llvm.bitcast %98 : !llvm.ptr<f32> to !llvm.ptr<i8>
    llvm.call @free(%99) : (!llvm.ptr<i8>) -> ()
    llvm.return
  }
  llvm.func @printFlops(f64) attributes {sym_visibility = "private"}
  llvm.func @rtclock() -> f64 attributes {sym_visibility = "private"}
}

