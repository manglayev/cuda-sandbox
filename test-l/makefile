compiler=gcc
RM=/bin/rm -f

all: main

main: main.o
	${compiler} main.o -o main Solution.cpp

main.o: main.cpp
	${compiler} -c main.cpp

Solution.o: Solution.cpp
	${compiler} -c Solution.cpp

clean:
	${RM} *.o main
