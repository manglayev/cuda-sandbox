NVCC=nvcc
CUDAFLAGS=-arch=sm_60
RM=/bin/rm -f

all: reduction

reduction: reduction.o
	${NVCC} ${CUDAFLAGS} reduction.o -o reduction

reduction.o: reduction.cu
		${NVCC} ${CUDAFLAGS} -c reduction.cu

clean:
	${RM} *.o reduction
