; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

declare void @free(ptr)

declare void @printU64(i64)

declare void @printNewline()

declare void @printF64(double)

declare void @printMemrefF32(i64, ptr)

define void @matmul(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, i64 %12, i64 %13, ptr %14, ptr %15, i64 %16, i64 %17, i64 %18, i64 %19, i64 %20) {
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %0, 0
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, ptr %1, 1
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, i64 %2, 2
  %25 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %24, i64 %3, 3, 0
  %26 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %25, i64 %5, 4, 0
  %27 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %26, i64 %4, 3, 1
  %28 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %27, i64 %6, 4, 1
  %29 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %7, 0
  %30 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %29, ptr %8, 1
  %31 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %30, i64 %9, 2
  %32 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %31, i64 %10, 3, 0
  %33 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %32, i64 %12, 4, 0
  %34 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %33, i64 %11, 3, 1
  %35 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %34, i64 %13, 4, 1
  %36 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %14, 0
  %37 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %36, ptr %15, 1
  %38 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %37, i64 %16, 2
  %39 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %38, i64 %17, 3, 0
  %40 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %39, i64 %19, 4, 0
  %41 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %40, i64 %18, 3, 1
  %42 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %41, i64 %20, 4, 1
  br label %43

43:                                               ; preds = %132, %21
  %44 = phi i64 [ %133, %132 ], [ 0, %21 ]
  %45 = icmp slt i64 %44, 8192
  br i1 %45, label %46, label %134

46:                                               ; preds = %43
  br label %47

47:                                               ; preds = %130, %46
  %48 = phi i64 [ %131, %130 ], [ 0, %46 ]
  %49 = icmp slt i64 %48, 8192
  br i1 %49, label %50, label %132

50:                                               ; preds = %47
  br label %51

51:                                               ; preds = %128, %50
  %52 = phi i64 [ %129, %128 ], [ 0, %50 ]
  %53 = icmp slt i64 %52, 8192
  br i1 %53, label %54, label %130

54:                                               ; preds = %51
  br label %55

55:                                               ; preds = %126, %54
  %56 = phi i64 [ %127, %126 ], [ 0, %54 ]
  %57 = icmp slt i64 %56, 8192
  br i1 %57, label %58, label %128

58:                                               ; preds = %55
  br label %59

59:                                               ; preds = %124, %58
  %60 = phi i64 [ %125, %124 ], [ 0, %58 ]
  %61 = icmp slt i64 %60, 8192
  br i1 %61, label %62, label %126

62:                                               ; preds = %59
  br label %63

63:                                               ; preds = %122, %62
  %64 = phi i64 [ %123, %122 ], [ 0, %62 ]
  %65 = icmp slt i64 %64, 8192
  br i1 %65, label %66, label %124

66:                                               ; preds = %63
  br label %67

67:                                               ; preds = %120, %66
  %68 = phi i64 [ %121, %120 ], [ 0, %66 ]
  %69 = icmp slt i64 %68, 64
  br i1 %69, label %70, label %122

70:                                               ; preds = %67
  br label %71

71:                                               ; preds = %118, %70
  %72 = phi i64 [ %119, %118 ], [ 0, %70 ]
  %73 = icmp slt i64 %72, 64
  br i1 %73, label %74, label %120

74:                                               ; preds = %71
  br label %75

75:                                               ; preds = %78, %74
  %76 = phi i64 [ %117, %78 ], [ 0, %74 ]
  %77 = icmp slt i64 %76, 32
  br i1 %77, label %78, label %118

78:                                               ; preds = %75
  %79 = add i64 %44, %56
  %80 = add i64 %79, %68
  %81 = add i64 %52, %64
  %82 = add i64 %81, %76
  %83 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %28, 1
  %84 = mul i64 %80, 8192
  %85 = add i64 %84, %82
  %86 = getelementptr half, ptr %83, i64 %85
  %87 = load half, ptr %86, align 2
  %88 = add i64 %52, %64
  %89 = add i64 %88, %76
  %90 = add i64 %48, %60
  %91 = add i64 %90, %72
  %92 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %35, 1
  %93 = mul i64 %89, 8192
  %94 = add i64 %93, %91
  %95 = getelementptr half, ptr %92, i64 %94
  %96 = load half, ptr %95, align 2
  %97 = add i64 %44, %56
  %98 = add i64 %97, %68
  %99 = add i64 %48, %60
  %100 = add i64 %99, %72
  %101 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %42, 1
  %102 = mul i64 %98, 8192
  %103 = add i64 %102, %100
  %104 = getelementptr float, ptr %101, i64 %103
  %105 = load float, ptr %104, align 4
  %106 = fmul half %87, %96
  %107 = fpext half %106 to float
  %108 = fadd float %105, %107
  %109 = add i64 %44, %56
  %110 = add i64 %109, %68
  %111 = add i64 %48, %60
  %112 = add i64 %111, %72
  %113 = extractvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %42, 1
  %114 = mul i64 %110, 8192
  %115 = add i64 %114, %112
  %116 = getelementptr float, ptr %113, i64 %115
  store float %108, ptr %116, align 4
  %117 = add i64 %76, 1
  br label %75

118:                                              ; preds = %75
  %119 = add i64 %72, 1
  br label %71

120:                                              ; preds = %71
  %121 = add i64 %68, 1
  br label %67

122:                                              ; preds = %67
  %123 = add i64 %64, 32
  br label %63

124:                                              ; preds = %63
  %125 = add i64 %60, 64
  br label %59

126:                                              ; preds = %59
  %127 = add i64 %56, 64
  br label %55

128:                                              ; preds = %55
  %129 = add i64 %52, 64
  br label %51

130:                                              ; preds = %51
  %131 = add i64 %48, 128
  br label %47

132:                                              ; preds = %47
  %133 = add i64 %44, 128
  br label %43

134:                                              ; preds = %43
  ret void
}

define void @main() {
  %1 = call ptr @malloc(i64 ptrtoint (ptr getelementptr (half, ptr null, i32 67108864) to i64))
  %2 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %1, 0
  %3 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %2, ptr %1, 1
  %4 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %3, i64 0, 2
  %5 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %4, i64 8192, 3, 0
  %6 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %5, i64 8192, 3, 1
  %7 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %6, i64 8192, 4, 0
  %8 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %7, i64 1, 4, 1
  %9 = call ptr @malloc(i64 ptrtoint (ptr getelementptr (half, ptr null, i32 67108864) to i64))
  %10 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %9, 0
  %11 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %10, ptr %9, 1
  %12 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %11, i64 0, 2
  %13 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %12, i64 8192, 3, 0
  %14 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %13, i64 8192, 3, 1
  %15 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %14, i64 8192, 4, 0
  %16 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %15, i64 1, 4, 1
  %17 = call ptr @malloc(i64 ptrtoint (ptr getelementptr (float, ptr null, i32 67108864) to i64))
  %18 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } undef, ptr %17, 0
  %19 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %18, ptr %17, 1
  %20 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %19, i64 0, 2
  %21 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %20, i64 8192, 3, 0
  %22 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %21, i64 8192, 3, 1
  %23 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %22, i64 8192, 4, 0
  %24 = insertvalue { ptr, ptr, i64, [2 x i64], [2 x i64] } %23, i64 1, 4, 1
  br label %25

25:                                               ; preds = %37, %0
  %26 = phi i64 [ %38, %37 ], [ 0, %0 ]
  %27 = icmp slt i64 %26, 8192
  br i1 %27, label %28, label %39

28:                                               ; preds = %25
  br label %29

29:                                               ; preds = %32, %28
  %30 = phi i64 [ %36, %32 ], [ 0, %28 ]
  %31 = icmp slt i64 %30, 8192
  br i1 %31, label %32, label %37

32:                                               ; preds = %29
  %33 = mul i64 %26, 8192
  %34 = add i64 %33, %30
  %35 = getelementptr half, ptr %1, i64 %34
  store half 0xH3C00, ptr %35, align 2
  %36 = add i64 %30, 1
  br label %29

37:                                               ; preds = %29
  %38 = add i64 %26, 1
  br label %25

39:                                               ; preds = %25
  br label %40

40:                                               ; preds = %52, %39
  %41 = phi i64 [ %53, %52 ], [ 0, %39 ]
  %42 = icmp slt i64 %41, 8192
  br i1 %42, label %43, label %54

43:                                               ; preds = %40
  br label %44

44:                                               ; preds = %47, %43
  %45 = phi i64 [ %51, %47 ], [ 0, %43 ]
  %46 = icmp slt i64 %45, 8192
  br i1 %46, label %47, label %52

47:                                               ; preds = %44
  %48 = mul i64 %41, 8192
  %49 = add i64 %48, %45
  %50 = getelementptr half, ptr %9, i64 %49
  store half 0xH3C00, ptr %50, align 2
  %51 = add i64 %45, 1
  br label %44

52:                                               ; preds = %44
  %53 = add i64 %41, 1
  br label %40

54:                                               ; preds = %40
  br label %55

55:                                               ; preds = %67, %54
  %56 = phi i64 [ %68, %67 ], [ 0, %54 ]
  %57 = icmp slt i64 %56, 8192
  br i1 %57, label %58, label %69

58:                                               ; preds = %55
  br label %59

59:                                               ; preds = %62, %58
  %60 = phi i64 [ %66, %62 ], [ 0, %58 ]
  %61 = icmp slt i64 %60, 8192
  br i1 %61, label %62, label %67

62:                                               ; preds = %59
  %63 = mul i64 %56, 8192
  %64 = add i64 %63, %60
  %65 = getelementptr float, ptr %17, i64 %64
  store float 1.000000e+00, ptr %65, align 4
  %66 = add i64 %60, 1
  br label %59

67:                                               ; preds = %59
  %68 = add i64 %56, 1
  br label %55

69:                                               ; preds = %55
  %70 = call double @rtclock()
  call void @matmul(ptr %1, ptr %1, i64 0, i64 8192, i64 8192, i64 8192, i64 1, ptr %9, ptr %9, i64 0, i64 8192, i64 8192, i64 8192, i64 1, ptr %17, ptr %17, i64 0, i64 8192, i64 8192, i64 8192, i64 1)
  %71 = call double @rtclock()
  %72 = fsub double %71, %70
  call void @printF64(double %72)
  call void @printNewline()
  call void @printU64(i64 1099511627776)
  call void @printNewline()
  %73 = fdiv double 1.024000e+12, %72
  call void @printF64(double %73)
  call void @printNewline()
  call void @printFlops(double %73)
  call void @free(ptr %1)
  call void @free(ptr %9)
  call void @free(ptr %17)
  ret void
}

declare void @printFlops(double)

declare double @rtclock()

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
