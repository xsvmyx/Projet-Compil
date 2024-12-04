%{
#include <stdio.h>
#include <stdlib.h>
#include "TS.h"
extern yylineno;
char SauvType[20];
char SaveType[20];
int pos;
char nom[20];

char value[20];
%}

%union {
    int num;        
    float real;   
    char* text;     
}
%left '+' '-'    // priorité et associativité pour + et -

%token <num> NUM   // NUM contient un int
%token <real> REAL // REAL contient un float 
%token <text> TEXT // TEXT contient une chaîne de caractères
 
%token aff DEBUT EXECUTION DINS FINS FIN <text>ID DNUM DREAL DTEXT IF S SE I IE E NE ELSE WHILE FIXE

%%
program:
     DEBUT var_list EXECUTION DINS inst_list FINS FIN { printf("Programme syntaxiquement correct.\n"); YYACCEPT;}
    ;
    


var_list:
     TYPE ':' var ';' var_list 
    | TYPE ':' var ';' 
    | FIXE TYPE ':' decla ';' {insererValFixe(nom);} var_list 
    |FIXE TYPE ':' decla ';' {insererValFixe(nom);}
    ;




var:
 var ',' ID  { 
                                    if(rechercheType($3)==0) {insererType($3,SauvType); }
                                    else printf("Erreur Semantique: double declation de %s, a la ligne %d\n", $3, yylineno); 
                                 }
 |
 ID   {     
                  if (rechercheType($1)==0) {insererType($1,SauvType); }
                  else printf("Erreur Semantique: double declation de %s, a la ligne %d\n", $1, yylineno);
          }
 |
 decla 
 
 ;

 TYPE:
 DNUM {strcpy(SauvType,$1);}
 |
 DREAL {strcpy(SauvType,$1);}
 |
 DTEXT{strcpy(SauvType,$1);}
 ;


 inst_list:
 inst_list stmt 
 |
 stmt 
 ;



decla:
 saveIDd E val  {      
                  if (pos==0) {insererTypeVal(nom,SauvType,value);  } 
                  else printf("Erreur Semantique: double declation de %s, a la ligne %d\n", nom, yylineno);}
    
    ;



stmt:
    saveID aff val ';'  {    
                  if (pos==0) printf("erreur semantique a la ligne %d, variable %s non declaree \n",yylineno,nom);
                  }
    |
    IF '(' COND ')' DINS stmt FINS
    |
    IF '(' COND ')' DINS stmt FINS ELSE DINS stmt FINS
    |
    WHILE '(' COND ')' DINS stmt FINS              
                  
    
    ;

saveIDd:
   ID {strcpy(SaveType,SauvType); pos = rechercheType($1); strcpy(nom,$1);}
   ;

saveID:
   ID {strcpy(SaveType,ts[recherche($1)].TypeEntite); pos = rechercheType($1); strcpy(nom,$1);}
   ;


val:
   val opera ID  
   |
   val opera NUM  
   |
   val opera REAL
   |
   val '/' ID
   |
   val '/' NUM {if($3 == 0) printf("Erreur semantique a la ligne %d division par zero \n",yylineno);}
   |
   val '/' REAL {if($3 == 0.0) printf("Erreur semantique a la ligne %d division par zero \n",yylineno);}
   |
   '(' val ')' 
   |
   ID  {if (rechercheType($1)==0) printf("erreur semantique a la ligne %d, variable %s non declaree \n",yylineno,$1);
        else{if(strcmp(SaveType,ts[recherche($1)].TypeEntite)!=0) printf("erreur semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType);
        else strcpy(value,ts[recherche($1)].ValEntite);}}
   |
   NUM  {if(strcmp(SaveType,"NUM")!=0) printf("erreur semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType); else{snprintf(value,sizeof(value),"%d",$1);}}
   |
   REAL {if(strcmp(SaveType,"REAL")!=0) printf("erreur semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType); else{snprintf(value,sizeof(value),"%f",$1);}}
   |
   TEXT {if(strcmp(SaveType,"TEXT")!=0) printf("erreur semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType); else{strcpy(value,$1);}}
   ;

opera:
  '+'
  |
  '-'
  |
  '*'
  
  ;  

  COND: 
    ELT E ELT 
    |
    ELT NE ELT
    |
    ELT S ELT
    |
    ELT SE ELT
    |
    ELT I ELT 
    |
    ELT IE ELT
    ;

ELT:
    ID
    |
    NUM
    |
    REAL
    |
    TEXT
    ;

  
%%
int yyerror(char *msg) {
    fprintf(stderr, "Erreur syntaxique : %s a la ligne %d \n", msg,yylineno);
    return 0;
}
int main() {
     yyparse();
    afficher();
}
yywrap(){

}
