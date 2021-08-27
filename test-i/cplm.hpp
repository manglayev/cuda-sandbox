#include <iostream>
#include "algorithm"
#include "math.h"
#include "csl.hpp"
using namespace std;
void compute_plm_coeff_2(const int *values, int k, int a[2], const float threshold)
{
  float scale = 1./threshold;
  int v_1 = values[k - 1] * scale;
  int v_2 = values[k] * scale;
  int v_3 = values[k + 1] * scale;
  //int d_cv = slope_limiter_2(v_1, v_2, v_3)*threshold;
  int d_cv = slope_limiter_2(values[k-1]*scale, values[k]*scale, values[k+1]*scale)*threshold;
  printf("values[%d] = %d; d_cv = %d; scale = %.2f;\n", k, values[k], d_cv, scale);
  a[0] = values[k] - d_cv * 0.5;
  a[1] = d_cv * 0.5;
}
