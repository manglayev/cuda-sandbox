COMPILER=gcc
CUDAFLAGS=-arch=sm_60
RM=/bin/rm -f

all: main

main: main.o File.o
	${COMPILER} main.o File.o -o main

main.o: main.cpp Header.h
	${COMPILER} -std=c++11 -c main.cpp

File.o: File.cpp Header.h
	${COMPILER} -std=c++11 -c File.cpp

clean:
	${RM} *.o main
