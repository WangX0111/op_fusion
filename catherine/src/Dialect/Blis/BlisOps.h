#ifndef BLIS_BLISOPS_H
#define BLIS_BLISOPS_H

#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/Interfaces/InferTypeOpInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"


#define GET_OP_CLASSES
#include "Blis/BlisOps.h.inc"

#endif // BLIS_BLISOPS_H
