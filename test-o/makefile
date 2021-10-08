NVCC=nvcc
CUDAFLAGS=-arch=sm_60
RM=/bin/rm -f

all: main

main: main.o
	${NVCC} ${CUDAFLAGS} main.o -o main Solution.cpp

main.o: main.cu
		${NVCC} ${CUDAFLAGS} -c main.cu

Solution.o: Solution.cpp
		${NVCC} -c Solution.cpp

clean:
	${RM} *.o main
