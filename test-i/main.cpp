#include <stdio.h>
#include <stdlib.h>
#include <algorithm>

#include "cplm.hpp"

#define VECL 8
#define WID 4
#define i_pcolumnv(j, k, k_block, num_k_blocks) ( ((j) / ( VECL / WID)) * WID * ( num_k_blocks + 2) + (k) + ( k_block + 1 ) * WID )

int main()
{
  int a[2]{3, 4};
  int v[2];
  int j = 2;
  int k = 1;
  int vco = 6;
  float minValue = 4.3;
  float nblocks = 5.1;
  float r1 = i_pcolumnv(j, 0, -1, nblocks);
  compute_plm_coeff_2(v+vco, k, a, minValue);
  return 0;
}
