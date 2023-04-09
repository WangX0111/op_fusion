// #include "mlir/IR/Dialect.h"
// #include "mlir/IR/Function.h"
// #include "mlir/Interfaces/SideEffects.h"

// namespace mlir {
// namespace katekrnl {

// class KateKrnlDialect : public mlir::Dialect {
//     explicit FpgaKrnlDialect(mlir::MLIRContext *ctx);
//     static llvm::StringRef getDialectNamespace() {
//         return "katekrnl";
//     }
// };

// #define GET_OP_CLASSES
// #include "Ops.h.inc"
// }
// }

//===------------------------------------------------------------*- C++ -*-===//
//
//===----------------------------------------------------------------------===//

#ifndef DIALECT_HLS_DIALECT_H
#define DIALECT_HLS_DIALECT_H

#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/Dialect.h"

#include "Dialect/HLS/HLSDialect.h.inc"

namespace mlir {
namespace catherine {
namespace hls {

#include "Dialect/HLS/HLSInterfaces.h.inc"



} // namespace hls
} // namespace catherine
} // namespace mlir

#define GET_OP_CLASSES
#include "Dialect/HLS/HLS.h.inc"

#endif // DIALECT_HLS_DIALECT_H
