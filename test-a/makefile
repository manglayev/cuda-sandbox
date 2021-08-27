NVCC=nvcc
CUDAFLAGS=-arch=sm_60
RM=/bin/rm -f

all: main

main: main.o wrapperCaller.o open_acc_map_cuda.o
	g++ main.o wrapperCaller.o open_acc_map_cuda.o -o main -L/usr/local/cuda/lib64 -lcuda -lcudart

main.o: main.cpp open_acc_map_header.cuh
	g++ -std=c++11 -c main.cpp

wrapperCaller.o: wrapperCaller.cpp open_acc_map_header.cuh
	g++ -std=c++11 -c wrapperCaller.cpp

open_acc_map_cuda.o: open_acc_map_cuda.cu open_acc_map_header.cuh
	${NVCC} ${CUDAFLAGS} -std=c++11 -c open_acc_map_cuda.cu

clean:
	${RM} *.o main
