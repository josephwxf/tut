LANG=

CC = gcc
AR = ar
STRIP = strip

YACC = bison -d -v
LEX = flex

#CFLAGS = -Wall -Wstrict-prototypes -DLINUX 

CFLAGS = -Wall -Wextra -Wstrict-prototypes -DLINUX 
LDFALGS =  -lreadline -ltermcap

Q=@

%.c: %.l
	$(LEX) -o $@ $^

%.c: %.y
	$(YACC) $^
	mv parser.tab.c $@


%.o:%.c
	$(CC) $(CFLAGS) -c -o $@ $<	


app = optiwaycli

all: yy $(app)

yy: $(objs) #cli.h

objs = parser.o lexer.o cli.o readline.o lookup.o ahelp.o regex.o

optiwaycli: $(objs)  
	$(CC) $^ $(LDFALGS) -o $@
	$(STRIP) $@
	
include py_gen.mk

clean:
	@rm -f parser.output parser.tab.h parser.c lexer.c 
	@rm -f *.o *.pyc
	@rm -f $(app) $(objs) 
distclean:clean
	@rm -f parser.y lookup.c ahelp.c
