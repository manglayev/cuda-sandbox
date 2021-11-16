#include "header.cuh"

__device__ int deviceFunction(int a, face_estimate_order order)
{
  switch(order)
  {
    case h4:
    a = a+a;
    break;
    case h5:
    a = a+a+a;
    break;
    default:
    a = a+a+a;
    break;
  }
  return a;
}
