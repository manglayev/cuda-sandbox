#include "open_acc_map_header.cuh"
#include "device_launch_parameters.h"
#include "cuda.h"
#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>
__constant__ int dev_a;
__global__ void cudaFunction(int *b)
{
  int index = threadIdx.x + blockIdx.x*blockDim.x;
  //printf("CUDA [%d]: \n", index);
  if(index<CUDASIZE)
  {
    printf("dev_a = %d\n", dev_a);
    b[index] = b[index]+15;
  }
}

void wrapper(int c)
{
  printf("STAGE 3\n");
  printf("c = %d\n", c);

  int blockDataSizeTimesWID3 = 159;
  cudaMemcpyToSymbol(dev_a, &blockDataSizeTimesWID3, sizeof(int));

  int b[CUDASIZE];
  int *dev_b;
  cudaMalloc((void**)&dev_b, CUDASIZE*sizeof(int));
  for(int a=0; a<CUDASIZE; a++)
  {
    b[a] = c-a;
  }
  printf("before: b = %d\n", b[CUDASIZE-1]);
	cudaMemcpy(dev_b, b, CUDASIZE*sizeof(int), cudaMemcpyHostToDevice);
  cudaFunction<<<BLOCKS, THREADS>>>(dev_b);
  cudaMemcpy(b, dev_b, CUDASIZE*sizeof(int), cudaMemcpyDeviceToHost);
  printf("after: b = %d\n", b[CUDASIZE-3]);
  cudaFree(dev_b);
}
