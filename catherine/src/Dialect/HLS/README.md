This dialect contains dedicated operations, interfaces, and passes designed
    for representing HLS specific structures and components in MLIR, while
    enabling comprehensive optimization for both performance and area. Passes
    in this dialect can optimize and generate IRs


用于估计一个 func 的延迟（latency）。
方法首先检查循环体内有且只有一个基本块，且该基本块的第一个操作必须是 LoopParamOp（用于定义循环参数的操作）。如果不符合这些条件，则发出错误信息并返回。
接下来，方法迭代遍历循环体中的操作，如果发现某个操作是 AffineForOp，则递归估计该子循环的延迟，并将其加到当前循环的延迟中。
最后，如果循环未被完全展开，则计算最终延迟并设置 LoopParamOp 的 "latency" 属性。否则，将不会计算延迟，因为展开后的循环延迟是已知的。
