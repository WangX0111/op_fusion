#include <iostream>
#include <vector>
#include "../npy.hpp"
#include "OnnxMlirRuntime.h"

// Declare the inference entry point.
extern "C" OMTensorList *run_main_graph(OMTensorList *);
 
int simple_threemm() {
  // Shared shape & rank.
  int64_t shape1[] = {12, 3};
  int64_t rank1 = 2;
  // Construct x1 omt filled with 1.
  static float x1Data[] = {0.4573204 , 0.46060933, 0.5800912 ,
       0.85331987, 0.90652472, 0.59238036,
       0.47235101, 0.21458009, 0.98554157,
       0.49579839, 0.98077584, 0.42012763,
       0.11691104, 0.52970975, 0.39412808,
       0.67973571, 0.25232807, 0.69617844,
       0.54644784, 0.87070169, 0.59523485,
       0.192373  , 0.08664168, 0.16271564,
       0.6390891 , 0.65441164, 0.29772413,
       0.69043329, 0.2666002 , 0.27606835,
       0.2056621 , 0.83328899, 0.66566589,
       0.65994849, 0.6825838 , 0.18784014};

  OMTensor *x1 = omTensorCreate(x1Data, shape1, rank1, ONNX_TYPE_FLOAT);
  
  // Construct a list of omts as input.
  OMTensor *list[1] = {x1};
  OMTensorList *input = omTensorListCreate(list, 1);
  // Call the compiled onnx model function.
  OMTensorList *outputList = run_main_graph(input);
  if (!outputList) {
    // May inspect errno to get info about the error.
    return 1;
  }
  // Get the first omt as output.
  OMTensor *y = omTensorListGetOmtByIndex(outputList, 0);
  float *outputPtr = (float *)omTensorGetDataPtr(y);
  // Print its content, should be all 3.
  for (int i = 0; i < 9; i++)
    printf("%f ", outputPtr[i]);
  return 0;
}

int main(){
  printf("init\n");
  std::string npy_file = "tensor-6144-1024.npy";
  std::vector<unsigned long> t_shape;
  std::vector<float> t_data; // 必须指定<dtype>类型与npy对应
  t_shape.clear();
  t_data.clear();
  bool is_fortran;
  // load ndarray voxel as vector<float>
  npy::LoadArrayFromNumpy(npy_file, t_shape, is_fortran, t_data);
  printf("load success\n");
  std::cout<<t_data.size()<<"  "<<t_shape.size()<<std::endl;
 
  // Shared shape & rank.
  int64_t shape1[] = {6144, 1024};
  int64_t rank1 = 2;
  // Construct x1 omt filled with 1.
  float x1Data[] = {};

  OMTensor *x1 = omTensorCreate(&t_data, shape1, rank1, ONNX_TYPE_FLOAT);
  
  // Construct a list of omts as input.
  OMTensor *list[1] = {x1};
  OMTensorList *input = omTensorListCreate(list, 1);
  // Call the compiled onnx model function.
  OMTensorList *outputList = run_main_graph(input);
  return 0;
  if (!outputList) {
    // May inspect errno to get info about the error.
    return 1;
  }
  printf("run success\n");

  // Get the first omt as output.
  OMTensor *y = omTensorListGetOmtByIndex(outputList, 0);
  float *outputPtr = (float *)omTensorGetDataPtr(y);
  // Print its content, should be all 3.
  // for (int i = 0; i < 9; i++)
  //   printf("%f ", outputPtr[i]);
  return 0;
}