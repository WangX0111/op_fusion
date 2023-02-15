# set(LLVM_TARGET_DEFINITIONS BlisOps.td)
# mlir_tablegen(BlisOpsEnums.h.inc -gen-enum-decls)
# mlir_tablegen(BlisOpsEnums.cpp.inc -gen-enum-defs)

# set(LLVM_TARGET_DEFINITIONS BlisOps.td)
# mlir_tablegen(BlisOpsAttributes.h.inc -gen-attrdef-decls)
# mlir_tablegen(BlisOpsAttributes.cpp.inc -gen-attrdef-defs)

add_mlir_dialect(BlisOps blis)
# add_mlir_doc(BlisDialect -gen-dialect-doc BlisDialect Blis/)
# add_mlir_doc(BlisOps -gen-op-doc BlisOps Blis/)

add_mlir_dialect_library(MLIRBlis
    BlisDialect.cpp
    BlisOps.cpp

   

    DEPENDS
    MLIRBlisOpsIncGen

	LINK_LIBS PUBLIC
	MLIRIR
    MLIRInferTypeOpInterface
	)