#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"

#include <stdio.h>
#include <stdlib.h>

#define THREADS 5
#define BLOCKS 1

__global__ void testFunction(float *dev_a)
{
  int thread = threadIdx.x;
  if(thread == 0)
  {
    printf("dev[%d] = %.2f;\n", thread, dev_a[thread+2]);
    int c = 0;
    if (thread == 0)
    {
      int dev_b[2];
      dev_b[0] = 0;
      dev_b[1] = 1;
      c = dev_b[0] + dev_b[1];
    }
    if (thread == 1)
    {
      int dev_b[3];
      dev_b[0] = 0;
      dev_b[1] = 1;
      dev_b[2] = 2;
      c = dev_b[0] + dev_b[1] + dev_b[2];
    }
    if (thread == 2)
    {
      int dev_b[4];
      dev_b[0] = 0;
      dev_b[1] = 1;
      dev_b[2] = 2;
      dev_b[3] = 3;
      c = dev_b[0] + dev_b[1] + dev_b[2] + dev_b[3];
    }
    printf("c = %d;", c);
  }
}

int main()
{
  float a[THREADS] = { 1, 2, 3, 4, 5 };
  printf("BEFORE START 1\n");
  for(int i = 0; i<THREADS; i++)
  {
    printf("a[%d] = %.2f; ", i, a[i]);
  }
  printf("\nBEFORE END 1\n");
  float *dev_a;
  cudaMalloc((void**)&dev_a, THREADS*sizeof(float));
  cudaMemcpy(dev_a, a, THREADS*sizeof(float), cudaMemcpyHostToDevice);
  testFunction<<<BLOCKS, THREADS>>>(dev_a);
  cudaFree(dev_a);
  printf("\nafter kernel.\n");
  return 0;
}
