#include "src/CostModel/TransformationImpedance.hpp"
#include <string>
#include <unordered_map>

namespace onnx_mlir {

TISetT GetTISet() {
  // hack code

  // one cpu and 4C
  TISetT TI_set;
  TI_set.insert(TransformationImpedance(TIType::OneToOne, "OneToOne"));
  TI_set.insert(TransformationImpedance(TIType::OneToMany, "OneToMany"));
  TI_set.insert(TransformationImpedance(TIType::ManyToMany, "ManyToMany"));
  TI_set.insert(TransformationImpedance(TIType::Shuffle, "Shuffle"));
  TI_set.insert(TransformationImpedance(TIType::Reorganize, "Reorganize"));

  return TI_set;
}

std::unordered_map<std::string, TransformationImpedance> GetTITable() {
  TISetT TI_set = GetTISet();
  std::unordered_map<std::string, TransformationImpedance> TI_table;
  for (const auto &TI : TI_set) {
    TI_table[TI.id()] = TI;
  }
  return TI_table;
};

// http://wiki.enflame.cn/pages/viewpage.action?pageId=70331886
// http://blog.sysu.tech/Benchmark/%E5%A6%82%E4%BD%95%E8%AE%A1%E7%AE%97CPU%E7%AE%97%E5%8A%9B%E7%90%86%E8%AE%BA%E5%B3%B0%E5%80%BC/
TIInfo GetTIInfo(const TransformationImpedance &TI) {
  auto TI_type = TI.type();
  TIInfo TI_info;
  if (TI_type == TIType::OneToOne) {
   
    TI_info.impedance = 1;

  } else if(TI_type == TIType::OneToMany) {
     TI_info.impedance = 2;

  } else if (TI_type == TIType::ManyToMany) {
     TI_info.impedance = 3;
  } else if (TI_type == TIType::Shuffle) {
     TI_info.impedance = 1.5;
  } else if (TI_type == TIType::Reorganize) {
     TI_info.impedance = 1.5;
  }

  return TI_info;
}

} // namespace onnx_mlir
