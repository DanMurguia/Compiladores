a.out: ansic2.tab.o main.o lex.yy.o 	
	gcc main.o lex.yy.o ansic2.tab.o 

main.o:main.c
	gcc -c main.c

lex.yy.o:lex.yy.c
	gcc -c lex.yy.c

ansic2.tab.o: ansic2.tab.c
	gcc -c ansic2.tab.c

lex.yy.c: ansic.l
	flex ansic.l

ansic2.tab.c: ansic2.y
	bison -d ansic2.y

clean:
	rm -f a.out main.o lex.yy.o ansic2.tab.o lex.yy.c ansic2.tab.c ansic2.tab.h

run:a.out
	./a.out