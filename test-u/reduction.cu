#include <stdio.h>
#include <stdlib.h>

#define ROWS 3
#define COLUMNS 4
/*
simple reduction.
Summing elements of each row in m by n matrix.
*/
__global__ void reduction_cuda(float * d_out, const float * d_in)
{
  int tid = threadIdx.x+blockDim.x*blockIdx.x;

  if(tid<ROWS)
  {
    for(int i=0; i<COLUMNS; i++)
    {
      d_out[tid] = d_out[tid] + d_in[i+COLUMNS*tid];
    }
  }
}

int main()
{
    float array[ROWS][COLUMNS];
    for (int a=0; a<ROWS; a++)
    {
      for (int b=0; b<COLUMNS; b++)
      {
        array[a][b] = b+a*COLUMNS;
        printf("array[%d][%d] = %.2f; ", a, b, array[a][b]);
      }
    printf("\n");
    }
    printf("\n");
    float *d_in;
    cudaMalloc((void**)&d_in,  COLUMNS*ROWS*sizeof(float));
    cudaMemcpy(d_in, array, COLUMNS*ROWS*sizeof(float), cudaMemcpyHostToDevice);
    float *d_out;
    cudaMalloc((void**)&d_out, ROWS*sizeof(float));
    reduction_cuda << < ROWS, COLUMNS >> >(d_out, d_in);

    float *out;
    out = (float *)malloc(ROWS*sizeof(float));
    cudaMemcpy(out, d_out,ROWS*sizeof(float), cudaMemcpyDeviceToHost);
    printf("\n");
    for(int c=0; c<ROWS; c++)
    {
      printf("c[%d] = %.2f; ", c, out[c]);
    }
    printf("\n");
    cudaFree(d_in);
    cudaFree(d_out);
    return 0;
}
