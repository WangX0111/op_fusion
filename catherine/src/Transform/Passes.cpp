//===------------------------------------------------------------*- C++ -*-===//
//
//===----------------------------------------------------------------------===//
#include "mlir/Conversion/Passes.h"
#include "mlir/Dialect/Affine/Passes.h"
#include "mlir/Dialect/Arith/Transforms/Passes.h"
#include "mlir/Dialect/Bufferization/Transforms/Passes.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Func/Transforms/Passes.h"
#include "mlir/Dialect/Linalg/Passes.h"
#include "mlir/Dialect/MemRef/Transforms/Passes.h"
#include "mlir/Dialect/Tensor/Transforms/Passes.h"
#include "mlir/Dialect/Tosa/Transforms/Passes.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Transforms/Passes.h"
#include "Passes.h"

using namespace mlir;
using namespace catherine;

namespace{
#define GEN_PASS_REGISTRATION
#include "Passes.h.inc"
} // namespace

namespace {
struct HLSDSEPipelineOptions
    : public PassPipelineOptions<HLSDSEPipelineOptions> {

  Option<std::string> hlsTopFunc{
      *this, "tool-config", llvm::cl::init("../config/tool-config.ini"),
      llvm::cl::desc("Config file path: global configurations for the ScaleHLS tools")};

  Option<std::string> opLatency{
      *this, "op-latency", llvm::cl::init("../config/op-latency.ini"),
      llvm::cl::desc(
          "Config file path: profiling data for operation latency")};
};
} // namespace

void catherine::registerHLSDSEPipeline() {
  PassPipelineRegistration<HLSDSEPipelineOptions>(
      "catherine-dse-pipeline",
      "Launch design space exploration ",
      [](OpPassManager &pm, const HLSDSEPipelineOptions &opts) {
        // Legalize the input program.

        // Apply the automatic design space exploration to the top function.

        // Finally, estimate the QoR of the DSE result.
        pm.addPass(catherine::createEstimationPass());
      });
}

void catherine::registerTransformsPasses() {
    registerHLSDSEPipeline();
    registerPasses();
}