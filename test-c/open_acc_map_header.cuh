#include <stdio.h>
#include <stdlib.h>

#define DIMS 1
#define BLOCKS 4
#define THREADS 32
#define CUDASIZE 8

extern void wrapperCaller(int b);
extern void wrapper(int c);
