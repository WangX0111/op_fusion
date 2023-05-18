transform.sequence failures(propagate) {
^bb1(%arg1: !pdl.operation):
  %0 = transform.structured.match ops{["scf.for"]}  in %arg1 : (!pdl.operation) -> !pdl.operation
  %1 = transform.cast %0 : !pdl.operation to !transform.op<"scf.for">
  // %2 = transform.loop.coalesce %1 : (!transform.op<"scf.for">) -> (!transform.op<"scf.for">)
  transform.loop.unroll %1 { factor = 4 } : !transform.op<"scf.for">
}
