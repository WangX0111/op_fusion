#include "mlir/IR/Dialect.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Support/FileUtilities.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/ToolOutputFile.h"

#include "Blis/BlisDialect.h"
#include "Blis/BlisOps.h"
// #include "Blis/BlisOpsDialect.cpp.inc"

namespace catherine{
namespace blis{
  void registerMatMulOptimizePass();
}
}

int main(int argc, char **argv) {
  // Register all MLIR passes.
  mlir::registerAllPasses();
  // Register Vectorization of Convolution.
  // Register Vectorization of Pooling.
  // Register Several Optimize Pass.
  catherine::blis::registerMatMulOptimizePass();

  mlir::DialectRegistry registry;
  // Register all MLIR core dialects.
  registerAllDialects(registry);
  // Register dialects in project.
  // clang-format off
  registry.insert<catherine::blis::BlisDialect>();
  registry.insert<mlir::func::FuncDialect>();
  registry.insert<mlir::arith::ArithDialect>();
  // Add the following to include *all* MLIR Core dialects, or selectively
  // include what you need like above. You only need to register dialects that
  // will be *parsed* by the tool, not the one generated
  // registerAllDialects(registry);

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Blis optimizer driver\n", registry));
}