add_mlir_dialect(HLS hls)

# set(LLVM_TARGET_DEFINITIONS HLS.td)
# mlir_tablegen(HLSDialect.h.inc -gen-dialect-decls)
# mlir_tablegen(HLSDialect.cpp.inc -gen-dialect-defs)
# add_public_tablegen_target(HLSDialect)

set(LLVM_TARGET_DEFINITIONS Interfaces.td)
mlir_tablegen(HLSInterfaces.h.inc -gen-op-interface-decls)
mlir_tablegen(HLSInterfaces.cpp.inc -gen-op-interface-defs)
add_public_tablegen_target(CatherineHLSInterfacesIncGen)

file(GLOB globbed *.cpp)

add_mlir_dialect_library(CatherineHLS
  ${globbed}

  DEPENDS
  MLIRHLSIncGen
  CatherineHLSInterfacesIncGen

  )
