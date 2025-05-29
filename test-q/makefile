NVCC=nvcc
CUDAFLAGS=-arch=sm_60
CUDAFLAGS += -DACC_SEMILAG_PPM
RM=/bin/rm -f

all: main

main: main.o device.o
	${NVCC} ${CUDAFLAGS} main.o device.o -o main

main.o: main.cu
	${NVCC} ${CUDAFLAGS} -dc main.cu

device.o: device.cu
	${NVCC} ${CUDAFLAGS} -dc device.cu

clean:
	${RM} *.o main
