#include<string.h>
struct symtab {
    char name[10];
    int value;
    int scope;
    int nesting;
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
	printf("\n\t Name \t\t type \t\t scope \t\t nesting");
	while(1){
	if(s->scope != -1){
		printf("\n\t %s",s->name);
		printf("%*c", 15-strlen(s->name), ' ');
		printf("%s",s->type);
		printf("\t\t%d",s->scope);
		printf("\t\t %d",s->nesting);
		}
		if(s->next==NULL)
			break;
		s = s->next;
	}
	printf("\n"); 
	return;
}

int check_scope(char *id,int sc,int ne){
	struct symtab *s = table;
	int flag = 0;
	while(1){
		if(strcmp(s->name,id) == 0 && s->scope == sc && s->nesting <= ne)
			flag = 1;
		if(s->next == NULL)
			break;
  		s = s->next;
	}
	return flag;
}

void add_datatype(char *id,char *type,int sc,int ne){
	
	
	struct symtab *s = table;
	while(1){
	if(strcmp(s->name,id)==0 && s->scope == -1)
	{	//printf("found \n");
		s->type = malloc(strlen(type)*sizeof(char));
		strcpy(s->type,type);
		s->scope = sc;
		s->nesting = ne;
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
		p->scope = -1;
		
		p->value = NULL;
		p->next = NULL;
		table = p;
		return;
	}
	while(1){
		
		
		if(p->next == NULL)
			break;
		p = p->next;
	}
	struct symtab *temp;
	temp = malloc(sizeof(struct symtab));
	strcpy(temp->name,s);
	temp->value = NULL;
	temp->next = NULL;
	temp->scope = -1;
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
