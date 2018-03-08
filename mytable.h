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
	if(table == NULL)
	{	printf("\n empty");
		return 0;
	}
	//printf("1 identifiers \n2 keywords\n3 constants \n4 operators");
	struct symtab *s = table;
	
	printf("\n-----------------------------Symbol Table-------------------------");
	printf("\n\t Name \t\t type");
	while(1){
	
		printf("\n\t %s",s->name);
		printf("%*c", 15-strlen(s->name), ' ');
		printf("%s",s->type);
		if(s->next==NULL)
			break;
		s = s->next;
	}
	printf("\n"); 
	return;
}

void add_datatype(char *id,char *type){
	
	
	struct symtab *s = table;
	while(1){
	if(strcmp(s->name,id)==0)
	{	//printf("found \n");
		s->type = malloc(strlen(type)*sizeof(char));
		strcpy(s->type,type);
		break;
	}
	if(s->next == NULL)
		break;
  	s = s->next;
	
}
}

void insert(char *s){
	
	struct symtab *p = table;
	if(p == NULL)	{
		p = malloc(sizeof(struct symtab));
		int i;
		strcpy(p->name,s);
		p->value = NULL;
		p->next = NULL;
		table = p;
		return;
	}
	while(1){
		
		if(strcmp(p->name,s)==0){
			return;
		}
		if(p->next == NULL)
			break;
		p = p->next;
	}
	struct symtab *temp;
	temp = malloc(sizeof(struct symtab));
	strcpy(temp->name,s);
	temp->value = NULL;
	temp->next = NULL;
	p->next = temp;
	return;
}

int lookup(char *s){
	struct symtab *p = table;
	while(p!=NULL)
	{	if(strcmp(p->value,s)==0)
			return 1;
		p = p->next;
	}	
	return 0;
}
