#include <stdio.h>
#include <stdlib.h>
#include "Solution.h"

using namespace std;

int main()
{
  const int size=3;
  Solution solution(size);
  solution.setArray(size);
  int *array = solution.getArray();
  for (int b=0;b<size;b++)
    printf("filledArray[%d] = %d\n", b, array[b]);
  /*
    int a = 3;
    int b = 5;
    printf("c = %d\n", s.multiply(a, b));
  */
  return 0;
}
