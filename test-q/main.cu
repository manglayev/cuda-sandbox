#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"

#include <stdio.h>
#include <stdlib.h>

#define THREADS 5
#define BLOCKS 1

__global__ void testFunction(int *dev_a)
{
  int thread = threadIdx.x+blockIdx.x*blockDim.x;
  if(thread < THREADS)
  {
    dev_a[thread] = dev_a[thread]*dev_a[thread];
    dev_a[thread] = testFunction(dev_a);
  }
}

__device__ int testFunction(int *dev_a)
{
    dev_a[thread] = dev_a[thread]*dev_a[thread];
    return dev_a;
}

int main()
{
  int a[THREADS] = { 1, 2, 3, 4, 5 };
  printf("BEFORE START 1\n");
  for(int i = 0; i<THREADS; i++)
    printf("a[%d] = %.2d; ", i, a[i]);
  printf("\nBEFORE END 2\n");
  int *dev_a;
  cudaMalloc((void**)&dev_a, THREADS*sizeof(int));
  cudaMemcpy(dev_a, a, THREADS*sizeof(int), cudaMemcpyHostToDevice);
  testFunction<<<BLOCKS, THREADS>>>(dev_a);
  cudaMemcpy(a, dev_a, THREADS*sizeof(int), cudaMemcpyDeviceToHost);

  printf("BEFORE START 1\n");
  for(int i = 0; i<THREADS; i++)
    printf("a[%d] = %.2d; ", i, a[i]);
  printf("\nBEFORE END 2\n");
  cudaFree(dev_a);
  return 0;
}
