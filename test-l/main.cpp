#include "Solution.h"

int main()
{
  Solution s;
  int sparseMatrix[ROWS][COLS] = { {1, 0, -1}, {2, 0, 0}, {0, -1, 0} };
  int vector[COLS] = {-1, 1, 2};

  int* result = s.multiply(sparseMatrix, vector);

  for(int a=0;a<COLS;a++)
    printf("result[%d] = %d; ", a, result[a]);
  printf("\n");
  return 0;
}
