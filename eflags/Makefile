
TARGET= main

CXXFLAGS=-I./gflags-2.0/src/

all: $(TARGET)

main: main.o proto.o tm.o eflags/eflags.o ./gflags-2.0/.libs/libgflags.a
	$(CXX) -o $@ $^

clean:
	$(RM) $(TARGET) *.o a.out core
