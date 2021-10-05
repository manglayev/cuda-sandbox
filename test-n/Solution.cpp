#include "Solution.h"

int Solution::getRandom()
{
  int r = (-10 + rand() % 20);
  return r;
}
int* Solution::multiply(int sparseMatrix[][COLS], int vector[COLS])
{
  static int result[COLS];
  for(int a=0;a<ROWS;a++)
  {
    for(int b=0;b<COLS;b++)
    {
      printf("sparseMatrix[%d][%d] = %d;\n", a, b, sparseMatrix[a][b]);
      printf("vector[%d] = %d;\n", b, vector[b]);
      if( sparseMatrix[a][b] == 0 || vector[b] == 0 )
        result[a] = result[a] + 0;
      else
        result[a] = result[a] + sparseMatrix[a][b] * vector[b];
    }
      printf("result[%d] = %d;\n", a, result[a]);
  }
  return result;
}
