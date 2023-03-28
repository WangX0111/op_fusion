set(LLVM_LINK_COMPONENTS
  Support
  )

get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(translation_libs GLOBAL PROPERTY MLIR_TRANSLATION_LIBS)

set(LIBS
  ${dialect_libs}
  ${translation_libs}
  MLIRIR
  MLIRParser
  MLIRPass
  MLIRTranslation
  MLIRSupport

  # kateEmitHLSCpp
  )

add_llvm_executable(kate-translate kate-translate.cpp)

llvm_update_compile_flags(kate-translate)
target_link_libraries(kate-translate PRIVATE ${LIBS})

# mlir_check_link_libraries(kate-translate)
