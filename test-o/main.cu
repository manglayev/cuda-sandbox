#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "Solution.h"

#define THREADS 3
#define BLOCKS 3

__global__ void multiply(int *dev_sparseMatrix, int *dev_vector, int *dev_result)
{
  /*
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

  while(tid < BLOCKS * THREADS)
  {
    temp += dev_sparseMatrix[tid] * dev_vector[threadIdx.x];
    tid += blockIdx.x * gridDim.x;
  }
  cacheResult[threadIdx.x] = temp;
  */
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  //__shared__ int cacheResult[THREADS];
  //int temp = 0;
  if(tid < BLOCKS * THREADS)
  {
    //printf("tid = %d;\n", tid);
    if( dev_sparseMatrix[tid] != 0 && dev_vector[threadIdx.x] != 0 )
      dev_sparseMatrix[tid] = dev_sparseMatrix[tid] * dev_vector[threadIdx.x];
      //printf("dev_sparseMatrix[%d] = %d;\n", tid, dev_sparseMatrix[tid]);
  }
  __syncthreads();
  if(threadIdx.x < THREADS)
  {
    int i = 0;
    //printf("threadIdx.x = %d;\n", threadIdx.x);
    //printf("blockIdx.x = %d;\n", blockIdx.x);
    //printf("blockDim.x = %d;\n", blockDim.x);
    /*
    while(i < THREADS)
    {
      //dev_result[threadIdx.x] = dev_result[threadIdx.x] + dev_sparseMatrix[i+blockIdx.x*blockDim.x];
      //printf("i = %d; i+blockIdx.x*blockDim.x = %d\n", i, i+blockIdx.x*blockDim.x);
      //dev_result[threadIdx.x] = dev_result[threadIdx.x] + dev_sparseMatrix[i+blockIdx.x*blockDim.x];
      dev_sparseMatrix[i+blockIdx.x*blockDim.x] = dev_sparseMatrix[blockIdx.x*blockDim.x] + dev_sparseMatrix[i+blockIdx.x*blockDim.x];
      i++;
      __syncthreads();
      //printf("i = %d; dev_result[threadIdx.x] = %d;\n", i, dev_result[threadIdx.x]);
    }
    //__syncthreads();
    */
  }
  int cacheIndex = threadIdx.x;
  dev_result[cacheIndex] = temp;
  int i = blockDim.x/3;
  while(i!=0)
  {
    if(cacheIndex < i)
      dev_sparseMatrix[cacheIndex] += dev_sparseMatrix[cacheIndex+i];
    __syncthreads();
    i/=3;
  }
  if(tid<2)
  {
    if(threadIdx.x == 0)
    {
      dev_result[tid] = dev_sparseMatrix[threadIdx.x];
    }
  }

  //if(threadIdx.x < THREADS)
  //{
  //  dev_result[threadIdx.x] = cacheResult[threadIdx.x];
  //}
  /*
  if(tid < BLOCKS * THREADS)
  {
    printf("tid = %d;\n", tid);
    if( dev_sparseMatrix[tid] == 0 || dev_vector[threadIdx.x] == 0 )
      dev_result[threadIdx.x] = dev_result[threadIdx.x] + 0;
    else
      dev_result[threadIdx.x] = dev_result[threadIdx.x] + dev_sparseMatrix[tid] * dev_vector[threadIdx.x];
    __syncthreads();
  }
  */
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
  multiply<<<BLOCKS, THREADS>>>(dev_sparseMatrix, dev_vector, dev_result);
  cudaMemcpy(result, dev_result, THREADS*sizeof(int), cudaMemcpyDeviceToHost);
  cudaMemcpy(sparseMatrix, dev_sparseMatrix, THREADS*sizeof(int), cudaMemcpyDeviceToHost);
  for(int c=0; c<3; c++)
    printf("result[%d] = %d;\n", c, result[c]);

  for(int a=0; a<3; a++)
  {
    for(int b=0; b<3; b++)
    {
        printf("C SM[%d][%d] = %d; ", a, b, sparseMatrix[a][b]);
    }
    printf("\n");
  }
  cudaFree(sparseMatrix);
  cudaFree(vector);
  cudaFree(dev_result);

  return 0;
}
