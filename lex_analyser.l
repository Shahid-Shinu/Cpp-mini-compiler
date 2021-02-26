%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char *
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;
#include "sym_table.tab.h"
#include "common.h"
%}

%option yylineno

%%
[/][/].*    ;
"/*"[^*]*"*"+([^*/][^*]*"*"+)*"/" ;
[ \t\n]     ;
"using namespace std" {return T_STD;}
"#include"  {return T_INCLUDE;}
"void"      {return T_VOID;}
"int"       {return T_INT;}
"float"     {return T_FLOAT;}
"char"      {return T_CHAR;}
"main()"    {return T_MAIN;}
"if"        {return T_IF;}
"else"      {return T_ELSE;}
"while"     {return T_WHILE;}
"break"     {return T_BREAK;}
"continue"  {return T_CONTINUE;}
"cout"      {return T_COUT;}
"cin"      {return T_CIN;}
"endl"      {return T_ENDL;}
"bool"		{return T_BOOL;}	
"true"|"false" 	{yylval = yytext;return T_bool;}
[0-9]+      {yylval = yytext; return number;}      
[a-zA-Z_][0-9a-zA-Z_]*    {yylval = yytext; return identifier;}
[0-9]+"."[0-9]+           {yylval = yytext; return float_num;}
(<)[a-zA-Z][a-zA-Z]*(>) {yylval = yytext;return T_LIB_H;}
\".*\"      {return T_STRING;}
"+"         {return T_add;}
"-"         {return T_sub;}
"*"         {return T_mul;}
"/"         {return T_div;}
"%"         {return T_mod;}
"<"         {return T_lt;}
"<="        {return T_le;}
">"         {return T_gt;}
">="        {return T_ge;}
"="         {yylval = yytext;return T_eq;}
"=="        {return T_ee;}
"!="        {return T_ne;}
"++" 		{return T_inc;}
"--"		{return T_dec;}
"&&"        {return T_and;}
"||"        {return T_or;}
"!"         {return T_not;}
","         {return T_comma;}
"."         {return T_dot;}
"[]"        {return T_dims;}
"()"        {return T_brackets;}
.           {return yytext[0];}
%%