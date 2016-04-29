
TARGET= example main


all: $(TARGET)

main: main.o a.o b.o eflags.o
	$(CXX) -o $@ $^

clean:
	$(RM) $(TARGET) *.o core a.out
