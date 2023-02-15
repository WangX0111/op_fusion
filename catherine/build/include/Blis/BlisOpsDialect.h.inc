/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Dialect Declarations                                                       *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

namespace catherine {
namespace blis {

class BlisDialect : public ::mlir::Dialect {
  explicit BlisDialect(::mlir::MLIRContext *context);

  void initialize();
  friend class ::mlir::MLIRContext;
public:
  ~BlisDialect() override;
  static constexpr ::llvm::StringLiteral getDialectNamespace() {
    return ::llvm::StringLiteral("blis");
  }
};
} // namespace blis
} // namespace catherine
MLIR_DECLARE_EXPLICIT_TYPE_ID(::catherine::blis::BlisDialect)
