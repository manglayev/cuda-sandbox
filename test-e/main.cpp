#include "open_acc_map_header.cuh"
#include <stdio.h>
#include <stdlib.h>
#include <algorithm>
#define VECL 8
#define WID 4
#define i_pcolumnv(j, k, k_block, num_k_blocks) ( ((j) / ( VECL / WID)) * WID * ( num_k_blocks + 2) + (k) + ( k_block + 1 ) * WID )
void compute_plm_coeff_2(int *values, int k, int a[2], float threshold);

int main()
{
  //printf("STAGE 1\n");
  wrapperCaller();
  return 0;
}
