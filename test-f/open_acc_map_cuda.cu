#include "cuda_header.cuh"
#include "open_acc_map_header.cuh"
#include "vec.h"
#include "device_launch_parameters.h"
#include "cuda.h"
#include <cuda_runtime.h>
#include <utility>
#include <type_traits>
#include <stdio.h>
#include <stdlib.h>

__global__ void cuda_global(int *dev_a)
{
  int i = threadIdx.x;
  if (i == 0)
  {
    printf("CUDA START\n");
    Veci *c = new Veci[CUDASIZE];
    const Veci i_indices = Veci(0, 1, 2, 3);
    for (int d = 0; d < CUDASIZE; d++)
    {
      printf("i_indices[%d] = %d; ", d, i_indices[d]);
    }
    printf("\n");
    /*
    for (int a = 0; a < CUDASIZE; a++)
    {
      for (int b = 0; b < CUDASIZE; b++)
      {
        printf("c[%d][%d] = %d; ", a, b, c[a][b]);
      }
      printf("\n");
    }
    */
    printf("CUDA END\n");
  }
}
void wrapper()
{
  int *a = new int[CUDASIZE];
  int *dev_a;
  cudaMalloc((void**)&dev_a, CUDASIZE*sizeof(int));
  cudaMemcpy(dev_a, a, CUDASIZE*sizeof(int), cudaMemcpyHostToDevice);
  const Veci i_indices = Veci(0, 1, 2, 3);
  printf("C++ START\n");
  for (int d = 0; d < CUDASIZE; d++)
  {
    printf("i_indices[%d] = %d; ", d, i_indices[d]);
  }
  printf("\n");
  /*
  Veci *c = new Veci[CUDASIZE];
  for (int a = 0; a < CUDASIZE; a++)
  {
    c[a] = a*3;
  }
  for (int a = 0; a < CUDASIZE; a++)
  {
    for (int b = 0; b < CUDASIZE; b++)
    {
      printf("c[%d][%d] = %d; ", a, b, c[a][b]);
    }
    printf("\n");
  }
  */
  printf("C++ END\n");
  cuda_global<<<BLOCKS, THREADS>>>(dev_a);

  cudaMemcpy(a, dev_a, CUDASIZE*sizeof(int), cudaMemcpyDeviceToHost);
  cudaFree(dev_a);
  printf("CUDA END\n");
}
