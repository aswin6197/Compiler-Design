%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

	
char t;
int flag = 0;
int nest = 0;
extern int line;
extern char *temp;
extern char num[10];
int temp_var = 0;

char *pop();
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
        int value;
	char typ;
        }


%type<name>  idorkey ID
%type<typ> types var_def
%type<name> var_def_list args
%type<value> expression NUMBER array
 
%left PLUS MINUS
%left ASTERISK SLASH

%%

program

    :funcdef program 
    
    |globlinit program 

    |  funcdeclaration program

    | preprocessor program

    | struct program
    
    |
    ;
globlinit
     : types var_def_list ';'

    | types idorkey ASSIGNMENT expression ';'{
						if(t == 'f') 
							add_datatype(temp,"float",0);
						else if(t == 'i') 
							add_datatype(temp,"int",0);
						else if(t == 'c') 
							add_datatype(temp,"char",0);
					     }

    | idorkey ASSIGNMENT expression ';'

    | types array

    | STRUCT idorkey idorkey ';'

    ;

idorkey 
    : ID 					{ strcpy($$,temp); }
 
    | KEYWORD 					{ printf("\n Reserved identifier misuse.\n"); exit(0);} 

    ;


funcdeclaration
    : types idorkey args ';' 			{ char t[1];t[0] = $1;insertparams($2,$3,t);}

    ; 

struct
    : STRUCT idorkey CB_OPEN interior CB_CLOSE ';'

    ;

interior
    : types idorkey ';' interior

    |

    ;

preprocessor
    : '#' DEFINE idorkey NUMBER

    | '#' INCLUDE LESS idorkey '.' idorkey MORE

    | '#' INCLUDE STRING

    ;

funcdef
    : types  idorkey  args block_statement 	{	
						 if(lookup($2,$3) == 0)
					       	 	{     	
							printf("\n %s function with parameters %s is not declared.\n",$2,$3);
							exit(0);
						 	}
						}
    | types MAIN args block_statement

    ;

args
    :  '(' var_def_list ')' 			{ strcpy($$,$2);}

    ;
    
var_def_list
    :var_def_list COMMA var_def 		{ strcpy($$,$1);$$[strlen($1)]=$3;}

    |var_def 					{ $$[0] = $1;}
    |

    ;

    
var_def
    : types 					{ $$ = $1;}  

    | types idorkey 				{ $$ = $1;}
  

    ;

types
    : INT 					{ $$ = 'i';t = 'i';}

    | CHAR 					{ $$= 'c';t = 'c';}

    | FLOAT 					{ $$ = 'f';t = 'f';}

    | SHORT

    | SIGNED

    | UNSIGNED

    | LONG

    ;

block_statement
    :   CB_OPEN {nest++; } statements CB_CLOSE 	{ prin();scope(nest);nest--;}

    ;

statements
    : statements statement 

    | statement 

    |

    ;

funcall
    : ID '(' var_list ')' 
 
     

     ;

statement
    : block_statement 

    | PRINTF '(' var_list ')'';'

    | funcall ';'

    | assignment_statement ';' 


    | initialisation  

    | conditional_statement 

    | while_st

    | for_loop

    
    | ret_statement ';'

    ;

array
   : idorkey '[' expression ']' 		{$$ = $3;}

   | idorkey '['expression ']' ';' 		{$$ = $3;}

   ;

for_loop
    : FOR '('  initialisation  conditions ';' assignment_statement ')' block_statement

    ;

var_list
    : ID COMMA var_list 

    | ID   					{
						if(t == 'f') 
							add_datatype(temp,"float",nest);
						else if(t == 'i') 
							add_datatype(temp,"int",nest);
						else if(t == 'c') 
							add_datatype(temp,"char",nest); 
						}

    | STRING COMMA var_list

    | STRING
    ;

initialisation
    : types var_list ';'


   
    | types array 				{
			
						if($1 == 'i')
							add_datatype(temp,"int",nest);

						//printf("\n %d",atoi(num));		
						//printf("n %s %d",temp,yytext[0]);		
						add_arrdim(temp,atoi(num));
						}

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
    : types idorkey  ASSIGNMENT expression 	{	
								if(check_status($2))
    								{
					
								printf("\nVariable %s redeclared on line %d",temp,line);
				    				exit(0);
								}
					
							//if(check_scope(temp,flag,nest) == 0)
    							//{printf("\nvariable %s out of scope",temp);
				    			//exit(0);}
					
							if(t == 'f') add_datatype(temp,"float",nest);
							else if(t == 'i') add_datatype(temp,"int",nest);
							else if(t == 'c') add_datatype(temp,"char",nest);

					
							if( $1 =='c'){
								printf("\nType mismatch in %s.\n",$2);
								exit(0);
								}
							addQuadruple("=","",pop(),$2);
							
							
             					}

     | idorkey ASSIGNMENT expression 	 	{			
							addQuadruple("=","",pop(),$1);
							if(find_type($1)==0){
								printf("\nType mismatch or undeclared variable in %s.\n",$1);
								exit(0);
								}
					
					
							if(check_scope(temp,nest) == 0)
    								{
								printf("\nVariable %s out of scope at line %d.\n",temp,line);
								exit(0);
								}
                				}
     | types idorkey ASSIGNMENT char_expression 

    | idorkey ASSIGNMENT char_expression 	{
							if(check_scope(temp,nest) == 0)
    								{
								printf("\nVariable %s out of scope.\n",temp);
				    				exit(0);
								}
							if(find_type($1)=='i' || find_type($1) == 'f'){
								printf("\n Type mismatch in %s",$1);
								exit(0);
								}
						}


    | idorkey '.' idorkey ASSIGNMENT expression
    
    | types idorkey ASSIGNMENT

    | idorkey PLUS PLUS

    | array ASSIGNMENT expression 		{
							//printf("work %d %s",$1,temp);
							if(get_arrdim(temp) <= $1)
								{
								printf("\n Array %s - Index out of bound.\n",temp);
								exit(0);
								}
						}

    | error {} 
    ;

ret_statement
    : RETURN expression  

    ;
    
expression
    : NUMBER 					{	$$ = atoi(num);	
							char temp[10];
					                snprintf(temp,10,"%d",$$);    
        						push(temp);	}	

    | idorkey                                   {       push($1);	}

    | array  

    | idorkey '.' idorkey

    | expression PLUS expression 		{	$$ = $1+$3; 
							char str[5],str1[5]="t";
					                sprintf(str, "%d", temp_var);    
                        				strcat(str1,str);
                    					temp_var++;
                    					addQuadruple("+",pop(),pop(),str1);                                
                    					push(str1);		}

    | expression MINUS expression 		{	$$ = $1-$3;
							char str[5],str1[5]="t";
				                        sprintf(str, "%d", temp_var);    
                        				strcat(str1,str);
                    					temp_var++;
                                			addQuadruple("-",pop(),pop(),str1);
                                           		push(str1);		}

    | expression ASTERISK expression 		{	$$ = $1*$3;	
	                          			char str[5],str1[5]="t";
                					sprintf(str, "%d", temp_var);        
            						strcat(str1,str);
        						temp_var++;
        						addQuadruple("*",pop(),pop(),str1);
                                			push(str1);
										}

    | expression SLASH expression 		{	$$ = $1/$3;	
							char str[5],str1[5]="t";
					                sprintf(str, "%d", temp_var);        
	         					strcat(str1,str);
        						temp_var++;
        						addQuadruple("/",pop(),pop(),str1);
             						push(str1);		}
   
    | expression PERCENT expression 		{	$$ = $1%$3;	
							char str[5],str1[5]="t";
					                sprintf(str, "%d", temp_var);        
	         					strcat(str1,str);
        						temp_var++;
        						addQuadruple("%",pop(),pop(),str1);
             						push(str1);	}

    | '(' expression ')' 			{	$$ = $2;		}
  
    | STRING  					{	printf("\n Type mismatch.\n");}

    ;


char_expression
    : LITERAL_C

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
	printf("\n SUCCESSFUL PARSING \n");
	prin();
	display_Quadruple();
	return 0;
}
