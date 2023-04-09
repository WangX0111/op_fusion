# add_subdirectory(Utils)
# file(GLOB globbed *.cpp)
set(LLVM_TARGET_DEFINITIONS Passes.td)
mlir_tablegen(Passes.h.inc -gen-pass-decls)
add_public_tablegen_target(CatherineTransformsIncGen)


add_mlir_library(CatherineTransforms

  Estimator.cpp
  Passes.cpp

  DEPENDS
  CatherineTransformsIncGen

  LINK_LIBS PUBLIC
  CatherineHLS

#   LINK_LIBS PUBLIC
#   # MLIRAffine
#   MLIRAnalysis
#   MLIRCopyOpInterface
#   MLIRLoopLikeInterface
# #   MLIRMemRef
# #   MLIRSCF
#   MLIRPass
#   MLIRSupport
#   MLIRTransformUtils
#   MLIRVector
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
