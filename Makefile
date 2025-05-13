CC = gcc
AS = as
CFLAGS = -m64 -no-pie
ASFLAGS = --64

all: testPstringFunc

testPstringFunc: testPstringFunc.o pstring.o
	$(CC) $(CFLAGS) -o testPstringFunc testPstringFunc.o pstring.o

testPstringFunc.o: testPstringFunc.c pstring.h
	$(CC) $(CFLAGS) -c testPstringFunc.c

pstring.o: pstring.s
	$(AS) $(ASFLAGS) pstring.s -o pstring.o

clean:
	rm -f *.o testPstringFunc

.PHONY: all clean 