%{
#include <stdio.h>
#include <stdlib.h>
#include "mytable.h"
int line = 1;
int ptr = 0;
%}
keywords auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while
L [a-z|A-Z]
A   [a-zA-Z_0-9]
W [0-9]+
N [1-9]+
F [0-9]+[.][0-9]+[f]?
identifier [a-z][a-z|A-Z|0-9|_]*
strings \"(\\.|[^"\\])*\"
headers #include<[a-z]+.h>
define #define
%%
"\n"					{line++;}
{headers}				{ printf("%s is a header\n", yytext);}
{define}				{ printf("%s is #define\n",yytext);}		
"//"					{ printf("Comment encountered.\n"); }
"/*"([^*]|\*+[^.])*\*+"/"		{ printf("Multi-line comment encountered.\n"); }
"main" 					{ printf("Main encountered\n"); }
"printf("				{ printf("printf encountered\n"); }
"{" 					{ printf("Open bracket encountered\n"); }
"}" 					{ printf("Closed bracket encountered\n"); }
[" "|";"|"\t"|"\n"|"("|")"|","]		{ printf("");}
"["|"]"					{ printf("");}
{keywords}" "{identifier}[(]([a-z|" "|","|"*"|]|"[]")*[)] { printf("%s is a function\n"); }
{strings}					{ printf("%s is a string\n",yytext);}
{keywords}                              { printf("%s is a keyword\n", yytext);
						}
		
{identifier} 				{ insert(yytext);
					  printf("%s Identifier encountered\n",yytext);
					  }
[==|>=|<=|>|<|~|!=]			{ printf("%s is a logical operator\n",yytext);
						}
[=|*|+|\-|/|%|^|&|'|\||/|\\|.]		{ printf("%s is an operator\n",yytext);
						}
{W}|{N} 				{ printf("%s is an Integer constant\n", yytext);
						}
{F} 					{ printf("%s is a float constant\n", yytext);
						}
"NULL"					{ printf("NULL encountered\n"); }
"EOF"					{ printf("EOF encountered\n"); }

<*>.|\n 				{ printf("Error in %s at line %d\n", yytext,line);}
%%

int main(){

	yyin = fopen("comment-error.c","r");
	yylex();
	prin();
	return 0;
}

int yywrap(){
	
	return 1;

}
