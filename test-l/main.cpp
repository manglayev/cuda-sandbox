#include <stdio.h>
#include <stdlib.h>
#include "Solution.h"

using namespace std;

int main()
{
  Solution s;
  int a = 3;
  int b = 5;
  int sparseMatrix[3][3] = { {1, 0, -1}, {2, 0, 0}, {0, -1, 0} };
  int vector[3] = {-1, 1, 2};
  printf("c = %d\n", s.multiply(a, b, sparseMatrix));
  return 0;
}
