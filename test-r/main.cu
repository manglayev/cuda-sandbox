#include "header.cuh"

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"

#include <stdio.h>
#include <stdlib.h>

#define THREADS 5
#define BLOCKS 1

__global__ void globalFunction(int *dev_a)
{
  int thread = threadIdx.x + blockIdx.x*blockDim.x;
  if(thread < THREADS)
  {
    dev_a[thread] = dev_a[thread]*dev_a[thread];
    dev_a[thread] = deviceFunction(dev_a[thread]);
  }
}

int main()
{
  int a[THREADS] = { 1, 2, 3, 4, 5 };
  printf("START\n");
  for(int i = 0; i<THREADS; i++)
    printf("a[%d] = %.2d; ", i, a[i]);
  printf("\nEND\n");
  int *dev_a;
  cudaMalloc((void**)&dev_a, THREADS*sizeof(int));
  cudaMemcpy(dev_a, a, THREADS*sizeof(int), cudaMemcpyHostToDevice);
  globalFunction<<<BLOCKS, THREADS>>>(dev_a);
  cudaMemcpy(a, dev_a, THREADS*sizeof(int), cudaMemcpyDeviceToHost);

  for(int i = 0; i<THREADS; i++)
    printf("a[%d] = %.2d; ", i, a[i]);
  printf("\n");
  cudaFree(dev_a);
  return 0;
}