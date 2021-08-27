#include "open_acc_map_header.cuh"
#include <stdio.h>
#include <stdlib.h>

void wrapperCaller(int b)
{
  printf("STAGE 2\n");
  printf("b = %d\n", b);
  wrapper(b);
}
