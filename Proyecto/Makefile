a.out: ansic.tab.o main.o lex.yy.o 	
	gcc main.o lex.yy.o ansic.tab.o 

main.o:main.c
	gcc -c main.c

lex.yy.o:lex.yy.c
	gcc -c lex.yy.c

ansic.tab.o: ansic.tab.c
	gcc -c ansic.tab.c

lex.yy.c: ansic.l
	flex ansic.l

ansic.tab.c: ansic.y
	bison -d ansic.y

clean:
	rm -f a.out main.o lex.yy.o ansic.tab.o lex.yy.c ansic.tab.c ansic.tab.h

run:a.out
	./a.out