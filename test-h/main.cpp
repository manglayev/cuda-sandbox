#include <stdio.h>
#include <stdlib.h>

#include "vec.h"
#define CUDASIZE 4

int main()
{
  printf("C++ START\n");
  Veci *c = new Veci[CUDASIZE];
  for (int a = 0; a < CUDASIZE; a++)
  {
    c[a] = a*2;
  }
  for (int a = 0; a < CUDASIZE; a++)
  {
    for (int b = 0; b < CUDASIZE; b++)
    {
      printf("c[%d][%d] = %d; ", a, b, c[a][b]);
    }
    printf("\n");
  }
  printf("\nC++ END\n");
  return 0;
}
