# # add_subdirectory(Utils)

# add_mlir_library(KateOptimizeMatmul
#   OptimizeMatmul.cpp

#   ADDITIONAL_HEADER_DIRS
#   ${MLIR_MAIN_INCLUDE_DIR}/mlir/Transforms

#   DEPENDS
#   MLIRStandardOpsIncGen
#   MLIRTransformsPassIncGen

#   LINK_LIBS PUBLIC
#   MLIRAffine
#   MLIRAnalysis
#   MLIRCopyOpInterface
#   MLIRLoopLikeInterface
#   MLIRMemRef
#   MLIRSCF
#   MLIRPass
#   MLIRSupport
#   MLIRTransformUtils
#   MLIRVector
#   )
