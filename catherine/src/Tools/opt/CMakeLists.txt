get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)
# add_llvm_tool(blis-opt
#   blis-opt.cpp
# )

set(LIBS
        ${dialect_libs}
        ${conversion_libs}
        MLIROptLib
        MLIRBlis
        KateKrnlToAffine
        KateTransforms
        )
add_llvm_executable(blis-opt blis-opt.cpp)

# find_package(BLIS REQUIRED)

llvm_update_compile_flags(blis-opt)
target_link_libraries(blis-opt PRIVATE ${LIBS})
# target_link_libraries(blis-opt BLIS::BLIS)
