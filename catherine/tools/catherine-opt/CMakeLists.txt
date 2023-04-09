get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)


set(LIBS
  ${dialect_libs}
  ${conversion_libs}
  MLIROptLib

  CatherineHLS
  # CatherinePasses
  CatherineTransforms
  )

add_llvm_executable(catherine-opt catherine-opt.cpp)

llvm_update_compile_flags(catherine-opt)
target_link_libraries(catherine-opt PRIVATE ${LIBS})



# add_llvm_tool(kate-opt
# kate-opt.cpp
#   )

# llvm_update_compile_flags(kate-opt)

# target_link_libraries(kate-opt
#   PRIVATE
#   ${dialect_libs}
#   ${conversion_libs}
#   MLIROptLib

#   MLIRHLS
#   KateTransforms

#   # Threads::Threads
#   )


# set(LIBS
#         ${dialect_libs}
#         ${conversion_libs}
#         MLIROptLib
#         MLIRBlis
#         KateKrnlToAffine
#         KateONNXToKrnl
#         KateTransforms
#         )
# add_llvm_executable(blis-opt blis-opt.cpp)

# llvm_update_compile_flags(blis-opt)
# target_link_libraries(blis-opt PRIVATE ${LIBS})

