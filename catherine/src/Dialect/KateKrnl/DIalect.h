#include "mlir/IR/Dialect.h"
#include "mlir/IR/Function.h"
#include "mlir/Interfaces/SideEffects.h"

namespace mlir {
namespace katekrnl {

class KateKrnlDialect : public mlir::Dialect {
    explicit FpgaKrnlDialect(mlir::MLIRContext *ctx);
    static llvm::StringRef getDialectNamespace() {
        return "katekrnl";
    }
};

#define GET_OP_CLASSES
#include "Ops.h.inc"
}
}