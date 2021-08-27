#include "open_acc_map_header.cuh"
#include "device_launch_parameters.h"
#include "cuda.h"
#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits>
#include <mpi.h>

#define NPP_MAXABS_64F ( 1.7976931348623158e+308 )
#define NPP_MINABS_64F ( 2.2250738585072014e-308 )
#define NPP_MAXABS_32F ( 3.402823466e+38f )
#define NPP_MINABS_32F ( 1.175494351e-38f )
#define VECL 8
#define WID 4
#define i_pcolumnv_cuda(j, k, k_block, num_k_blocks) ( ((j) / ( VECL / WID)) * WID * ( num_k_blocks + 2) + (k) + ( k_block + 1 ) * WID )
void fillArray(float *b);
using namespace std;
__device__ int slope_limiter_sb_1(int &l, int &m, int &r)
{
  int a = r-m;
  int b = m+l;
  printf("a = %d; b = %d; max = %d;\n", a, b, max(a, b));
  return max(a,b);
}
__device__ int slope_limiter_1(int &l,int &m,int &r)
{
   return slope_limiter_sb_1(l,m,r);
}
__device__ void compute_plm_coeff_1(int *values, int k, int a[2], float threshold)
{
  // scale values closer to 1 for more accurate slope limiter calculation
  float scale = 1./threshold;
  int v_1 = values[k - 1] * threshold;
  int v_2 = values[k] * threshold;
  int v_3 = values[k + 1] * threshold;
  //int d_cv = (v_1+v_2+v_3)*threshold;
  int d_cv = slope_limiter_1(v_1, v_2, v_3) * threshold;
  //int d_cv = slope_limiter_1(values[k-1]*scale, values[k]*scale, values[k+1]*scale)*threshold;
  printf("values[%d] = %d; d_cv = %d\n", k, values[k], d_cv);
  a[0] = values[k] - d_cv * 0.5;
  a[1] = d_cv * 0.5;
}
/*____________________________________________________________________________*/
__device__ int slope_limiter_sb_2(int &l, int &m, int &r)
{
  int a = r-m;
  int b = m+l;
  printf("a = %d; b = %d; max = %d;\n", a, b, max(a, b));
  return max(a,b);
}
__device__ int slope_limiter_2(int &l)
{
    return 2;
    //return slope_limiter_sb_2(l,m,r);
}
__device__ void compute_plm_coeff_2(int *values, int k, int a[2], float threshold)
{
  //scale values closer to 1 for more accurate slope limiter calculation
  float scale = 1./threshold;
  int v_1 = values[k - 1] * scale;
  int v_2 = values[k] * scale;
  int v_3 = values[k + 1] * scale;
  //int d_cv = (v_1+v_2+v_3)*threshold;
  //int d_cv = slope_limiter(v_1, v_2, v_3) * threshold;
  int d_cv = slope_limiter_2(v_1);
  printf("values[%d] = %d; d_cv = %d\n", k, values[k], d_cv);
  a[0] = values[k] - d_cv * 0.5;
  a[1] = d_cv * 0.5;
}
/*____________________________________________________________________________*/
__global__ void cudaFunction(float *b)
{
  int index = threadIdx.x + blockIdx.x*blockDim.x;
  if(index == 0)
  {
    //float *a = &b[index];
    //printf( "size of a = %ld;\n", sizeof(*a) );
    //a[index+1] = CUDASIZE*CUDASIZE - index;
    int a[2];
    int j = 2;
    int k = 1;
    float minValue = 4.3;
    float nblocks = 5.1;
    float r1 = i_pcolumnv_cuda(j, 0, -1, nblocks);
    int *v = new int[2];
    v[0] = 10;
    v[1] = 20;
    v[2] = 30;
    compute_plm_coeff_2(v, k, a, minValue);
    for(int aa = 0; aa < 2; aa++)
    {
      printf("a[%d] = %d\n", aa, a[aa]);
    }
  }
}
void wrapper()
{
  float *b = new float[CUDASIZE];
  fillArray(b);
  float *dev_b;
  cudaMalloc((void**)&dev_b, CUDASIZE*sizeof(float));
	cudaMemcpy(dev_b, b, CUDASIZE*sizeof(float), cudaMemcpyHostToDevice);
  cudaFunction<<<BLOCKS, THREADS>>>(dev_b);
  cudaMemcpy(b, dev_b, CUDASIZE*sizeof(float), cudaMemcpyDeviceToHost);
  cudaFree(dev_b);
  /*
  double maxD = NPP_MAXABS_64F;
  double minD = NPP_MINABS_64F;

  double maxF = NPP_MAXABS_32F;
  double minF = NPP_MINABS_32F;

  double maxDV = std::numeric_limits<double>::max();
  double minDV = std::numeric_limits<double>::min();

  float maxFV = std::numeric_limits<float>::max();
  float minFV = std::numeric_limits<float>::min();

  printf("size of float = %ld\n", sizeof(float));
  printf("size of double = %ld\n", sizeof(double));

  if(maxD > maxDV)
    printf("maxD > maxDV");
  else if(maxD < maxDV)
    printf("maxD < maxDV");
  else
    printf("maxD = maxDV");
    printf("\n");
  if(minD > minDV)
    printf("minD > minDV");
  else if(minD < minDV)
    printf("minD < minDV");
  else
    printf("minD = minDV");
    printf("\n");
  */
}//end wrapper function

void fillArray(float *b)
{
  for(int a=0; a<CUDASIZE; a++)
  {
    b[a] = b[a] + CUDASIZE-a;
  }
}
