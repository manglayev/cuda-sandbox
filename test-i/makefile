NVCC=nvcc
CUDAFLAGS=-arch=sm_60
RM=/bin/rm -f

all: main

main: main.o
	g++ -std=c++17 main.o -o main

main.o: main.cpp
	g++ -std=c++17 -c main.cpp

clean:
	${RM} *.o main
