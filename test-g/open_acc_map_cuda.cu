#include "open_acc_map_h.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include "cuda_runtime.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define HANDLE_ERROR( err ) (HandleError( err, __FILE__, __LINE__ ));
static void HandleError( cudaError_t err, const char *file, int line )
{
    if (err != cudaSuccess)
    {
        printf( "%s in %s at line %d\n", cudaGetErrorString( err ), file, line );
        exit( EXIT_FAILURE );
    }
}
__global__ void cudaFunction(int *b)
{
  int index = threadIdx.x;
  //printf("CUDA [%d]: \n", index);
  if (index<CUDASIZE)
  {
    b[index] = b[index]+CUDASIZE;
  }
}
void cudaFunctionCallerWrapper(int a_1)
{
  printf("a_1: %d\n", a_1);
  int b[CUDASIZE];
  int *dev_b;
  HANDLE_ERROR( cudaMalloc((void**)&dev_b, CUDASIZE * sizeof(int)) );
  for(int a=0; a<CUDASIZE; a++)
  {
    b[a] = a_1-a;
  }
  printf("before: b = %d\n", b[CUDASIZE-1]);
	cudaMemcpy(dev_b, b, CUDASIZE*sizeof(int), cudaMemcpyHostToDevice);
  cudaFunction<<<BLOCKS, THREADS>>>(dev_b);
  cudaMemcpy(b, dev_b, CUDASIZE*sizeof(int), cudaMemcpyDeviceToHost);
  printf("after: b = %d\n", b[CUDASIZE-1]);
  cudaFree(dev_b);
}

int main(void)
{
  printf("Hello World\n");
  int a = 1000;
  cudaFunctionCallerWrapper(a);
  return 0;
}
