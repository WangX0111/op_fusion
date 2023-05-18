#include <iostream>
#include <vector>
#include "npy.hpp"
#include "OnnxMlirRuntime.h"

// Declare the inference entry point.
extern "C" OMTensorList *run_main_graph(OMTensorList *);

float img_data[4096][1024];
// static float img_data[] = {...};

int main() {
  printf("init\n");
  std::string npy_file = "tensor.npy";
  std::vector<unsigned long> shape1;
  std::vector<float> data; // 必须指定<dtype>类型与npy对应
  shape1.clear();
  data.clear();
  bool is_fortran;
  // load ndarray voxel as vector<float>
  npy::LoadArrayFromNumpy(npy_file, shape1, is_fortran, data);
  printf("load success\n");
    
  // Create an input tensor list of 1 tensor.
  int inputNum = 1;
  OMTensor *inputTensors[inputNum];
  // The first input is of tensor<1x1x28x28xf32>.
  int64_t rank = 4;
  int64_t shape[] = {1, 1, 4096, 1024};

  // Create a tensor using omTensorCreateWithOwnership (returns a pointer to the OMTensor).
  // When the parameter, owning is set to "true", the OMTensor will free the data
  // pointer (img_data) upon destruction. If owning is set to false, the data pointer will
  // not be freed upon destruction.
  OMTensor *tensor = omTensorCreateWithOwnership(&data, shape, rank, ONNX_TYPE_FLOAT, /*owning=*/true);

  // Create a tensor list using omTensorListCreate (returns a pointer to the OMTensorList).
  inputTensors[0] = tensor;
  OMTensorList *tensorListIn = omTensorListCreate(inputTensors, inputNum);

  // Compute outputs.
  OMTensorList *tensorListOut = run_main_graph(tensorListIn);
  return 0;

  // Extract the output. The model defines one output of type tensor<1024*1024xf32>.
  OMTensor *y = omTensorListGetOmtByIndex(tensorListOut, 0);
  float *prediction = (float *)omTensorGetDataPtr(y);

  // Analyze the output.
  // int digit = -1;
  // float prob = 0.;
  // for (int i = 0; i < 10; i++) {
  //   printf("prediction[%d] = %f\n", i, prediction[i]);
  //   if (prediction[i] > prob) {
  //     digit = i;
  //     prob = prediction[i];
  //   }
  // }
  // The OMTensorListDestroy will free all tensors in the OMTensorList
  // upon destruction. It is important to note, that every tensor will
  // be destroyed. To free the OMTensorList data structure but leave the
  // tensors as is, use OMTensorListDestroyShallow instead.
  omTensorListDestroy(tensorListOut);
  omTensorListDestroy(tensorListIn);

  // printf("The digit is %d\n", digit);
  return 0;
}