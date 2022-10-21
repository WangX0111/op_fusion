#ifndef ONNX_MLIR_LOG_HPP
#define ONNX_MLIR_LOG_HPP

#include "mlir/IR/Value.h"
#include <iostream>
#include <unordered_set>

namespace onnx_mlir {

extern std::unordered_set<std::string> NotSupportCostOp;

template <typename MapT>
void PrintMapContainer(MapT map) {
  std::cout << "size: " << map.size() << "\n";
  if (map.size() == 0) {
    return;
  }
  for (const auto &kv : map) {
    std::cout << kv.first << "\n";
    for (const auto &v : kv.second) {
      std::cout << v << "\n";
    }
  }
}

template <typename ValueT>
void PrintContainer(ValueT con) {
  for (const auto &c : con) {
    std::cout << c << "\n";
  }
}

template <typename MapT>
void PrintMapValue(MapT map) {
  std::cout << "size: " << map.size() << "\n";
  if (map.size() == 0) {
    return;
  }
  for (const auto &kv : map) {
    std::cout << kv.first << " : " << kv.second << "\n";
  }
}

std::ostream &operator<<(std::ostream &os, const mlir::Value &value);

} // namespace onnx_mlir

#endif /* ONNX_MLIR_LOG_HPP */
