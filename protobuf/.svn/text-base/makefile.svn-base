
SHELL=bash

CFLAGS= -Wall -O3 -I../include/
CPPFLAGS= -Wall -O3

TAEGET= c_pack cpp_pack 

all:$(TAEGET)

dyn_encode: dyn_encode.o 
	$(CXX) -static -o $@ $^ -lprotobuf -lpthread

c_pack: c_pack.o addressbook.pb-c.o 
	$(CC) -o $@ $^ -lprotobuf-c

c_pack.o: c_pack.c addressbook.pb-c.h 
	$(CC) $(CFLAGS) -c $< 

cpp_pack: cpp_pack.o addressbook.pb.o 
	$(CXX) -o $@ $^ -lprotobuf 

cpp_pack.o: cpp_pack.cpp addressbook.pb.h 
	$(CXX) $(CPPFLAGS) -c $< 

%.pb-c.h %.pb-c.c :%.proto
	protoc-c --c_out=. $?

%.pb.h %.pb.cc :%.proto
	protoc --cpp_out=. $?

test: cpp_pack c_pack
	time ./c_pack 100000
	time ./cpp_pack 100000

clean:
	$(RM) $(TAEGET) *.o *.pb.cc *.pb.h *.pb-c.c *.pb-c.h
	$(RM) -r CMakeCache.txt CMakeFiles cmake_install.cmake Makefile
