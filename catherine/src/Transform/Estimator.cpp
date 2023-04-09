//===----------------------------------------------------------------------===//
//
// Copyright 2020-2021 The ScaleHLS Authors.
//
//===----------------------------------------------------------------------===//

// #ifndef TRANSFORMS_ESTIMATOR_H
// #define TRANSFORMS_ESTIMATOR_H
#include <mlir/IR/Operation.h>
#include "mlir/IR/BuiltinOps.h"

#include "Dialect/HLS/HLS.h"
#include "Passes.h"
#include "INIReader.h"

using namespace mlir;
using namespace catherine;
using namespace hls;


namespace {
class Estimator {
public:
  explicit Estimator(std::string toolConfigPath, std::string opLatencyPath) {
    llvm::outs() << toolConfigPath;
    INIReader toolConfig(toolConfigPath);
    if (toolConfig.ParseError())
      llvm::outs() << "error: Tool configuration file parse fail.\n";

    INIReader opLatency(opLatencyPath);
    if (opLatency.ParseError())
      llvm::outs() << "error: Op latency file parse fail.\n";

    auto freq = toolConfig.Get("config", "frequency", "200MHz");
    auto latency = opLatency.GetInteger(freq, "op", 0);
    llvm::outs() << latency << "\n";
  }

  void estimateLoop(AffineForOp loop);
  void estimateFunc(func::FuncOp func);
  void estimateModule(ModuleOp module);

private:
};
} // namespace

// 用于估计一个 AffineForOp 循环的延迟（latency）。
// 方法首先检查循环体内有且只有一个基本块，且该基本块的第一个操作必须是 LoopParamOp（用于定义循环参数的操作）。如果不符合这些条件，则发出错误信息并返回。
// 接下来，方法迭代遍历循环体中的操作，如果发现某个操作是 AffineForOp，则递归估计该子循环的延迟，并将其加到当前循环的延迟中。
// 最后，如果循环未被完全展开，则计算最终延迟并设置 LoopParamOp 的 "latency" 属性。否则，将不会计算延迟，因为展开后的循环延迟是已知的。
void Estimator::estimateLoop(AffineForOp loop) {
  auto &body = loop.getLoopBody();
  if (body.getBlocks().size() != 1)
    loop.emitError("has zero or more than one basic blocks.");

  auto paramOp = dyn_cast<hls::LoopParamOp>(body.front().front());
  if (!paramOp) {
    loop.emitError("doesn't have parameter operations as front.");
    return;
  }

  // TODO: a simple AEAP scheduling.
  unsigned iterLatency = paramOp.getNonprocLatency();
  for (auto &op : body.front()) {
    if (auto subLoop = dyn_cast<mlir::AffineForOp>(op)) {
      estimateLoop(subLoop);
      auto subParamOp =
          dyn_cast<hls::LoopParamOp>(subLoop.getLoopBody().front().front());
      iterLatency += subParamOp.getLatency();
    }
  }

  unsigned latency = iterLatency;
  // When loop is not completely unrolled.
  if (paramOp.getLoopBound() > 1)
    latency = iterLatency * paramOp.getLoopBound() * paramOp.getUnrollFactor();
  auto builder = Builder(paramOp.getContext());
  // paramOp.setAttr("latency", builder.getUI32IntegerAttr(latency));
  paramOp.setLatency( latency);
}

/// For now, function pipelining and task-level dataflow optimizations are not
/// considered for simplicity.
void Estimator::estimateFunc(func::FuncOp func) {
  if (func.getBlocks().size() != 1)
    func.emitError("has zero or more than one basic blocks.");

  auto paramOp = dyn_cast<FuncParamOp>(func.front().front());
  if (!paramOp) {
    func.emitError("doesn't have parameter operations as front.");
    return;
  }

  // Recursively estimate latency of sub-elements, including functions and
  // loops. These sub-elements will be considered as a normal node in the CDFG
  // for function latency estimzation.
  for (auto &op : func.front()) {
    if (auto subFunc = dyn_cast<func::FuncOp>(op))
      estimateFunc(subFunc);
    else if (auto subLoop = dyn_cast<AffineForOp>(op))
      estimateLoop(subLoop);
  }

  // Estimate function latency.
  for (auto &op : func.front()) {
  }
}

void Estimator::estimateModule(ModuleOp module) {
  for (auto &op : module) {
    if (auto func = dyn_cast<func::FuncOp>(op))
      estimateFunc(func);
    else
      op.emitError("is unsupported operation.");
    // else if (!isa<mlir::ModuleTerminatorOp>(op))
    //   op.emitError("is unsupported operation.");
  }
}

namespace {
struct Estimation : public EstimationBase<Estimation> {
  Estimation() = default;
  void runOnOperation() override {
    Estimator(toolConfig, opLatency).estimateModule(getOperation());
  }
};
} // namespace

std::unique_ptr<Pass> catherine::createEstimationPass() {
  return std::make_unique<Estimation>();
}
