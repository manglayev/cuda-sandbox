#include <stdio.h>
#include <stdlib.h>

#define N 4
/*
  Matrix multiplication
  Simple parallel nxn to nxn matrix multiplication
*/
__global__ void matrixMultiplication(int *in_a, int *in_b, int *out_c)
{
  int index = threadIdx.x+blockDim.x*blockIdx.x;

  if(index < N*N)
  {
    for(int i=0; i<N; i++)
    {
      out_c[index] = out_c[index] + in_a[i+(index/N)*N] * in_b[index-(index/N)*N+N*i];
    }
  }
}

int main()
{
    int *in_a, *in_b, *out_c;;
    cudaMallocManaged(&in_a,  N*N*sizeof(int));
    cudaMallocManaged(&in_b,  N*N*sizeof(int));
    cudaMallocManaged(&out_c, N*N*sizeof(int));
    for (int a=0; a<N*N; a++)
    {
        in_a[a] = a;
        in_b[a] = a;
    }
    for (int a=0; a<N; a++)
    {
      for (int b=0; b<N; b++)
      {
        printf("in_a[%d][%d] = %d; ", a, b, in_a[a*N+b]);
      }
      printf("\n");
    }
    printf("\n");
    for (int a=0; a<N; a++)
    {
      for (int b=0; b<N; b++)
      {
        printf("in_b[%d][%d] = %d; ", a, b, in_b[a*N+b]);
      }
      printf("\n");
    }
    printf("\n");
    matrixMultiplication <<< N, N >>>(in_a, in_b, out_c);
    cudaDeviceSynchronize();
    printf("RESULT MATRIX:\n");
    for (int a=0; a<N; a++)
    {
      for (int b=0; b<N; b++)
      {
        printf("out_c[%d][%d] = %d; ", a, b, out_c[b+a*N]);
      }
      printf("\n");
    }
    printf("\n");

    cudaFree(in_a);
    cudaFree(in_b);
    cudaFree(out_c);

    return 0;
}
