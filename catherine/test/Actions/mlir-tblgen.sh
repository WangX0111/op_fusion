# cd catherine
# bash test/Actions/mlir-tblgen.sh ./include/Blis/BlisDialect.td ./include/Blis/BlisOps.td 
MLIR_TABLEGEN=$PWD/../../llvm-project/build/bin/mlir-tblgen
$MLIR_TABLEGEN -gen-dialect-decls $1 -I $PWD/../../llvm-project/mlir/include/ 
$MLIR_TABLEGEN -gen-op-defs $2 -I  ./include/Blis -I $PWD/../../llvm-project/mlir/include/ 