#include<string.h>
struct symtab {
    char name[10];
    int value;
    int scope;
    int active;
    char *type;
    int isfunc;
    int isdef;
    char params[10];
    int arrdim;
    struct symtab *next;
};



struct symtab *symlook();
struct symtab *table = NULL;

void insertparams(char *fname,char *ps,char *ft){
	
	struct symtab *p = table;
	char t[7];
	
	while(p!=NULL)
	{	if(strcmp(p->name,fname)==0)
			{	strcpy(p->params,ps);
				//printf("Reached here\n");
				p->isfunc = 1;
				
				if(strcmp(ft,"i")==0)
					strcpy(t,"int");
				else if(strcmp(ft,"c")==0)
					strcpy(t,"char");
				else if(strcmp(t,"f")==0)
					strcpy(t,"float");
				
				p->type = malloc(strlen(t)*sizeof(char));
				strcpy(p->type,t);
				break;
			}
		p = p->next;
	}	
	
}

int find_type(char *nam){


	struct symtab *p = table;
	
	while(p!=NULL)
	{	if(strcmp(p->name,nam)==0)
			if(p->type == NULL)
				return 0;
			if(p->type[0] == 'i' || p->type[0] == 'f')
				return 1;
			
		if(p->next==NULL)
			break;	
		p = p->next;
	}	
	return 0;
}	


void prin()
{
	if(table == NULL)
	{	printf("\n empty");
		return ;
	}
		
	struct symtab *s = table;
	
	printf("\n-----------------------------------------\t\tSYMBOL TABLE\t\t----------------------------------------------\n");
	printf("\n\t Name \t\tType \t\tScope \t\tStatus \t\tisFunc \t\tParams \t\tisDef \t\tArrdim\n");
	printf("\n------------------------------------------------------------------------------------------------------------------------------\n");
	while(1){

		if(s->scope != -1 || s->isfunc == 1){
		
			printf("\n\t %s",s->name);
			printf("%*c", 15-strlen(s->name), ' ');
			printf("%s",s->type);
			printf("\t\t%d",s->scope);
			printf("\t\t%d",s->active);
			printf("\t\t%d",s->isfunc);
			printf("\t\t%s",s->params);
			printf("\t\t%d",s->isdef);
			printf("\t\t%d",s->arrdim);
		}
		
		if(s->next==NULL)
			break;
		s = s->next;
	}
	printf("\n\n------------------------------------------------------------------------------------------------------------------------------\n");
	printf("\n"); 
	return;
}

int check_status(char *id){
	struct symtab *s = table;

	while(1){
		if(strcmp(s->name,id) == 0 && s->active == 1 )
			return 1;
		if(s->next == NULL)
			break;
  		s = s->next;
	}
	return 0;
}



int check_scope(char *id,int ne){
	
	struct symtab *s = table;
	int flag = 0;
	
	while(1){
		if(strcmp(s->name,id) == 0 && s->scope <= ne && s->active == 1 )
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
		if(strcmp(s->name,id)==0 && s->active == 1 && s->scope!= -1){
		
			printf("\n redeclaration of  %s",id);
			exit(0);
			return;
			}
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
			s->active = 1;
			break;
		}
		
		if(s->next == NULL)
			break;
  		s = s->next;
	
	}
}
int get_arrdim(char *id){
	
	struct symtab *s = table;
	
	while(1){
		if(strcmp(s->name,id) == 0 && s->active == 1)
			return s->arrdim;
		if(s->next == NULL)
			break;
  		s = s->next;
	}

	return 0;
	
}
void scope(int ne){
	
	struct symtab *s = table;
	while(1){
		if(s->scope == ne)
			s->active = 0;
		if(s->next == NULL)
			break;
		s = s->next;
	}
}

void add_arrdim(char *id,int dim){
	
	struct symtab *s = table;
	while(1){
		if(strcmp(s->name,id) == 0 && s->active == 1)
			s->arrdim = dim;
		if(s->next == NULL)
			break;
  		s = s->next;
	}
	
}

void insert(char *s){
	
	struct symtab *p = table;
	
	if(p == NULL){
		
		p = malloc(sizeof(struct symtab));
		int i;		
		strcpy(p->name,s);
		p->scope = -1;
		p->active = 0;
		p->value = NULL;
		p->next = NULL;
		p->isfunc = 0;
		p->isdef = 0;
		p->arrdim = 0;
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
	temp->active = 0;
	temp->arrdim = 0;
	temp->isdef = 0;
	p->next = temp;
	
	return;
}

int lookup(char *s,char *alist){
	struct symtab *p = table;
	
while(p!=NULL)
	{	if(strcmp(p->name,s)==0 && strcmp(p->params,alist) == 0){
			p->isdef = 1;			
			return 1;
			}
		p = p->next;
	}	
	return 0;
}


