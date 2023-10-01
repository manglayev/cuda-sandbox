#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"

#include <stdio.h>
#include <stdlib.h>

#define THREADS 5
#define BLOCKS 1

struct Column
{
  int a;
  int b[3];
};

__global__ void testFunction(float *dev_a)
{
  int thread = threadIdx.x;
  if(thread == 0)
  {
    dev_a[thread] = dev_a[thread]*dev_a[thread];
  }
}

int main()
{
  Column* columns = new Column[2];
  columns[0] = { 0, {1, 2, 3} };
  columns[1] = { 0, {4, 5, 6} };

  float a[THREADS] = { 1, 2, 3, 4, 5 };
  printf("BEFORE START 1\n");
  for(int i = 0; i<THREADS; i++)
    printf("a[%d] = %.2f; ", i, a[i]);
  printf("\nBEFORE END 2\n");
  float *dev_a;
  cudaMalloc((void**)&dev_a, THREADS*sizeof(float));
  cudaMemcpy(dev_a, a, THREADS*sizeof(float), cudaMemcpyHostToDevice);
  testFunction<<<BLOCKS, THREADS>>>(dev_a);
  cudaFree(dev_a);

  for(int c=0; c<3; c++)
    printf("columns[0].b[%d] = %d;\n", c, columns[0].b[c]);

    delete [] columns->Column::b;

  return 0;
}
