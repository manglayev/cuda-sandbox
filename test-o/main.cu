#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "Solution.h"

#define THREADS 3
#define BLOCKS 3

__global__ void multiply(int *dev_sparseMatrix, int *dev_vector, int *dev_result)
{
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  if(tid == 1)
  {
    for(int a=0;a<BLOCKS;a++)
    {
      for(int b=0;b<THREADS;b++)
      {
        printf("SM[%d][%d] = %d; ", a, b, dev_sparseMatrix[tid]);
      }
      printf("\n");
    }
  }
  if(tid < BLOCKS * THREADS)
  {
    printf("tid = %d;\n", tid);
    if( dev_sparseMatrix[tid] == 0 || dev_vector[threadIdx.x] == 0 )
      dev_result[threadIdx.x] = dev_result[threadIdx.x] + 0;
    else
      dev_result[threadIdx.x] = dev_result[threadIdx.x] + dev_sparseMatrix[tid] * dev_vector[threadIdx.x];
  }
}

int main()
{
  srand(static_cast<unsigned int>(time(0)));

  Solution s;
  int sparseMatrix[BLOCKS][THREADS];
  printf("CPU START\n");
  for(int a=0;a<BLOCKS;a++)
  {
    for(int b=0;b<THREADS;b++)
    {
      sparseMatrix[a][b] = s.getRandom();
      printf("SM[%d][%d] = %d; ", a, b, sparseMatrix[a][b]);
    }
    printf("\n");
  }

  int vector[THREADS];
  int result[THREADS];
  for(int a=0;a<THREADS;a++)
  {
    result[a] = 0;
    vector[a] = s.getRandom();
    printf("vector[%d] = %d; ", a, vector[a]);
  }
  printf("\n");
  printf("CPU END\n");
  int *dev_sparseMatrix;
  cudaMalloc((void**)&dev_sparseMatrix, BLOCKS*THREADS*sizeof(int));
  cudaMemcpy(dev_sparseMatrix, sparseMatrix, BLOCKS*THREADS*sizeof(int), cudaMemcpyHostToDevice);

  int *dev_vector;
  cudaMalloc((void**)&dev_vector, BLOCKS*sizeof(int));
  cudaMemcpy(dev_vector, vector, BLOCKS*sizeof(int), cudaMemcpyHostToDevice);

  int *dev_result;
  cudaMalloc((void**)&dev_result, THREADS*sizeof(int));
  printf("GPU START\n");
  multiply<<<BLOCKS, THREADS>>>(dev_sparseMatrix, dev_vector, dev_result);
  printf("GPU END\n");
  cudaMemcpy(result, dev_result, THREADS*sizeof(int), cudaMemcpyDeviceToHost);

  for(int c=0; c<3; c++)
    printf("result[%d] = %d;\n", c, result[c]);

  cudaFree(sparseMatrix);
  cudaFree(vector);
  cudaFree(dev_result);

  return 0;
}
