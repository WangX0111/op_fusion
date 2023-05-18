add_mlir_library(CatherineFusion
        fusion_utils.cpp
        fusion_xla.cpp
        fusion.cpp
  
  DEPENDS
  OMONNXOps
  OMONNXRewrite
  MLIRHLSIncGen
  CatherineTransformsIncGen

  LINK_LIBS PUBLIC
  MLIRSupport
  MLIRCatherineUtils
  )

# add_mlir_library(KateTransforms
#   ${globbed}

#   # MatmulOpt.cpp

#   ADDITIONAL_HEADER_DIRS
#   ${MLIR_MAIN_INCLUDE_DIR}/mlir/Transforms

#   DEPENDS
#   KatePassesIncGen

#   LINK_LIBS PUBLIC
# #   MLIRAffine
#   MLIRAnalysis
#   MLIRCopyOpInterface
#   MLIRLoopLikeInterface
# #   MLIRMemRef
# #   MLIRSCF
#   MLIRPass
#   MLIRSupport
#   MLIRTransformUtils
# #   MLIRVector
#   )
