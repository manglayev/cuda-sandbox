#include "open_acc_map_header.cuh"
#include <stdio.h>
#include <stdlib.h>

int main()
{
  printf("STAGE 1 START1\n");
  int a = 1000;
  printf("a = %d\n", a);
  wrapperCaller(a);
  printf("STAGE 1 END\n");
  return 0;
}
