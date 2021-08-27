RM=/bin/rm -f
VEC4D_FALLBACK=VEC4D_FALLBACK

all: main

main: main.o
	g++ main.o -o main

main.o: main.cpp
	g++ -std=c++11 -D${VEC4D_FALLBACK} -c main.cpp

clean:
	${RM} *.o main
