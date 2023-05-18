set(LLVM_TARGET_DEFINITIONS RewriteAnalyze.td)
mlir_tablegen(RewriteAnalyze.hpp.inc -gen-rewriters -name RewriteAnalyze)
add_public_tablegen_target(RewriteAnalyze)

add_mlir_library(CatherineONNXAnalyze
        RewriteAnalyze.cpp
  
  DEPENDS
  OMONNXOps
  OMONNXRewrite
  )
