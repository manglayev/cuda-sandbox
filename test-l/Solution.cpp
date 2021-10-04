#include "Solution.h"

Solution::Solution(int size)
{
  int array[size];
  setArray(size);
}

void Solution::setArray(int size)
{
    for (int a=0;a<size;a++)
      array[a] = a + a + a*a;
}

int* Solution::getArray()
{
      return array;
}

int Solution::multiply(int a, int b)
{
    return a*b;
}
