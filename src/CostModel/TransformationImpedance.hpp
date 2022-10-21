#ifndef ONNX_MLIR_TransformationImpedance_HPP
#define ONNX_MLIR_TransformationImpedance_HPP

#include "llvm/ADT/SmallSet.h"
#include <string>
#include <unordered_map>

namespace onnx_mlir {
enum class TIType { OneToOne = 1, OneToMany = 2, ManyToMany = 3, Shuffle = 4, Reorganize = 5, UNDEFINED };

class TransformationImpedance {
public:
  explicit TransformationImpedance() : type_(TIType::UNDEFINED), id_("") {}
  explicit TransformationImpedance(TIType type) : type_(type), id_("") {}
  explicit TransformationImpedance(TIType type, std::string id) : type_(type), id_(id) {}

  std::string id() const { return id_; }
  TIType type() const { return type_; }

  bool operator==(const TransformationImpedance &TI) {
    return type_ == TI.type_ && id_ == TI.id_;
  }

  bool operator!=(const TransformationImpedance &TI) { return !(*this == TI); }

private:
  TIType type_ = TIType::UNDEFINED;
  std::string id_ = "";

  friend bool operator<(const TransformationImpedance &lhs, const TransformationImpedance &rhs) {
    return lhs.id_ < rhs.id_;
  }
  friend bool operator==(const TransformationImpedance &lhs, const TransformationImpedance &rhs) {
    return lhs.type_ == rhs.type_ && lhs.id_ == rhs.id_;
  }
};

struct TIInfo {

  TIInfo()
      : impedance(0) {}

  TIInfo(double impedance)
      : impedance(impedance){}

  //Impedance
  double impedance;

};

using TISetT = llvm::SmallSet<TransformationImpedance, 5>;

TISetT GetTISet();

std::unordered_map<std::string, TransformationImpedance> GetTITable();

TIInfo GetTIInfo(const TransformationImpedance &TI);

} // namespace onnx_mlir

#endif /* ONNX_MLIR_TransformationImpedance_HPP */
