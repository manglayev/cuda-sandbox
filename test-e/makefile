NVCC=nvcc
CUDAFLAGS=-arch=sm_60
RM=/bin/rm -f

all: main

main: main.o wrapperCaller.o open_acc_map_cuda.o
	${NVCC} ${CUDAFLAGS} main.o wrapperCaller.o open_acc_map_cuda.o -o main

main.o: main.cpp open_acc_map_header.cuh
	gcc -std=c++11 -c main.cpp

wrapperCaller.o: wrapperCaller.cpp open_acc_map_header.cuh
	gcc -std=c++11 -c wrapperCaller.cpp

open_acc_map_cuda.o: open_acc_map_cuda.cu open_acc_map_header.cuh
	${NVCC} ${CUDAFLAGS} -std=c++11 -c -I/usr/lib/x86_64-linux-gnu/openmpi/include -L/usr/lib/x86_64-linux-gnu/openmpi/lib open_acc_map_cuda.cu

clean:
	${RM} *.o main
