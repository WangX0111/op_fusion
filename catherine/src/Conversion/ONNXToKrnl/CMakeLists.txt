add_mlir_library(KateONNXToKrnl
  ONNXToKrnlLowering.cpp
  
  DEPENDS
  MLIRAffineTransforms
  )
