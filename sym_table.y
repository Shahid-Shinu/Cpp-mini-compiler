%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include "common.h"
extern char *yytext;
extern int yylineno;
typedef struct symbol_table
{
    char name[31];
    char val[20];
    int line_num;
}ST;
ST st[10000];
int sno = 0;
void insert_to_ST(char *name, char *val,char *type,char *datatype,int line_num);
void print_symbol_table();
%}

%define parse.error verbose
%start S

%union {int num; float dec; char* id;} 

%token T_INCLUDE 
%token T_INT 
%token T_FLOAT 
%token T_CHAR 
%token T_VOID 
%token T_MAIN 
%token T_IF 
%token T_ELSE 
%token T_WHILE 
%token T_BREAK 
%token T_CONTINUE 
%token T_COUT 
%token T_CIN
%token T_ENDL 
%token T_BOOL 
%token T_bool 
%token T_LIB_H 
%token T_STRING 
%token T_lt 
%token T_le 
%token T_gt 
%token T_ge
%token T_eq 
%token T_ee 
%token T_ne 
%token T_inc 
%token T_dec 
%token T_and
%token T_or 
%token T_not 
%token T_comma 
%token T_dot 
%token T_semic 
%token T_dims 
%token T_brackets 
%token T_flow_brackets 
%token T_open_sq 
%token T_close_sq
%token T_add 
%token T_sub 
%token T_mul 
%token T_div 
%token T_mod

%token <num> number
%token <dec> float_num
%token <id> identifier

%left T_lt T_gt
%left T_pl T_min
%left T_mul T_div


%%

S : INCLUDE {printf("\nINPUT ACCEPTED\n");};

INCLUDE : T_INCLUDE T_LIB_H INCLUDE
		| T_INCLUDE T_STRING INCLUDE
		| FUNC_CALLS;

FUNC_CALLS : MAIN
		   | FUNC_DEF FUNC_CALLS;
 
MAIN : T_VOID T_MAIN '{' LINE '}'
	 | T_VOID T_MAIN ';'
	 | TYPE T_MAIN '{' LINE '}' 	
	 | TYPE T_MAIN ';' ;

FUNC_PAR : FUNC_PAR TYPE VAL
		 | FUNC_PAR T_comma
		 | TYPE VAL ;

FUNC_DEF :	T_VOID VAL '(' FUNC_PAR ')' ';'
		 |	T_VOID VAL '(' FUNC_PAR ')' '{' LINE '}'
		 |	TYPE VAL '(' FUNC_PAR ')' ';'
		 |  TYPE VAL '(' FUNC_PAR ')' '{' LINE '}' ;

LINE : LINE STATEMENT ';' 
	 | STATEMENT ';'
	 | LINE IF 
	 | IF
	 | LINE LOOP
	 | LOOP ;

IF : T_IF '(' COND ')' IF_BODY	{insert_to_ST("IF", "NONE" , "key" , "NONE", @1.last_line);}
   | T_IF '(' COND ')' IF_BODY T_ELSE IF_BODY {insert_to_ST("IF", "NONE" , "key" , "NONE", @1.last_line);insert_to_ST("ELSE", "NONE" , "key" , "NONE", @6.last_line);}

IF_BODY : '{' IF_LINE '}'
		| STATEMENT ';' ;

IF_LINE : IF_LINE STATEMENT ';'
		| IF_LINE IF
		| IF_LINE LOOP
		| STATEMENT ';'
		| IF 
		| LOOP;

LOOP : T_WHILE '(' COND ')' LOOP_BODY {insert_to_ST("T_WHILE","NONE" , "key" , "NONE", @1.last_line);};

LOOP_BODY : '{' LOOP_LINE '}'
		  | STATEMENT ';' 
		  | ';' ;

LOOP_LINE : LOOP_LINE STATEMENT ';'
		  | LOOP_LINE LOOP
		  | LOOP_LINE IF
		  | STATEMENT ';'
		  | LOOP
		  | T_BREAK ';'		{insert_to_ST("T_BREAK","NONE" , "key" , "NONE", @1.last_line);}
		  | T_CONTINUE ';'	{insert_to_ST("T_CONTINUE","NONE" , "key" , "NONE", @1.last_line);}
		  | IF;

ARRAY_EXPR	:	ARRAY_EXPR VAL
			|	ARRAY_EXPR T_comma
			|	VAL ;	

ARRAY	: TYPE VAL T_open_sq VAL T_close_sq 
		| TYPE VAL T_dims T_eq '{' ARRAY_EXPR '}'
		| TYPE VAL T_open_sq VAL T_close_sq T_eq '{' ARRAY_EXPR '}';

STATEMENT : PRINT
		  | INPUT
		  | EXP
		  | ASSIGNMENT
		  | DECLARATION 
		  | ARRAY;

PRINT_EXPR : T_lt T_lt T_STRING 
           | T_lt T_lt T_ENDL 
		   | PRINT_EXPR T_lt T_lt T_STRING
		   | PRINT_EXPR T_lt T_lt T_ENDL ;

PRINT : T_COUT PRINT_EXPR

INPUT_EXPR : T_gt T_gt VAL
		   | INPUT_EXPR T_gt T_gt VAL;

INPUT   :	T_CIN INPUT_EXPR ;

EXP : ADD_SUB
	| ADD_SUB INC 
	| INC ADD_SUB;

ADD_SUB : MUL_DIV
		| ADD_SUB T_add MUL_DIV		{insert_to_ST("+","NONE" , "Operator" , "NONE", @1.last_line);}
		| ADD_SUB T_sub MUL_DIV 	{insert_to_ST("-","NONE" , "Operator" , "NONE", @1.last_line);}  ;

MUL_DIV : VAL 
		| MUL_DIV T_mul VAL			{insert_to_ST("*","NONE" , "Operator" , "NONE", @1.last_line);}
		| MUL_DIV T_div VAL 		{insert_to_ST("/","NONE" , "Operator" , "NONE", @1.last_line);} ;

VAL : number						{insert_to_ST("NUM_VAL","NONE" , "LITERAL" , "NONE", @1.last_line);}
	 | identifier ;					 
			

COND : COND OP VAL
	 | COND BOP VAL
	 | UOP VAL
	 | UOP '(' COND ')'
	 | INC VAL
	 | VAL ;

OP : T_ee	{insert_to_ST("==","NONE" , "Cond_op" , "NONE", @1.last_line);}
   | T_ne	{insert_to_ST("!=","NONE" , "Cond_op" , "NONE", @1.last_line);}
   | T_le	{insert_to_ST("<=","NONE" , "Cond_op" , "NONE", @1.last_line);}
   | T_ge	{insert_to_ST(">=","NONE" , "Cond_op" , "NONE", @1.last_line);}
   | T_lt	{insert_to_ST("<","NONE" , "Cond_op" , "NONE", @1.last_line);}
   | T_gt 	{insert_to_ST(">","NONE" , "Cond_op" , "NONE", @1.last_line);};

UOP : T_not {insert_to_ST("!","NONE" , "Operator" , "NONE", @1.last_line);};

INC : T_inc
	| T_dec ;

BOP : T_and	{insert_to_ST("&&","NONE" , "Bin_op" , "NONE", @1.last_line);}
	| T_or {insert_to_ST("||","NONE" , "Bin_op" , "NONE", @1.last_line);}; 

ASSIGNMENT : identifier T_eq EXP;

TYPE : T_INT
	 | T_FLOAT
	 | T_CHAR ;

DECLARATION : TYPE MUL_DEC ;
			
MUL_DEC : identifier T_comma MUL_DEC | identifier | identifier T_eq EXP T_comma MUL_DEC | identifier T_eq EXP;

%%

void yyerror(const char * error){
	printf("%s", error);
}

int main () {
	

	if (yyparse() !=0 )
		printf("\nDidn't Compile");
	print_symbol_table();
	return 0;
}


void insert_to_ST(char *name, char *val,char *type,char *datatype,int line_num){
	if((!strcmp(type , "key")) || 
	(!strcmp(type , "STRING")) || 
	(!strcmp(type, "Operator"))||
	(!strcmp(type, "Bin_op")) ||
	(!strcmp(type, "Cond_op"))){
		strcpy(st[sno].name, name);
		strcpy(st[sno].val, val);
		st[sno].line_num = line_num;
		++sno;
	}
}


void print_symbol_table(){
	for(int i = 0;i < sno ; ++i){
		printf("%s	", st[i].name);
		printf("%s	", st[i].val);
		printf("%d	", st[i].line_num);
		printf("\n");
	}
}