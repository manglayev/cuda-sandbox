#include "header.cuh"

__device__ int deviceFunction(int a)
{
  a = a*a;
  return a;
}
