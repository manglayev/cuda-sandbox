#include <stdio.h>
#include <stdlib.h>

#define N 3
/*
  Matrix multiplication
  Simple parallel nxn to nxn matrix multiplication
*/
__global__ void matrixMultiplication(int * in_a, int * in_b, int * out_c)
{
  int index = threadIdx.x+blockDim.x*blockIdx.x;

  if(index < N*N)
  {
    for(int i=0; i<N; i++)
    {
      out_c[index] = out_c[index] + in_a[i+N*index/N] * in_b[index + N*i];
    }
  }
  /*
  int tid_1 = threadIdx.x+blockDim.x*blockIdx.x;
  int tid_2 = threadIdx.x+blockDim.x*blockIdx.x;
  int tid_3 = threadIdx.x+blockDim.x*blockIdx.x;
  if (tid<N)
  {
      //printf("tid = %d\n", tid);
      //printf("tid_1 = %d; tid_3 = %d\n", tid_1, tid_3);
      //for(int i=0; i<COLUMNS_A_ROWS_B; i++)
      //printf("integer division in GPU: %d / %d = %d;\n", tid_1, COLUMNS_A_ROWS_B, tid_1 / COLUMNS_A_ROWS_B);
      //d_out[tid_2] = d_out[tid_2] + in_a[(tid_1 / COLUMNS_A_ROWS_B)*COLUMNS_A_ROWS_B+i]*in_b[(i*COLUMNS_B)+tid_3];
  }
    */
}

int main()
{
    int array_1[N][N];
    for (int a=0; a<N; a++)
    {
      for (int b=0; b<N; b++)
      {
        array_1[a][b] = a+b;
        printf("array_1[%d][%d] = %d; ", a, b, array_1[a][b]);
      }
      printf("\n");
    }
    printf("\n");
    int array_2[N][N];
    for (int a=0; a<N; a++)
    {
      for (int b=0; b<N; b++)
      {
        array_2[a][b] = a+b;
        printf("array_2[%d][%d] = %d; ", a, b, array_2[a][b]);
      }
      printf("\n");
    }
    printf("\n");

    int *in_a;
    cudaMalloc((void **)&in_a,  N*N*sizeof(int));
    cudaMemcpy(in_a, array_1, N*N*sizeof(int), cudaMemcpyHostToDevice);

    int *in_b;
    cudaMalloc((void **)&in_b,  N*N*sizeof(int));
    cudaMemcpy(in_b, array_2, N*N*sizeof(int), cudaMemcpyHostToDevice);

    int *out_c;
    cudaMalloc((void **)&out_c, N*N*sizeof(int));
    matrixMultiplication <<< N, N >>>(in_a, in_b, out_c);
    cudaDeviceSynchronize();
    int out[N][N];
    for (int a=0; a<N; a++)
    {
      for (int b=0; b<N; b++)
      {
        out[a][b] = 1;
      }
    }
    cudaMemcpy(out, out_c, N*N*sizeof(int), cudaMemcpyDeviceToHost);
    printf("RESULT MATRIX:\n");
    for (int a=0; a<N; a++)
    {
      for (int b=0; b<N; b++)
      {
        printf("out[%d][%d] = %d; ", a, b, out[a][b]);
      }
      printf("\n");
    }
    printf("\n");

    cudaFree(in_a);
    cudaFree(in_b);
    cudaFree(out_c);

    return 0;
}
