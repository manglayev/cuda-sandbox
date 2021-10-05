#include "Solution.h"

int main()
{
  Solution s;
  int sparseMatrix[ROWS][COLS];
  srand(static_cast<unsigned int>(time(0)));
  for(int a=0;a<ROWS;a++)
  {
    for(int b=0;b<COLS;b++)
    {
      int c = s.getRandom();
      sparseMatrix[a][b] = c;
      printf("c = %d; ", c);
    }
    printf("\n");
  }

  //int sparseMatrix[ROWS][COLS] = { {1, 0, -1}, {2, 0, 0}, {0, -1, 0} };
  int vector[COLS];
  for(int b=0;b<COLS;b++)
  {
    int d = s.getRandom();
    vector[b] = d;
    printf("d = %d; ", d);
  }
  printf("\n");

  int* result = s.multiply(sparseMatrix, vector);

  for(int a=0;a<COLS;a++)
    printf("result[%d] = %d;\n", a, result[a]);
  return 0;
}
