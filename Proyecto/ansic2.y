%{
	#include <stdio.h>
	#include <stdlib.h>

	void yyerror(char *mensaje){
		printf("ERROR: %s\n", mensaje);
		exit(0);
	}
%}

%union
{
	char *valor;
}

%token IDENTIFICADOR CONSTANTE LITERAL_CADENA SIZEOF
%token OP_PTR OP_INC OP_DEC OP_IZQ OP_DER OP_MENIG OP_MAYIG OP_IGUAL OP_DIF
%token OP_AND OP_OR ASIGNACION_MUL ASIGNACION_DIV ASIGNACION_MOD ASIGNACION_SUM
%token ASIGNACION_RES ASIGNACION_IZQ ASIGNACION_DER ASIGNACION_AND
%token ASIGNACION_XOR ASIGNACION_OR 

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN


%start unidad_traduccion
%%

expresion_primaria
	: IDENTIFICADOR 
	| CONSTANTE 	
	| LITERAL_CADENA 
	| '(' expresion ')' 
	;

expresion_postfija
	: expresion_primaria 
	| expresion_postfija '[' expresion ']'	
	| expresion_postfija '(' ')' 			
	| expresion_postfija '(' lista_expresiones_argumentos ')'		
	| expresion_postfija '.' IDENTIFICADOR    	
	| expresion_postfija OP_PTR IDENTIFICADOR   
	| expresion_postfija OP_INC	
	| expresion_postfija OP_DEC	
	;

lista_expresiones_argumentos
	: expresion_asignacion 
	| lista_expresiones_argumentos ',' expresion_asignacion	
	;

expresion_unaria
	: expresion_postfija	
	| OP_INC expresion_unaria	
	| OP_DEC expresion_unaria	
	| operador_unario expresion_cast 	
	| SIZEOF expresion_unaria 	
	| SIZEOF '(' nombre_tipo ')'	
	;

operador_unario
	: '&'	
	| '*'	
	| '+'	
	| '-'	
	| '~'	
	| '!'	
	;

expresion_cast
	: expresion_unaria 
	| '(' nombre_tipo ')' expresion_cast 
	;

expresion_multiplicativa
	: expresion_cast 	
	| expresion_multiplicativa '*' expresion_cast 	
	| expresion_multiplicativa '/' expresion_cast 	
	| expresion_multiplicativa '%' expresion_cast 	
	;

expresion_aditiva
	: expresion_multiplicativa 
	| expresion_aditiva '+' expresion_multiplicativa 	
	| expresion_aditiva '-' expresion_multiplicativa 	
	;

expresion_cambio
	: expresion_aditiva 	
	| expresion_cambio OP_IZQ expresion_aditiva 	
	| expresion_cambio OP_DER expresion_aditiva 	
	;

expresion_relacional
	: expresion_cambio 	
	| expresion_relacional '<' expresion_cambio 	
	| expresion_relacional '>' expresion_cambio 	
	| expresion_relacional OP_MENIG expresion_cambio 	
	| expresion_relacional OP_MAYIG expresion_cambio 	
	;

expresion_igualdad
	: expresion_relacional 	
	| expresion_igualdad OP_IGUAL expresion_relacional 	
	| expresion_igualdad OP_DIF expresion_relacional 	
	;

expresion_and
	: expresion_igualdad 	
	| expresion_and '&' expresion_igualdad 	
	;

expresion_or_exclusivo
	: expresion_and 
	| expresion_or_exclusivo '^' expresion_and 	
	;

expresion_or_inclusivo
	: expresion_or_exclusivo 
	| expresion_or_inclusivo '|' expresion_or_exclusivo 
	;

expresion_logica_and
	: expresion_or_inclusivo 	
	| expresion_logica_and OP_AND expresion_or_inclusivo 	
	;

expresion_logica_or
	: expresion_logica_and 	
	| expresion_logica_or OP_OR expresion_logica_and 	
	;

expresion_condicional
	: expresion_logica_or 	
	| expresion_logica_or '?' expresion ':' expresion_condicional 	
	;

expresion_asignacion
	: expresion_condicional 	
	| expresion_unaria operador_asignacion expresion_asignacion 
	;

operador_asignacion
	: '=' 
	| ASIGNACION_MUL 	
	| ASIGNACION_DIV 	
	| ASIGNACION_MOD 	
	| ASIGNACION_SUM 	
	| ASIGNACION_RES 	
	| ASIGNACION_IZQ 	
	| ASIGNACION_DER 	
	| ASIGNACION_AND 	
	| ASIGNACION_XOR 	
	| ASIGNACION_OR 	
	;

expresion
	: expresion_asignacion 	
	| expresion ',' expresion_asignacion 	
	;

expresion_constante
	: expresion_condicional 	
	;

declaracion
	: especificador_declaracion ';' 	
	| especificador_declaracion lista_declaradores_inicializacion ';' 	
	;

especificador_declaracion
	: especificador_clase_almacenamiento 	
	| especificador_clase_almacenamiento especificador_declaracion 	
	| especificador_tipo 	 
	| especificador_tipo especificador_declaracion 	
	| calificador_tipo 	
	| calificador_tipo especificador_declaracion 	
	;

lista_declaradores_inicializacion
	: declarador_inicializacion 	
	| lista_declaradores_inicializacion ',' declarador_inicializacion 
	;

declarador_inicializacion
	: declarador 	
	| declarador '=' inicializador 		
	;

especificador_clase_almacenamiento
	: TYPEDEF 	
	| EXTERN 	
	| STATIC 	
	| AUTO 		
	| REGISTER 	
	;

especificador_tipo
	: VOID 		
	| CHAR 		
	| SHORT 	
	| INT 		
	| LONG 		
	| FLOAT 	
	| DOUBLE 	
	| SIGNED 	
	| UNSIGNED 	
	| especificador_estructura_o_union 		
	| especificador_enum 		
	;

especificador_estructura_o_union
	: estructura_o_union IDENTIFICADOR '{' lista_declaraciones_estructura '}' 	
	| estructura_o_union '{' lista_declaraciones_estructura '}' 	
	| estructura_o_union IDENTIFICADOR 		
	;

estructura_o_union
	: STRUCT 	
	| UNION 	
	;
 
lista_declaraciones_estructura
	: declaracion_estructura 	
	| lista_declaraciones_estructura declaracion_estructura 	
	;

declaracion_estructura
	: lista_calificadores_especificador lista_declaradores_estructura ';' 
	;

lista_calificadores_especificador
	: especificador_tipo lista_calificadores_especificador 		
	| especificador_tipo 	
	| calificador_tipo lista_calificadores_especificador 		
	| calificador_tipo 		
	;

lista_declaradores_estructura
	: declarador_estructura 
	| lista_declaradores_estructura ',' declarador_estructura 
	;

declarador_estructura
	: declarador 	
	| ':' expresion_constante 		
	| declarador ':' expresion_constante 		
	;

especificador_enum
	: ENUM '{' lista_enumeradores '}' 
	| ENUM IDENTIFICADOR '{' lista_enumeradores '}' 	
	| ENUM IDENTIFICADOR 	
	;

lista_enumeradores
	: enumerador 	
	| lista_enumeradores ',' enumerador 	
	;

enumerador
	: IDENTIFICADOR 
	| IDENTIFICADOR '=' expresion_constante 		

calificador_tipo
	: CONST 		
	| VOLATILE 		
	;

declarador
	: puntero declarador_directo 	
	| declarador_directo 	
	;

declarador_directo
	: IDENTIFICADOR 	
	| '(' declarador ')' 			 					
	| declarador_directo '[' expresion_constante ']'		
	| declarador_directo '[' ']' 			
	| declarador_directo '(' lista_parametros_tipo ')' 					
	| declarador_directo '(' lista_identificadores ')' 			
	| declarador_directo '(' ')' 			
	;

puntero
	: '*' 		
	| '*' lista_calificadores_tipo 			
	| '*' puntero  		
	| '*' lista_calificadores_tipo puntero 		
	;

lista_calificadores_tipo
	: calificador_tipo  		
	| lista_calificadores_tipo calificador_tipo  		
	;


lista_parametros_tipo
	: lista_parametros  		
	| lista_parametros ',' ELLIPSIS  		
	;

lista_parametros
	: declaracion_parametro  		
	| lista_parametros ',' declaracion_parametro  		
	;

declaracion_parametro
	: especificador_declaracion declarador 				
	| especificador_declaracion declarador_abstracto 	
	| especificador_declaracion 		
	;

lista_identificadores
	: IDENTIFICADOR  		
	| lista_identificadores ',' IDENTIFICADOR  			
	;

nombre_tipo
	: lista_calificadores_especificador 		
	| lista_calificadores_especificador declarador_abstracto 		
	;

declarador_abstracto
	: puntero 	 	
	| declarador_abstracto_directo  	
	| puntero declarador_abstracto_directo  		
	;

declarador_abstracto_directo
	: '(' declarador_abstracto ')'  		 		
	| '[' ']'  			
	| '[' expresion_constante ']' 					
	| declarador_abstracto_directo '[' ']' 			
	| declarador_abstracto_directo '[' expresion_constante ']' 		 
	| '(' ')' 			
	| '(' lista_parametros_tipo ')' 			
	| declarador_abstracto_directo '(' ')' 		
	| declarador_abstracto_directo '(' lista_parametros_tipo ')' 		
	;

inicializador
	: expresion_asignacion 
	| '{' lista_inicializadores '}' 
	| '{' lista_inicializadores ',' '}'			
	;

lista_inicializadores
	: inicializador  		
	| lista_inicializadores ',' inicializador 
	;

afirmacion
	: afirmacion_etiquetada 
	| afirmacion_compuesta 	
	| afirmacion_expresion 	
	| afirmacion_seleccion 	
	| afirmacion_iteracion 	
	| afirmacion_salto 		
	;

afirmacion_etiquetada
	: IDENTIFICADOR ':' afirmacion 		
	| CASE expresion_constante ':' afirmacion 		
	| DEFAULT ':' afirmacion  			
	;

afirmacion_compuesta
	: '{' '}'
	| '{' lista_afirmaciones '}' 		
	| '{' lista_declaraciones '}' 		
	| '{' lista_declaraciones lista_afirmaciones '}' 
	;

lista_declaraciones
	: declaracion 		
	| lista_declaraciones declaracion 		
	;

lista_afirmaciones
	: afirmacion 		
	| lista_afirmaciones afirmacion 		
	;

afirmacion_expresion
	: ';' 
	| expresion ';' 					
	;

afirmacion_seleccion
	: IF '(' expresion ')' afirmacion 			
	| IF '(' expresion ')' afirmacion ELSE afirmacion 		
	| SWITCH '(' expresion ')' afirmacion 		
	;

afirmacion_iteracion
	: WHILE '(' expresion ')' afirmacion 				
	| DO afirmacion WHILE '(' expresion ')' ';' 		
	| FOR '(' afirmacion_expresion afirmacion_expresion ')' afirmacion 			
	| FOR '(' afirmacion_expresion afirmacion_expresion expresion ')' afirmacion 		
	;

afirmacion_salto
	: GOTO IDENTIFICADOR ';' 	
	| CONTINUE ';'				
	| BREAK ';'					
	| RETURN ';' 				
	| RETURN expresion ';'		
	;

unidad_traduccion
	: declaracion_externa 		
	| unidad_traduccion declaracion_externa 	
	;

declaracion_externa
	: definicion_funcion 		
	| declaracion 				
	;

definicion_funcion
	: especificador_declaracion declarador lista_declaraciones afirmacion_compuesta 
	| especificador_declaracion declarador afirmacion_compuesta 
	| declarador lista_declaraciones afirmacion_compuesta 
	| declarador afirmacion_compuesta 
	;

%%
