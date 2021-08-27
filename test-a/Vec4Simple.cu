#include "open_acc_map_header.cuh"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime.h"

__device__ int* cuda_device_1(int *dev_a, int *dev_b);
__device__ int cuda_device_2(int dev_a, int dev_b);

__device__ int* cuda_device_1(int *dev_a, int *dev_b)
{
  int i = threadIdx.x;
  if (i < CUDASIZE)
  {
    dev_a[i] = dev_a[i] + dev_b[i];
  }
  return dev_a;
}

__device__ int cuda_device_2(int dev_a, int dev_b)
{
  int i = threadIdx.x;
  int dev_c;
  if (i < CUDASIZE)
  {
    dev_c = dev_a + dev_b;
    printf("CUDA CODE\n");
  }
  return dev_c;
}
