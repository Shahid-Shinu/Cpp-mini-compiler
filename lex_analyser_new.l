%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char *
#include "sym_table.tab.h"
#include "common.h"
%}


%%
[/][/].*    ;
[ \t\n]     ;
"#include"  {
				return T_INCLUDE;
							}
"void"      {return T_VOID;
				}
				
"int"       {return T_INT;
				}
"float"     {return T_FLOAT;
				}
"char"      {return T_CHAR;
				}
"main()"    {return T_MAIN;
				}
"if"        {return T_IF;
				}
"else"      {return T_ELSE;
				}
"while"     {return T_WHILE;
				}
"break"     {return T_BREAK;
				}
"continue"  {return T_CONTINUE;
				}
"cout"      {return T_COUT;
				}
"endl"      {return T_ENDL;
				}
"bool"		{return T_BOOL;
				}	
"true"|"false" 	{yylval = yytext;
				return T_bool;
				}
[0-9]+      {yylval = yytext; 
			return number;
			}      
[a-zA-Z][0-9a-zA-Z]*    {yylval = yytext; 
				return identifier;
				}
[0-9]+.[0-9]+           {yylval = yytext; 
				return float_num;
				}
[a-zA-Z][0-9a-zA-Z]*"\.h"?  {return T_LIB_H;
				}
\".*\"      {yylval = strdup(yytext);
					return T_STRING;
				}
"+"         {yylval = strdup(yytext);
					return T_add;
				}
"-"         {yylval = strdup(yytext);
						return T_sub;
					}
"*"         {yylval = strdup(yytext);
						return T_mul;
					}
"/"         {yylval = strdup(yytext);
						return T_div;
					}
"%"         {yylval = strdup(yytext);
					return T_mod;
					}
"<"         {yylval = strdup(yytext);
					return T_lt;
					}

"<="        {yylval = strdup(yytext);
					return T_le;
					}
">"         {yylval = strdup(yytext);
					return T_gt;
					}
">="        {yylval = strdup(yytext);
					return T_ge;
					}
"="         {yylval = strdup(yytext);
					return T_eq;
					}
"=="        {yylval = strdup(yytext);
					return T_ee;
					}
"!="        {yylval = strdup(yytext);
					return T_ne;
					}
"++" 		{yylval = strdup(yytext);
					return T_inc;
					}

"--"		{yylval = strdup(yytext);
					return T_dec;
					}
"&&"        {yylval = strdup(yytext);
					return T_and;
					}
"||"        {yylval = strdup(yytext);
					return T_or;
					}
"!"         {yylval = strdup(yytext);
					return T_not;
					}
","         {yylval = strdup(yytext);
					return T_comma;
					}
"."         {yylval = strdup(yytext);
					return T_dot;
					}
;";"			{yylval = strdup(yytext);
					return T_semic;
					}
"[]"        {yylval = strdup(yytext);
					return T_dims;
					}
"()"        {yylval = strdup(yytext);
					return T_brackets;
					}
"{}"        {yylval = strdup(yytext);
					return T_flow_brackets;
					}
"["         {yylval = strdup(yytext);
					return T_open_sq;
					}
"]"         {yylval = strdup(yytext);
					return T_close_sq;
					}
"{"         {yylval = strdup(yytext);
					return T_open_flow;
					}
"}"         {yylval = strdup(yytext);
					return T_close_flow;
					}
.           {yylval = strdup(yytext);
					return yytext[0];
					}
%%