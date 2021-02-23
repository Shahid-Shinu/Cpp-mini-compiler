%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "common.h"
typedef struct symbol_table
{
    char name[31];
    char *value;
    char type;
    char *datatype;
    int line;
}ST;
ST st[10000];
%}

%define parse.error verbose
%start S

%union {int num; float dec; char id;} 

%token T_INCLUDE T_INT T_FLOAT T_CHAR T_VOID T_MAIN T_IF T_ELSE T_WHILE T_BREAK T_CONTINUE T_COUT T_ENDL T_BOOL T_bool T_LIB_H T_STRING T_lt T_le T_gt T_ge T_eq T_ee T_ne T_inc T_dec T_and T_or T_not T_comma T_dot T_semic T_dims T_brackets T_flow_brackets T_open_sq T_close_sq T_open_flow T_close_flow 

%token T_add T_sub T_mul T_div T_mod

%token <num> number
%token <dec> float_num
%token <id> identifier

%left T_lt T_gt
%left T_pl T_min
%left T_mul T_div


%%

S : START {printf("INPUT ACCEPTED");};

START : T_INCLUDE T_lt T_LIB_H T_gt MAIN {printf("fuck of bitch");};
 

MAIN : T_VOID T_MAIN '{' LINE  '}'
	 | T_VOID T_MAIN ';'
	 | T_INT T_MAIN '{' LINE '}' 
	 | T_INT T_MAIN ';' ;

LINE : LINE STATEMENT ';'
	 | STATEMENT ';'
	 | LINE IF 
	 | IF
	 | LINE LOOP
	 | LOOP ;

IF : T_IF '(' COND ')' IF_BODY 
   | T_IF '(' COND ')' IF_BODY T_ELSE IF_BODY

IF_BODY : '{' IF_LINE '}'
		| STATEMENT ';' ;

IF_LINE : IF_LINE STATEMENT ';'
		| IF_LINE IF
		| IF_LINE LOOP
		| STATEMENT ';'
		| IF 
		| LOOP;

LOOP : T_WHILE '(' COND ')' LOOP_BODY;

LOOP_BODY : '{' LOOP_LINE '}'
		  | STATEMENT ';' 
		  | ';' ;

LOOP_LINE : LOOP_LINE STATEMENT ';'
		  | LOOP_LINE LOOP
		  | LOOP_LINE IF
		  | STATEMENT ';'
		  | LOOP
		  | T_BREAK ';'
		  | T_CONTINUE ';'
		  | IF;

STATEMENT : PRINT
		  | EXP
		  | ASSIGNMENT
		  | DECLARATION
		  | INC ;

PRINT : T_COUT '<''<' T_STRING
	  | T_COUT T_lt T_lt T_STRING T_lt T_lt T_ENDL ;

EXP : ADD_SUB
	| ADD_SUB INC;

ADD_SUB : MUL_DIV
		| ADD_SUB T_add MUL_DIV
		| ADD_SUB T_sub MUL_DIV ;

MUL_DIV : VAL 
		| MUL_DIV T_mul VAL
		| MUL_DIV T_div VAL ;

VAL : number
	 | identifier ;

COND : COND OP VAL
	 | COND BOP VAL
	 | UOP VAL
	 | UOP '(' COND ')'
	 | INC VAL
	 | VAL ;

OP : T_ee
   | T_ne
   | T_le
   | T_ge
   | T_lt
   | T_gt ;

UOP : T_not ;

INC : T_inc
	| T_dec ;

BOP : T_and
	| T_or ;

ASSIGNMENT : TYPE identifier T_eq EXP
		   | identifier T_eq EXP ;


TYPE : T_INT
	 | T_FLOAT
	 | T_CHAR ;

DECLARATION : TYPE MUL_DEC ;
			
MUL_DEC : identifier ',' MUL_DEC | identifier ';' {printf("fuck");};

%%

void yyerror(const char * error){
	printf(error);
}