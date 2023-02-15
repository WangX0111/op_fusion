add_mlir_dialect_library(MLIRBlis
        BlisDialect.cpp
        BlisOps.cpp

        ADDITIONAL_HEADER_DIRS
        ${PROJECT_SOURCE_DIR}/include/Blis

        DEPENDS
        MLIRBlisOpsIncGen

	LINK_LIBS PUBLIC
	MLIRIR
        MLIRInferTypeOpInterface
	)