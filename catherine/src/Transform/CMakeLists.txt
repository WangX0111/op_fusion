# add_subdirectory(Utils)

add_mlir_library(KateTransforms
  MatmulOpt.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Transforms

  DEPENDS
  # KatePassesIncGen


  LINK_LIBS PUBLIC
#   MLIRAffine
  MLIRAnalysis
  MLIRCopyOpInterface
  MLIRLoopLikeInterface
#   MLIRMemRef
#   MLIRSCF
  MLIRPass
  MLIRSupport
  MLIRTransformUtils
#   MLIRVector
  )
