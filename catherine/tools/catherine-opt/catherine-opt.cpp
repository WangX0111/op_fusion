//===----------------------------------------------------------------------===//
//
// Copyright 2020-2021 The ScaleHLS Authors.
//
//===----------------------------------------------------------------------===//

#include "mlir/Tools/mlir-opt/MlirOptMain.h"
#include "InitAllDialects.h"
#include "InitAllPasses.h"


int main(int argc, char **argv) {

  mlir::DialectRegistry registry;
  mlir::catherine::registerAllDialects(registry);
  mlir::catherine::registerAllPasses();

  return mlir::failed(mlir::MlirOptMain(
      argc, argv, "catherine Optimization Tool", registry, true));
}
