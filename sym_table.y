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

%union {int num; float dec; char id;} 

%token T_INCLUDE T_INT T_FLOAT T_CHAR T_VOID T_MAIN T_IF T_ELSE T_WHILE T_BREAK T_CONTINUE T_COUT T_ENDL T_BOOL T_bool T_LIB_H T_STRING T_lt T_le T_gt T_ge T_eq T_ee T_ne T_inc T_dec T_and T_or T_not T_comma T_dot T_semic T_dims T_brackets T_flow_brackets T_open_sq T_close_sq 

%token T_add T_sub T_mul T_div T_mod

%token <num> number
%token <dec> float_num
%token <id> identifier

%left T_lt T_gt
%left T_pl T_min
%left T_mul T_div


%%

S : INCLUDE {printf("\nINPUT ACCEPTED\n");};

INCLUDE : T_INCLUDE T_LIB_H INCLUDE {insert_to_ST("T_INCLUDE","NONE" , "key" , "NONE", @1.last_line);}
	    | T_INCLUDE T_STRING MAIN {insert_to_ST("T_INCLUDE", "NONE" , "key" , "NONE", @1.last_line);}
		| MAIN ;
 
MAIN : T_VOID T_MAIN '{' LINE  '}'  {insert_to_ST("T_VOID","NONE","key","NONE",@1.last_line);insert_to_ST("T_MAIN","NONE","key","NONE",@2.last_line);}
	 | T_VOID T_MAIN ';'			{insert_to_ST("T_VOID","NONE","key","NONE",@1.last_line);insert_to_ST("T_MAIN","NONE","key","NONE",@2.last_line);}
	 | T_INT T_MAIN '{' LINE '}' 	{insert_to_ST("T_INT","NONE","key","NONE",@1.last_line);insert_to_ST("T_MAIN","NONE","key","NONE",@2.last_line);}
	 | T_INT T_MAIN ';'			{insert_to_ST("T_INT","NONE","key","NONE",@1.last_line);insert_to_ST("T_MAIN","NONE","key","NONE",@2.last_line);} ;

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

STATEMENT : PRINT
		  | EXP
		  | ASSIGNMENT
		  | DECLARATION ;

PRINT : T_COUT T_lt T_lt T_STRING	{insert_to_ST("T_COUT","NONE" , "key" , "NONE", @1.last_line); insert_to_ST("STRING","NONE" , "STRING" , "string", @4.last_line);}
	  | T_COUT T_lt T_lt T_STRING T_lt T_lt T_ENDL {insert_to_ST("T_COUT","NONE" , "key" , "NONE", @1.last_line); insert_to_ST("STRING","NONE" , "STRING" , "string", @4.last_line);};

EXP : ADD_SUB
	| ADD_SUB INC
	| INC ADD_SUB;

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

ASSIGNMENT : identifier T_eq VAL;

TYPE : T_INT
	 | T_FLOAT
	 | T_CHAR ;

DECLARATION : TYPE MUL_DEC ;
			
MUL_DEC : identifier T_comma MUL_DEC | identifier | identifier T_eq EXP T_comma MUL_DEC | identifier T_eq EXP;

%%

void yyerror(const char * error){
	printf(error);
}

int main () {
	

	if (yyparse() !=0 )
		printf("\nDidn't Compile");
	print_symbol_table();
	return 0;
}


void insert_to_ST(char *name, char *val,char *type,char *datatype,int line_num){
	if(!strcmp(type , "key")){
		strcpy(st[sno].name, name);
		strcpy(st[sno].val, val);
		st[sno].line_num = line_num;
		++sno;
	}
	else if(!strcmp(type , "STRING")){
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