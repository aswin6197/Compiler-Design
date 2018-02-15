clear
lex project.l
yacc project.y -d 
rm a.out
gcc y.tab.c  -ll -ly

./a.out
