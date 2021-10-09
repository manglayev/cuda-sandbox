#include "open_acc_map_header.cuh"
#include "device_launch_parameters.h"
#include "cuda.h"
#include <cuda_runtime.h>

__constant__ int dev_a;
__global__ void cudaFunction(int *b)
{
  int index = threadIdx.x + blockIdx.x*blockDim.x;
  if(index<CUDASIZE)
  {
    b[index] = b[index]-3;
  }
}

void wrapper(int c)
{
  int b[CUDASIZE];
  for(int a=0;a<CUDASIZE;a++)
  {
    b[a] = c+a*c;
    printf("b[%d] = %d;\n", a, b[a]);
  }
  int *dev_b;
  cudaMalloc((void**)&dev_b, CUDASIZE*sizeof(int));
	cudaMemcpy(dev_b, b, CUDASIZE*sizeof(int), cudaMemcpyHostToDevice);
  cudaFunction<<<BLOCKS, THREADS>>>(dev_b);
  cudaMemcpy(b, dev_b, CUDASIZE*sizeof(int), cudaMemcpyDeviceToHost);
  printf("AFTER\n");
  for(int a=0;a<CUDASIZE;a++)
  {
    printf("b[%d] = %d;\n", a, b[a]);
  }
  cudaFree(dev_b);
}
