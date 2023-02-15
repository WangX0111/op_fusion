/*===- TableGen'erated file -------------------------------------*- C++ -*-===*\
|*                                                                            *|
|* Dialect Definitions                                                        *|
|*                                                                            *|
|* Automatically generated file, do not edit!                                 *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

MLIR_DEFINE_EXPLICIT_TYPE_ID(::catherine::blis::BlisDialect)
namespace catherine {
namespace blis {

BlisDialect::BlisDialect(::mlir::MLIRContext *context)
    : ::mlir::Dialect(getDialectNamespace(), context, ::mlir::TypeID::get<BlisDialect>()) {
  
  initialize();
}

BlisDialect::~BlisDialect() = default;

} // namespace blis
} // namespace catherine
