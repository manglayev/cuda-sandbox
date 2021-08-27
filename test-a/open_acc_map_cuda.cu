#include "open_acc_map_header.cuh"
#include "device_launch_parameters.h"
#include "cuda.h"

#include <cuda_runtime.h>
#include <utility>
#include <type_traits>
#include <stdio.h>
#include <stdlib.h>

#include "Vec4Simple.cu"

__global__ void cuda_global(int *dev_a, int *dev_b, int *dev_c)
{
  int i = threadIdx.x;
  if (i < CUDASIZE)
  {
    dev_c[i] = cuda_device_2(dev_a[i], dev_b[i]);
  }
}
void wrapper(int z)
{
  printf("STAGE 3\n");
  printf("z = %d\n", z);

  int a[CUDASIZE] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
  int b[CUDASIZE] = {11, 21, 31, 41, 51, 61, 71, 81, 91, 101};
  //int c[CUDASIZE];
  int c[CUDASIZE];

  int *dev_a;
  int *dev_b;
  //int *dev_c;

  int *dev_c;

  cudaMalloc((void**)&dev_a, CUDASIZE*sizeof(int));
  cudaMalloc((void**)&dev_b, CUDASIZE*sizeof(int));
  //cudaMalloc((void**)&dev_c, CUDASIZE*sizeof(int));
  cudaMalloc((void**)&dev_c, CUDASIZE*sizeof(int));

  cudaMemcpy(dev_a, a, CUDASIZE*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(dev_b, b, CUDASIZE*sizeof(int), cudaMemcpyHostToDevice);

  cuda_global<<<BLOCKS, THREADS>>>(dev_a, dev_b, dev_c);

  cudaMemcpy(c, dev_c, CUDASIZE*sizeof(int), cudaMemcpyDeviceToHost);
  //printf("after: c = %d\n", c[CUDASIZE-3]);
  printf("after: c = %d\n", 2021);

  cudaFree(dev_a);
  cudaFree(dev_b);
  cudaFree(dev_c);
}
