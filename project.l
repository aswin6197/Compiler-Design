%{
#include <stdio.h>
#include <stdlib.h>
#include "mytable.h"

int line = 1;
int ptr = 0;
%}


keywords auto|break|case|const|continue|default|do|double|enum|extern|float|for|goto|long|register|short|signed|sizeof|static|switch|typedef|union|unsigned|void|volatile
L [a-z|A-Z]
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

{W}                        {            return NUMBER; }

int					{ return INT; }
"char"					{ return CHAR; }
"if"					{ return(IF); }
"else"					{ return(ELSE); }
"for"                                   { return FOR;}
"and"                   { return(AND); }
"not"                   { return(NOT); }
"while"                 { return WHILE;}
"return"                { return RETURN; }
"or"                    { return(OR); }  
"define"                { return(DEFINE);}
"struct"                { return (STRUCT);}
"include"                               {   return (INCLUDE);}
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
","                     { return COMMA;}
"'"                     {return QUOT;}

{UNDER}{L}*                    { return LITERAL_C ; }

{keywords}                              { printf("%s is a keyword\n", yytext);}

{identifier} 			{ //yylval.b = yytext; 
                       
                        return(ID); }


"\n"					{line++;}

	
"//"					{ printf("Comment encountered.\n"); }
"/*"([^*]|\*+[^.])*\*+"/"		{ printf("Multi-line comment encountered.\n"); }


[" "|"\t"]		{ printf("");}

{strings}					{ return STRING;}

		
[~]			{ printf("%s is a logical operator\n",yytext);
						}
[%|^|&|'|\||/|\\]		{ printf("%s is an operator\n",yytext);
						}
 				
{F} 					{ printf("%s is a float constant\n", yytext);
						}
"NULL"					{ printf("NULL encountered\n"); }
"EOF"					{ printf("EOF encountered\n"); }

. 				{ return yytext[0];printf("Error in %s at line %d\n", yytext,line);}
%%



int yywrap(){
	
	return 1;

}
