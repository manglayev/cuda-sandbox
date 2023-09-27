#include <stdio.h>
#include <stdlib.h>

#define ROWS_A 2
#define COLUMNS_A_ROWS_B 3
//#define ROWS_B 3
#define COLUMNS_B 4
/*
Matrix multiplication
Simple parallel axb to bxc matrix multiplication
*/
__global__ void reduction_cuda(float * in_a, float * in_b, float * d_out)
{
  /*
  int tid_1 = threadIdx.x+blockDim.x*blockIdx.x;
  int tid_2 = threadIdx.x+blockDim.x*blockIdx.x;
  int tid_3 = threadIdx.x+blockDim.x*blockIdx.x;
  */
  int tid = threadIdx.x+blockDim.x*blockIdx.x;

  if (tid<ROWS_A)
  {
    if(tid<COLUMNS_B)
    {
      printf("tid = %d\n", tid);
      //printf("tid_1 = %d; tid_3 = %d\n", tid_1, tid_3);
    }
    //for(int i=0; i<COLUMNS_A_ROWS_B; i++)
    {
      //printf("integer division in GPU: %d / %d = %d;\n", tid_1, COLUMNS_A_ROWS_B, tid_1 / COLUMNS_A_ROWS_B);
      //d_out[tid_2] = d_out[tid_2] + in_a[(tid_1 / COLUMNS_A_ROWS_B)*COLUMNS_A_ROWS_B+i]*in_b[(i*COLUMNS_B)+tid_3];
    }
  }
}

int main()
{
    float array_1[ROWS_A][COLUMNS_A_ROWS_B];
    for (int a=0; a<ROWS_A; a++)
    {
      for (int b=0; b<COLUMNS_A_ROWS_B; b++)
      {
        array_1[a][b] = 1+a+b*COLUMNS_A_ROWS_B;
        printf("array_1[%d][%d] = %.2f; ", a, b, array_1[a][b]);
      }
    printf("\n");
    }
    printf("\n");
    float array_2[COLUMNS_A_ROWS_B][COLUMNS_B];
    for (int a=0; a<COLUMNS_A_ROWS_B; a++)
    {
      for (int b=0; b<COLUMNS_B; b++)
      {
        array_2[a][b] = 1+a+b*COLUMNS_B;
        printf("array_2[%d][%d] = %.2f; ", a, b, array_2[a][b]);
      }
    printf("\n");
    }
    printf("\n");

    float *in_a;
    cudaMalloc((void**)&in_a,  ROWS_A*COLUMNS_A_ROWS_B*sizeof(float));
    cudaMemcpy(in_a, array_1, ROWS_A*COLUMNS_A_ROWS_B*sizeof(float), cudaMemcpyHostToDevice);

    float *in_b;
    cudaMalloc((void**)&in_b,  COLUMNS_A_ROWS_B*COLUMNS_B*sizeof(float));
    cudaMemcpy(in_b, array_2, COLUMNS_A_ROWS_B*COLUMNS_B*sizeof(float), cudaMemcpyHostToDevice);

    float *d_out;
    cudaMalloc((void**)&d_out, ROWS_A*COLUMNS_B*sizeof(float));
    reduction_cuda << < ROWS_A, COLUMNS_B >> >(in_a, in_b, d_out);

    float out[ROWS_A][COLUMNS_B];

    for (int a=0; a<ROWS_A; a++)
    {
      for (int b=0; b<COLUMNS_B; b++)
      {
        out[a][b] = 100;
      }
    }

    cudaMemcpy(out, d_out, ROWS_A*COLUMNS_B*sizeof(float), cudaMemcpyDeviceToHost);

    for (int a=0; a<ROWS_A; a++)
    {
      for (int b=0; b<COLUMNS_B; b++)
      {
    //    printf("out[%d][%d] = %.2f; ", a, b, out[a][b]);
      }
    printf("\n");
    }
    printf("\n");

    cudaFree(in_a);
    cudaFree(in_b);
    cudaFree(d_out);

    return 0;
}
