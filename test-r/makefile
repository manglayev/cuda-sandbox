NVCC=nvcc
CUDAFLAGS=-arch=sm_60
RM=/bin/rm -f

all: main

main: main.o
	${NVCC} ${CUDAFLAGS} main.o device.o -o main

main.o: main.cu header.cuh
		${NVCC} ${CUDAFLAGS} -c main.cu

device.o: device.cu header.cuh
		${NVCC} ${CUDAFLAGS} -c device.cu

clean:
	${RM} *.o main
