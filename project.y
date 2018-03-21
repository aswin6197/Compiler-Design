%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>
	
char t;
int flag = 0;
int nest = 0;
//extern int line;
extern char *temp;
%}




%token	 COMMA  WHILE RETURN  DEFINE INCLUDE PRINTF STRUCT
%token	IF ELSE CB_OPEN CB_CLOSE PLUS MINUS ASTERISK SLASH ASSIGNMENT FOR PERCENT
%token	OR AND NOT LESS LESS_EQUAL MORE_EQUAL MORE EQUAL NOT_EQUAL QUOT KEYWORD    
        

%token NUMBER MAIN
%token LITERAL_C
%token ID
%token CHAR
%token INT
%token FLOAT LONG SHORT SIGNED UNSIGNED


%token STRING

%union { char name[20];
        int value
        }




%left PLUS MINUS
%left ASTERISK SLASH


%union
{
    int     val;
    char    name[100];
}


%type<name> ID idorkey 
%%

program

    :funcdef program 
    
    |globlinit program 

    | program funcdeclaration

    | preprocessor program

    | struct program
    
    |
    ;
globlinit
     : types var_def_list ';'

    | types idorkey ASSIGNMENT expression ';'{
						if(t == 'f') add_datatype(temp,"float",0);
						else if(t == 'i') add_datatype(temp,"int",0);
						else if(t == 'c') add_datatype(temp,"char",0);}
						

    | idorkey ASSIGNMENT expression ';'

    | types array

    | STRUCT idorkey idorkey ';'

    ;

idorkey 
    : ID {char *$$;
		$$ = malloc(strlen($1)*sizeof(char));
		strcpy($$,$1);
	//$$.value = $1;
}
 
    | KEYWORD {printf("\n illegal identifier ");exit(0);} 

    ;


funcdeclaration
    : types idorkey args ';'

    ; 

struct
    : STRUCT idorkey CB_OPEN interior CB_CLOSE ';'

    ;

interior
    :types idorkey ';' interior

    |

    ;

preprocessor
    : '#' DEFINE idorkey NUMBER

    | '#' INCLUDE LESS idorkey '.' idorkey MORE

    | '#' INCLUDE STRING

    ;

funcdef
    : types  idorkey {;lookup($2,1);} args block_statement

    | types MAIN args block_statement

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
    :   types idorkey 

    | idorkey {
			if(t == 'f') add_datatype(temp,"float",nest);
			else if(t == 'i') add_datatype(temp,"int",nest);
			else if(t == 'c') add_datatype(temp,"char",nest); }


    | STRING

    ;

types
    : INT {t = 'i';}

    | CHAR {t = 'c';}

    | FLOAT {t = 'f';}

    | SHORT

    | SIGNED

    | UNSIGNED

    | LONG

    ;

block_statement
    :   CB_OPEN {nest++;} statements CB_CLOSE {scope(nest);nest--;}

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
   : idorkey '[' expression ']' 

   | idorkey '['expression ']' ';' 

   ;

for_loop
    : FOR '('  initialisation  conditions ';' assignment_statement ')' block_statement

    ;

initialisation
    : types var_def_list ';'

    | types idorkey ASSIGNMENT expression ';'{
						if(t == 'f') add_datatype(temp,"float",nest);
						else if(t == 'i') add_datatype(temp,"int",nest);
						else if(t == 'c') add_datatype(temp,"char",nest); }

    | idorkey ASSIGNMENT expression ';'{if(check_scope(temp,flag,nest) == 0)
    										printf("\nvariable %s out of scope",temp);}

    | types array

    | STRUCT idorkey idorkey ';'

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
    :types idorkey ASSIGNMENT char_expression 

    | idorkey ASSIGNMENT char_expression 

    | types idorkey ASSIGNMENT expression {//if(!isdigit($4))
						//printf("\n type mismatch");
					}
 
    | idorkey ASSIGNMENT expression {//if(!isdigit($3))
						//printf("\n type mismatch");
					}

    | idorkey '.' idorkey ASSIGNMENT expression
    
    | types idorkey ASSIGNMENT

    | idorkey PLUS PLUS

    | array ASSIGNMENT expression 

    | error {} 
    ;

ret_statement
    : RETURN expression  

    ;
    
expression
    : NUMBER 

    | idorkey 

    | array  

    | idorkey '.' idorkey

    | expression PLUS expression 

    | expression MINUS expression 

    | expression ASTERISK expression

    | expression SLASH expression 
   
    | expression PERCENT expression

    | '(' expression ')' 
  
    | STRING  

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
	prin();
	return 0;
}
