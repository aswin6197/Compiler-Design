%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>
	
%}




%token	 COMMA  WHILE RETURN  DEFINE INCLUDE PRINTF STRUCT
%token	IF ELSE CB_OPEN CB_CLOSE PLUS MINUS ASTERISK SLASH ASSIGNMENT FOR PERCENT
%token	OR AND NOT LESS LESS_EQUAL MORE_EQUAL MORE EQUAL NOT_EQUAL QUOT

        
        

%token NUMBER
%token LITERAL_C
%token ID
%token CHAR
%token  INT
%token FLOAT

%token STRING

%union { char * intval;
        char  charval;
        struct symtab *symp;
        //struct exval *test;
        }




%left PLUS MINUS
%left ASTERISK SLASH

 
%%

program
    :program funcdef 

    | funcdef

    | preprocessor program

    | struct program

    |
    ;

struct
    : STRUCT ID CB_OPEN interior CB_CLOSE ';'

    ;

interior
    :types ID ';' interior

    |

    ;

preprocessor
    : '#' DEFINE ID NUMBER

    | '#' INCLUDE LESS ID '.' ID MORE

    | '#' INCLUDE STRING

    ;

funcdef
    : types ID args block_statement

    ;

args
    :  '(' var_def_list ')'

    ;
    
var_def_list
    :var_def COMMA var_def

    |var_def 
    |

    ;

    
var_def
    :   types ID

    | ID

    | STRING

    ;

types
    : INT

    | CHAR

    | FLOAT

    ;

block_statement
    :   CB_OPEN statements CB_CLOSE

    ;

statements
    : statements statement 

    | statement 

    |

    ;

statement
    : block_statement 

    | PRINTF args ';'

    | initialisation  

    | conditional_statement 

    | while_st

    | for_loop

    | assignment_statement ';' 

    | ret_statement ';'

    ;

array
   : ID '[' expression ']' 

   | ID '['expression ']' ';' 

   ;

for_loop
    : FOR '('  initialisation  conditions ';' assignment_statement ')' block_statement

    ;

initialisation
    : types var_def_list ';'

    | types ID ASSIGNMENT expression ';'

    | ID ASSIGNMENT expression ';'

    | types array

    | STRUCT ID ID ';'

    ;
    
conditional_statement
    
    : IF '(' conditions ')' block_statement elsest 

    | IF '(' conditions ')' statement elsest

    ;

elsest
    : ELSE block_statement

    | ELSE statement

    | ELSE  IF '(' conditions ')' block_statement elsest

    | ELSE IF '(' conditions ')' statement elsest

    |

    ;

 while_st 
    : WHILE '(' conditions ')' block_statement 

    ;

conditions 
    : conditions LESS expression 

    | conditions LESS_EQUAL expression 

    | conditions MORE_EQUAL expression 

    | conditions MORE expression 

    | conditions NOT_EQUAL expression 

    | conditions EQUAL expression

    | expression  
   
    ;

assignment_statement
    :types ID ASSIGNMENT char_expression 

    | ID ASSIGNMENT char_expression 

    | types ID ASSIGNMENT expression
 
    | ID ASSIGNMENT expression 

    | ID '.' ID ASSIGNMENT expression
    
    | types ID ASSIGNMENT

    | ID PLUS PLUS

    | array ASSIGNMENT expression 

    | error {} 
    ;

ret_statement
    : RETURN expression  

    ;
    
expression
    : NUMBER 

    | ID 

    | array  

    | ID '.' ID

    | expression PLUS expression 

    | expression MINUS expression 

    | expression ASTERISK expression

    | expression SLASH expression 
   
    | expression PERCENT expression

    | '(' expression ')' 
  
    

    ;


char_expression
    : QUOT LITERAL_C QUOT

	| LITERAL_C

    ;

%%

#include"lex.yy.c"
int yyerror(char *s){
	
    printf(" %d %s  %s ",line,yytext,s);
   exit(0);

}

int main(){
extern FILE *yyin;
	yyin = fopen("abc.txt","r");
	yyparse();
	printf("\n Successful Parsing \n");
	return 0;
}
