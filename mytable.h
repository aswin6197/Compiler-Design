#define NSYMS 100
#include<string.h>
struct symtab {
    char name[10];
    int value;
    char *type;
    struct symtab *next;
};



struct symtab *symlook();
struct symtab *table;
void prin()
{
	printf("1 identifiers \n2 keywords\n3 constants \n4 operators");
	struct symtab *s = table;
	char map[4][20] = {"Identifier","Keyword","Constants","Operators"};
	printf("\n-------------------------------------------------------------------------------Symbol Table----------------------------------------------------------------------------------------------");
	printf("\n\t Name \t\t Value");
	while(s->next!=NULL){
	
		printf("\n\t %s",s->name);
		printf("%*c", 15-strlen(s->name), ' ');
		printf("%s",map[s->value-1]);
		s = s->next;
	}
	printf("\n\t %s ",s->name);
	printf("%*c",15-strlen(s->name),' ');
	printf("%s\n",map[s->value-1]);
	return;
}

void insert(char *s,int v){
	
	struct symtab *p = table;
	if(p == NULL)	{
		p = malloc(sizeof(struct symtab));
		int i;
		strcpy(p->name,s);
		p->value = v;
		p->next = NULL;
		table = p;
//		printf("\n%s is first",s);
		return;
	}
	while(1){
		
		if(strcmp(p->name,s)==0){
//			printf("found\n");
			return;
		}
		if(p->next == NULL)
			break;
		p = p->next;
	}
	struct symtab *temp;
	temp = malloc(sizeof(struct symtab));
	strcpy(temp->name,s);
	temp->value = v;
	temp->next = NULL;
	p->next = temp;
//	printf("new %s\n",s);

	return;
	
	
	//yyerror("to many symbols");
	
}


