#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"

#include <stdio.h>
#include <stdlib.h>

#define THREADS 5
#define BLOCKS 1

__global__ void multiply(float *dev_a)
{
  int thread = threadIdx.x;
  if(thread == 0)
  {
    dev_a[thread] = dev_a[thread]*dev_a[thread];
  }
}

int main()
{
  srand(static_cast<unsigned int>(time(0)));

  Solution s;
  int sparseMatrix[ROWS][COLS];

  for(int a=0;a<ROWS;a++)
  {
    for(int b=0;b<COLS;b++)
    {
      int c = s.getRandom();
      sparseMatrix[a][b] = c;
      printf("c = %d; ", c);
    }
    printf("\n");
  }

  int vector[COLS];
  for(int b=0;b<COLS;b++)
  {
    int d = s.getRandom();
    vector[b] = d;
    printf("d = %d; ", d);
  }
  printf("\n");

  float *dev_sparseMatrix;
  cudaMalloc((void**)&dev_sparseMatrix, ROWS*COLS*sizeof(float));
  cudaMemcpy(dev_sparseMatrix, sparseMatrix, ROWS*COLS*sizeof(float), cudaMemcpyHostToDevice);

  float *dev_vector;
  cudaMalloc((void**)&dev_vector, ROWS*COLS*sizeof(float));
  cudaMemcpy(dev_vector, vector, ROWS*COLS*sizeof(float), cudaMemcpyHostToDevice);

  multiply<<<BLOCKS, THREADS>>>(sparseMatrix, vector);
  
  cudaFree(sparseMatrix);
  cudaFree(vector);

  for(int c=0; c<3; c++)
    printf("columns[0].b[%d] = %d;\n", c, columns[0].b[c]);

  return 0;
}
