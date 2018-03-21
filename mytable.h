#include<string.h>
struct symtab {
    char name[10];
    int value;
    int scope;
    int active;
    char *type;
    int isfunc;
    char params[10];
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
	printf("\n\t Name \t\t type \t\t scope \t\t active");
	while(1){
	if(s->scope != -1 || s->isfunc == 1){
		printf("\n\t %s",s->name);
		printf("%*c", 15-strlen(s->name), ' ');
		printf("%s",s->type);
		printf("\t\t%d",s->scope);
		printf("\t\t %d",s->active);
		printf("\t\t %d",s->isfunc);
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
		if(strcmp(s->name,id) == 0 && s->scope <= sc && s->active == 0)
			flag = 1;
		if(s->next == NULL)
			break;
  		s = s->next;
	}
	return flag;
}

void add_datatype(char *id,char *type,int sc){
	
	
	struct symtab *s = table;
	while(1){
	if(strcmp(s->name,id)==0 && s->active == 0){
		printf("\n invalid %s",id);
		return;}
	if(s->next == NULL)
		break;
  	s = s->next;	
	}

	s = table;
	while(1){
	if(strcmp(s->name,id)==0 && s->scope == -1)
	{	//printf("found \n");
		s->type = malloc(strlen(type)*sizeof(char));
		strcpy(s->type,type);
		s->scope = sc;
		s->active = 0;
		break;
	}
	if(s->next == NULL)
		break;
  	s = s->next;
	
	}
}

void scope(int ne){
	struct symtab *s = table;
	while(1){
		if(s->scope == ne)
			s->active = 1;
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
		p->active = 1;
		p->value = NULL;
		p->next = NULL;
		p->isfunc = 0;
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
 	temp->isfunc = 0;
	temp->scope = -1;
	temp->active = 1;
	p->next = temp;
	return;
}

int lookup(char *s,int f){
	struct symtab *p = table;
	while(p!=NULL)
	{	if(strcmp(p->name,s)==0)
			{if(f == 1)
				p->isfunc = 1;
			return 1;
			}
		p = p->next;
	}	
	return 0;
}


