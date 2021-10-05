#include "Solution.h"

int* Solution::multiply(int sparseMatrix[][COLS], int vector[COLS])
{
  static int result[COLS];
  for(int a=0;a<ROWS;a++)
  {
    for(int b=0;b<COLS;b++)
    {
      if( sparseMatrix[a][b] == 0 || vector[b] == 0 )
        result[a] = result[a] + 0;
      else
        result[a] = result[a] + sparseMatrix[a][b] * vector[b];
    }
  }
  return result;
}
