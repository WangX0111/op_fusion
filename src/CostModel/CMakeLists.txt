add_onnx_mlir_library(OMCost
  TransformationImpedance.cpp

  LINK_LIBS PUBLIC
  OMONNXOps
)