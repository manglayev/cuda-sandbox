#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits>
using namespace std;
#define NPP_MAXABS_32F ( 3.402823466e+38f )
#define NPP_MINABS_32F ( 1.175494351e-38f )

#define NPP_MAXABS_64F ( 1.7976931348623158e+308 )
#define NPP_MINABS_64F ( 2.2250738585072014e-308 )

#define THREADS 5
#define BLOCKS 10

typedef double apple;
typedef float orange;

__global__ void testFunction(float *dev_a, float *dev_b, orange *dev_c)
{
  int thread = threadIdx.x;
  if(thread < THREADS)
  {
    if(thread < NPP_MAXABS_32F)
      dev_a[thread] = NPP_MAXABS_32F;
    else
      dev_a[thread] = NPP_MINABS_32F;
    if (thread == 4)
    {
      dev_a[thread] = *dev_b;
      *dev_b = dev_a[thread]*2;
      dev_a[thread-1] = *dev_c;
      *dev_c = dev_a[thread-1]*3;
    }
  }
}

int main()
{
  printf("\nMAIN START\n");
  float a[THREADS] = { 1, 2, 3, 4, 5 };
  printf("BEFORE LOOP\n");
  for(int i = 0; i<THREADS; i++)
  {
    printf("a[%d] = %.2f; ", i, a[i]);
  }
  printf("AFTER LOOP\n");
  float *dev_a;
  cudaMalloc((void**)&dev_a, THREADS*sizeof(float));
  cudaMemcpy(dev_a, a, THREADS*sizeof(float), cudaMemcpyHostToDevice);

  float b = 25;
  float *dev_b;
  cudaMalloc((void**)&dev_b, sizeof(float));
  cudaMemcpy(dev_b, &b, sizeof(float), cudaMemcpyHostToDevice);

  orange c = 77;
  orange *dev_c;
  cudaMalloc((void**)&dev_c, sizeof(orange));
  cudaMemcpy(dev_c, &c, sizeof(orange), cudaMemcpyHostToDevice);

  testFunction<<<BLOCKS, THREADS>>>(dev_a, dev_b, dev_c);

  cudaMemcpy(a, dev_a, THREADS*sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(&b, dev_b, sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(&c, dev_c, sizeof(orange), cudaMemcpyDeviceToHost);

  cudaFree(dev_a);
  cudaFree(dev_b);
  cudaFree(dev_c);

  printf("\nAFTER CUDA FREE\n");
  for(int i = 0; i<THREADS; i++)
  {
    printf("a[%d] = %.2f; ", i, a[i]);
  }
  printf("\nEND\n");
  printf("b = %.2f; \n", b);
  printf("c = %.2f; \n", c);

  orange d = 12.3;
  apple e = 23.4;
  printf("d = %.2f\ne = %.2f\n", d, e);
  printf("MAX: %.2f\n", NPP_MAXABS_32F);
  printf("MAX FLOAT: %.2f\n", numeric_limits<float>::max());
  printf("MAX DOUBLE: %.2f\n", numeric_limits<double>::max());

  return 0;
}
