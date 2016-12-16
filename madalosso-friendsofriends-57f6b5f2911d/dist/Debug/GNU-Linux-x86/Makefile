ifeq ($(OS),Windows_NT)
    #Windows stuff
    CFLAGS=-fopenmp -O3 -g -std=gnu++11
else
    #Linux stuff
    CFLAGS=-fopenmp -O3 -g -std=c++11
endif

CC=g++

program: FoF02Original2.cpp grupo.cpp grupo.h;
	$(CC) FoF02Original2.cpp grupo.cpp -o FoF03 $(CFLAGS) $(CFLAGS0) $(CFLAGS1) $(CFLAGS2) $(CFLAGS3)
