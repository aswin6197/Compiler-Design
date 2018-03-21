%{
#include <stdio.h>
#include <stdlib.h>
#include "mytable.h"
char *temp;
int line = 1;
int ptr = 0;
%}


keywords break|case|const|continue|default|do|enum|for|goto|register|sizeof|switch|typedef|union|volatile
L [a	-z|A-Z]
UNDER [_]
A   [a-zA-Z_0-9]
W [0-9]+
N [1-9]+
NZ [1-9]
F [0-9]+[.][0-9]+[f]?
identifier [a-z][a-z|A-Z|0-9|_]*
strings \"(\\.|[^"\\])*\"
define #define

%%

{W}                        		{ return NUMBER; }
"long"   				{ return LONG;}
"short"					{ return SHORT;}
"signed"				{ return SIGNED;}
"unsigned"				{ return UNSIGNED;}
{F}                                     { return NUMBER;}
"main"				{return MAIN;}	
{strings}				{ return STRING; }
int					{ return INT; }
"char"					{ return CHAR; }
"float"                                 { return FLOAT;}
"if"					{ return(IF); }
"else"					{ return(ELSE); }
"for"                                   { return FOR;}
"and"                  			{ return(AND); }
"not"                   		{ return(NOT); }
"while"                 		{ return WHILE;}
"return"                		{ return RETURN; }
"or"                    		{ return OR; }  
"define"                		{ return DEFINE;}
"struct"                		{ return (STRUCT);}
"include"                               { return (INCLUDE);}
"printf"                                { return (PRINTF);}
"{"					{ return CB_OPEN; }
"}"					{ return CB_CLOSE; }
"+"					{ return PLUS; }
"-"					{ return MINUS; }
"*"					{ return ASTERISK; }
"/"					{ return SLASH; }
"="					{ return ASSIGNMENT; }
"%"                                     { return PERCENT;}
\<\=					{ return LESS_EQUAL; }
"<"					{ return LESS; }
">="					{ return MORE_EQUAL; }
">"					{ return MORE; }
"=="					{ return EQUAL; }
"!="					{ return NOT_EQUAL; }
","                     		{ return COMMA;}
"'"                     		{ return QUOT;}
{UNDER}{L}*                    		{ return LITERAL_C ; }
{keywords}                              { return KEYWORD;}
{identifier} 				{
					insert(yytext);
					temp = malloc(sizeof(char)*(strlen(yytext)+1));
					strcpy(temp,yytext);						
					return(ID);}
"\n"					{line++;}
"//"					{}
"/*"([^*]|\*+[^.])*\*+"/"		{}
[" "|"\t"]				{}
[~]					{}
[%|^|&|'|\||/|\\]			{}
"NULL"					{}
"EOF"					{}
. 					{ return yytext[0];}
%%



int yywrap(){
	
	return 1;

}
