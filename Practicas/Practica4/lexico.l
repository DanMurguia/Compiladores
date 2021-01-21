
D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include <stdio.h>

%}

%%
"/*"												{ printf("<inicio de comentario>"); }

"auto"|"typedef"|"static"|"extern"|"register"		{ printf("<especificador de tipo>"); }
"break"|"if"|"else"|"switch"						{ printf("<sentencia de control>"); }
"do"|"while"|"for"									{ printf("<ciclo>"); }
"char"|"double"|"float"|"int"|"enum"|"void"			{ printf("<Tipo de dato>"); }
"const"|"volatile"									{ printf("<calificador de tipo>"); }
"short"|"long"|"signed"|"unsigned"					{ printf("<modificador de tipo>"); }
"continue"|"goto"									{ printf("<salto de seccion>"); }
"default"|"case"|"return"							{ printf("<palabra reservada>"); }
"sizeof"											{ printf("<operador>"); }
"struct"|"union"									{ printf("<estructura>"); }

{L}({L}|{D})*										{ printf("<identificador>"); }

0[xX]{H}+{IS}?										{ printf("<literal entera base hexadecimal>"); }
0{D}+{IS}?											{ printf("<literal entera base octal>"); }
{D}+{IS}?											{ printf("<literal entera base decimal>"); }
L?'(\\.|[^\\'])+'									{ printf("<literal caracter>"); }

{D}+{E}{FS}?										{ printf("<literal numerica exponencial>"); }
{D}*"."{D}+({E})?{FS}?								{ printf("<literal numerica real exponencial>"); }
{D}+"."{D}*({E})?{FS}?								{ printf("<literal numerica real exponencial>"); }

L?\"(\\.|[^\\"])*\"									{ printf("<literal de cadena>"); }

"<"|">"|"=="|"<="|">="|"!="							{ printf("<operador relacional>"); }
"&&"|"||"											{ printf("<operador logico>"); }
"&"|"|"|"^"|"~"|">>"|"<<"|"!"						{ printf("<operador logico bit a bit>"); }
"++"												{ printf("<operador de incremento>"); }
"--"												{ printf("<operador de decremento>"); }
"|="												{ printf("<asignacion or>"); }
"..."												{ printf("<elipsis>"); }
">>="												{ printf("<asignacion derecha>"); }
"<<="												{ printf("<asignacion izquierda>"); }
"+="												{ printf("<asignacion de suma>"); }
"-="												{ printf("<asignacion de resta>"); }
"*="												{ printf("<asignacion de multiplicacion>"); }
"/="												{ printf("<asignacion de division>"); }
"%="												{ printf("<asignacion de modulo>"); }
"&="												{ printf("<asignacion and>"); }	
"^="												{ printf("<asignacion de xor>"); }
"->"|"."											{ printf("<operador de puntero>"); }
"+"|"-"|"*"|"/"|"%"									{ printf("<operador aritmetico>"); }
";"|","|("{"|"<%")|("}"|"%>")						{ printf("<separador>"); }
"?"|":"												{ printf("<operador condicional>"); }
"="													{ printf("<asignacion>"); }
"("|")"|("["|"<:")|("]"|":>")						{ printf("<agrupacion>"); }
[ \t\v\n\f]											{ printf(" ");}
.													{ /* ignore bad characters */ }

%%

yywrap()
{
	return(1);
}