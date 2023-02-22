# set(LLVM_TARGET_DEFINITIONS Passes.td)
# mlir_tablegen(Passes.h.inc -gen-pass-decls -name Passes)
# # mlir_tablegen(Transforms.capi.h.inc -gen-pass-capi-header --prefix Transforms)
# # mlir_tablegen(Transforms.capi.cpp.inc -gen-pass-capi-impl --prefix Transforms)
# add_public_tablegen_target(KatePassesIncGen)

# # add_mlir_doc(Passes GeneralPasses ./ -gen-pass-doc)

# # add_llvm_library(Passes
# #     Passes.h
# #     Passes.h.inc
# #     # Set target language
# #     LINKER_LANGUAGE C
# # )
