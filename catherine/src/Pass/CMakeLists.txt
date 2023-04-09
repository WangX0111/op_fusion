set(LLVM_TARGET_DEFINITIONS Passes.td)
mlir_tablegen(Passes.h.inc -gen-pass-decls)
add_public_tablegen_target(CatherinePassesIncGen)

# # add_mlir_doc(Passes GeneralPasses ./ -gen-pass-doc)

# # add_llvm_library(Passes
# #     Passes.h
# #     Passes.h.inc
# #     # Set target language
# #     LINKER_LANGUAGE C
# # )

# file(GLOB globbed *.cpp)

add_mlir_dialect_library(CatherinePasses
  # ${globbed}
  Passes.cpp

  DEPENDS
  MLIRHLSIncGen
  CatherinePassesIncGen

  LINK_LIBS PUBLIC
  MLIRPass

  )
