//===- ONNXToKrnlLowering.cpp -------------------------------------------------===//
//
//  该文件实现了
//
//===----------------------------------------------------------------------===//
#include <mlir/IR/BuiltinOps.h>
#include <mlir/Dialect/Affine/IR/AffineOps.h>
#include <mlir/Dialect/Func/IR/FuncOps.h>
#include <mlir/Dialect/Linalg/Transforms/Transforms.h>
#include <mlir/IR/Dialect.h>
#include <mlir/IR/Operation.h>
#include <mlir/IR/TypeUtilities.h>
#include <mlir/IR/Value.h>
#include <mlir/Pass/Pass.h>
#include "llvm/Support/Debug.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#define DEBUG_TYPE "kate"
using namespace mlir;
using namespace vector;

namespace {
 /// Manages the indentation as we traverse the IR nesting.
int indent;
struct IdentRAII {
  int &indent;
  IdentRAII(int &indent) : indent(indent) {}
  ~IdentRAII() { --indent; }
};
void resetIndent() { indent = 0; }
IdentRAII pushIndent() { return IdentRAII(++indent); }

llvm::raw_ostream &printIndent() {
  for (int i = 0; i < indent; ++i)
    llvm::outs() << "  ";
  return llvm::outs();
}

void printRegion(Region &region) ;

void printBlock(Block &block) ;

void printOperation(Operation *op) {
  // Print the operation itself and some of its properties
  printIndent() << "visiting op: '" << op->getName() << "' with "
                << op->getNumOperands() << " operands and "
                << op->getNumResults() << " results\n";
  // Print the operation attributes
    if (!op->getAttrs().empty()) {
      printIndent() << op->getAttrs().size() << " attributes:\n";
      for (NamedAttribute attr : op->getAttrs())
        printIndent() << " - '" << attr.getName().getValue() << "' : '"
                      << attr.getValue() << "'\n";
    }

  // Recurse into each of the regions attached to the operation.
  printIndent() << " " << op->getNumRegions() << " nested regions:\n";
  auto indent = pushIndent();
  for (Region &region : op->getRegions())
    printRegion(region);
}



void printRegion(Region &region) {
    // A region does not hold anything by itself other than a list of blocks.
    printIndent() << "Region with " << region.getBlocks().size()
                  << " blocks:\n";
    auto indent = pushIndent();
    for (Block &block : region.getBlocks())
      printBlock(block);
  }


void printBlock(Block &block) {
    // Print the block intrinsics properties (basically: argument list)
    printIndent()
        << "Block with " << block.getNumArguments() << " arguments, "
        << block.getNumSuccessors()
        << " successors, and "
        // Note, this `.size()` is traversing a linked-list and is O(n).
        << block.getOperations().size() << " operations\n";

    // A block main role is to hold a list of Operations: let's recurse into
    // printing each operation.
    auto indent = pushIndent();
    for (Operation &op : block.getOperations())
      printOperation(&op);
  }



class ONNXToKrnlLowering
    : public PassWrapper<ONNXToKrnlLowering, OperationPass<ModuleOp>> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(ONNXToKrnlLowering)
  StringRef getArgument() const final { return "fuse"; }
  StringRef getDescription() const final { return "fuse strategy"; }
  ONNXToKrnlLowering() = default;
  ONNXToKrnlLowering(const ONNXToKrnlLowering &) {}

  void runOnOperation() override;

  void getDependentDialects(DialectRegistry &registry) const override {
    // registry.insert<linalg::LinalgDialect, scf::SCFDialect, AffineDialect, VectorDialect
    //                 >();
  }

  };



void ONNXToKrnlLowering::runOnOperation() {
  MLIRContext *context = &getContext();
  ModuleOp module = getOperation();
  resetIndent();
  printOperation(module);

//   ConversionTarget target(*context);
//   target
//       .addLegalDialect<arith::ArithDialect, AffineDialect, scf::SCFDialect,
//                        memref::MemRefDialect, VectorDialect>();
//   target.addLegalOp<ModuleOp, func::FuncOp, func::ReturnOp>();
//   target.addLegalOp<linalg::FillOp>();

//   RewritePatternSet patterns(context);
//   patterns.add<KrnlMatMulLoweringPattern>(context);


//   if (failed(applyPartialConversion(module, target, std::move(patterns))))
//     signalPassFailure();
}
} // end anonymous namespace.



namespace catherine {

void registerONNXToKrnlLoweringPass() { PassRegistration<ONNXToKrnlLowering>(); }

} // namespace catherine
