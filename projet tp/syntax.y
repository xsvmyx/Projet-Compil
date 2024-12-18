%{
#include <stdio.h>
#include <stdlib.h>
#include "TS.h"
#include "eval.h"
#include "tab.h"

extern yylineno;
char SauvType[20];
char SaveType[20];
int pos,p,r;
char nom[20];
char value[20];
char value2[20];
char *in ;
char *pre;
int possible;
char inter[20];
int jesuis;
int ind;
int nega=0;
float f;

%}

%union {
    int num;        
    float real;   
    char* text;     
}
%left '*' '/'    // priorité et associativité pour + et -
%right '+' '-'   

%token <num> NUM   // NUM contient un int
%token <real> REAL // REAL contient un float 
%token <text> TEXT // TEXT contient une chaîne de caractères
 
%token aff DEBUT EXECUTION DINS FINS FIN <text>ID DNUM DREAL DTEXT IF S SE I IE E NE ELSE WHILE FIXE AND OR NO INPUT OUTPUT NOT

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


 TYPE:
 DNUM {strcpy(SauvType,$1);}
 |
 DREAL {strcpy(SauvType,$1);}
 |
 DTEXT{strcpy(SauvType,$1);}
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
  ID '[' NUM ']' { 
                  if($3<=0) {printf("erreur semantique à la ligne %d : taille de tableau invalide %d\n",yylineno,$3);}
                  else{
                  if (rechercheType($1)==0){ insererTypeTaille($1,SauvType,$3); inserertab($1,SauvType,$3); }
                  else {printf("Erreur Semantique: double declation de %s, a la ligne %d\n", $1, yylineno);}}
         
          }
|
 decla 
 
 ;

 decla:
 saveIDd E {strcpy(in,"");} val  {      
                  if (pos==0) {insererTypeVal(nom,SauvType,value); printf("%s\n",in);  } 
                  else printf("Erreur Semantique: double declation de %s, a la ligne %d\n", nom, yylineno);}

    
    ;

saveIDd:
   ID {strcpy(SaveType,SauvType); pos = rechercheType($1); strcpy(nom,$1);}
   ;


 inst_list:
 inst_list stmt 
 |
 stmt 
 ;







stmt:
    
    saveID aff{strcpy(in,"");} val ';'  {    
                  if (pos==0) printf("Erreur semantique a la ligne %d, variable %s non declaree \n",yylineno,nom);
                  if (strcmp(ts[p].ValFixe,"OUI" )==0) printf("erreur semantique a la ligne %d, affectation sur une variable FIXE. \n",yylineno);
                  else{

                    infixToPostfix(in,pre);
                  
                    if(possible) {
                        if(strcmp(ts[p].TypeEntite,"REAL")==0) { if(jesuis){ snprintf(value2,sizeof(value2),"%.2f",evaluatePostfixFloat(pre)) ; insererVal(nom,value2);}
                        else insererValCaseFloat(nom,evaluatePostfixFloat(pre),ind); }
                         else
                         if(strcmp(ts[p].TypeEntite,"NUM")==0) { if(jesuis){snprintf(value2,sizeof(value2),"%d",evaluatePostfix(pre)); insererVal(nom,value2);} 
                        else insererValCaseInt(nom,evaluatePostfix(pre),ind); } 
                        
                       
                        } 
                    possible=1;
                    strcpy(pre,"");
                    strcpy(in,"");

                  }
                  }
    
    |
    
   
    IF '(' CONDI ')' DINS stmt FINS
    |
    IF '(' CONDI ')' DINS stmt FINS ELSE DINS stmt FINS
    |
    WHILE '(' CONDI ')' DINS stmt FINS       
    |
    OUTPUT '(' val ')'  ';' {printf("%s\n",value);    }   
    |
    INPUT '(' saveID ')' ';' {
                        if (pos==0) printf("Erreur semantique a la ligne %d, variable %s non declaree \n",yylineno,nom);
                        if (strcmp(ts[p].ValFixe,"OUI" )==0) printf("erreur semantique a la ligne %d, input sur une variable FIXE. \n",yylineno);

    }         
                  
    
    ;


saveID:
   ID {strcpy(SaveType,ts[recherche($1)].TypeEntite); pos = rechercheType($1); p=recherche($1); strcpy(nom,$1); jesuis = 1;}
   |
   ID '[' NUM ']' { 
         strcpy(SaveType,ts[recherche($1)].TypeEntite); pos = rechercheType($1); strcpy(nom,$1);
         if(!ts[recherche($1)].Taille){ printf("Erreur Semantique a la ligne %d : variable '%s' n'est pas un tableau!!\n",yylineno,$1); }
         else if($3>=ts[recherche($1)].Taille) printf("Erreur Semantique a la ligne %d : Index hors limites \n",yylineno,$1);
         else {jesuis=0; ind = $3 -'0';}           
    }
   
   ;



val:

   val opera  ID  {strcpy(value,ts[recherche($3)].ValEntite); strcat(in,inter); strcat(in,value);}
   |
   val opera NOT ID  {     nega=!atoi(ts[recherche($4)].ValEntite);    snprintf(value,sizeof(value),"%d",nega); strcat(in,inter); strcat(in,value);}
   |
   val opera NUM  {snprintf(value,sizeof(value),"%d",$3); strcat(in,inter); strcat(in,value);}
   |
   val opera NOT NUM  { snprintf(value,sizeof(value),"%d",!$4); strcat(in,inter); strcat(in,value);}
   |
   val opera REAL {snprintf(value,sizeof(value),"%f",$3); strcat(in,inter); strcat(in,value);}
   |
   val opera ID '[' NUM ']' {
        if(strcmp(ts[recherche($3)].TypeEntite,"NUM")==0){ 
                                                            snprintf(value,sizeof(value),"%d",t[rechercheTab($3)].adresseInt[$5 -'0']); strcat(in,inter); strcat(in,value);}
        else 
        if(strcmp(ts[recherche($3)].TypeEntite,"REAL")==0){snprintf(value,sizeof(value),"%.2f",t[rechercheTab($3)].adresseFloat[$5] - '0'); strcat(in,inter); strcat(in,value);}
   }                 
   |

   val '/' ID {
                 if(strcmp(ts[recherche($3)].ValEntite,"0")==0) {printf("Erreur semantique a la ligne%d, diision par zero\n",yylineno); possible=0; strcpy(in,"");}
                else{
                strcpy(value,ts[recherche($3)].ValEntite); strcat(in,"/"); strcat(in,value);}
   }
   |
   val '/' NUM {if($3 == 0) {printf("Erreur semantique a la ligne %d, division par zero \n",yylineno); possible=0; strcpy(in,"");}
                else{snprintf(value,sizeof(value),"%d",$3); strcat(in,"/"); strcat(in,value);}}
   |
   val '/' REAL {if($3 == 0.0) {printf("Erreur semantique a la ligne %d, division par zero \n",yylineno); possible=0; strcpy(in,"");}
                else{snprintf(value,sizeof(value),"%f",$3); strcat(in,"/"); strcat(in,value);}}
   |
   val '/' ID '[' NUM ']'  {
        if(strcmp(ts[recherche($3)].TypeEntite,"NUM")==0){  r=t[rechercheTab($3)].adresseInt[$5 -'0'];
                                                            if(r==0){printf("Erreur semantique a la ligne%d, diision par zero\n",yylineno); possible=0; strcpy(in,"");}
                                                            snprintf(value,sizeof(value),"%d",r); strcat(in,"/"); strcat(in,value);}
        else 
        if(strcmp(ts[recherche($3)].TypeEntite,"REAL")==0){ f=t[rechercheTab($3)].adresseFloat[$5] - '0';
                                                            if(!f) {printf("Erreur semantique a la ligne%d, diision par zero\n",yylineno); possible=0; strcpy(in,""); }
                                                            snprintf(value,sizeof(value),"%.2f",f); strcat(in,"/"); strcat(in,value);}
   }
   |
    '(' val ')' 
     
   |
   ID  {if (rechercheType($1)==0) printf("erreur semantique a la ligne %d, variable %s non declaree \n",yylineno,$1);
        else{if(strcmp(SaveType,ts[recherche($1)].TypeEntite)!=0) {printf("erreur semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType); possible=0;}
        else strcpy(value,ts[recherche($1)].ValEntite);} strcat(in,value);}
   |
   NOT ID  {if (rechercheType($2)==0) printf("erreur semantique a la ligne %d, variable %s non declaree \n",yylineno,$2);
        else{if(strcmp(SaveType,ts[recherche($2)].TypeEntite)!=0) {printf("erreur semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType); possible=0;}
        else snprintf(value,sizeof(value),"%d",!atoi(ts[recherche($2)].ValEntite));} strcat(in,value);}
   |
   NUM  {if(strcmp(SaveType,"NUM")!=0) {printf("erreur semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType); possible=0;} else{snprintf(value,sizeof(value),"%d",$1); strcat(in,value);}}
   |
   REAL {if(strcmp(SaveType,"REAL")!=0) { printf("erreur semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType); possible=0;} else{snprintf(value,sizeof(value),"%.2f",$1); strcat(in,value);}}
   |
   TEXT {if(strcmp(SaveType,"TEXT")!=0) {printf("erreur semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType); possible=0;} else{strcpy(value,$1); }}
   |
   ID '[' NUM ']' {if (rechercheType($1)==0)  {printf("ErreuR semantique a la ligne %d, variable %s non declaree \n",yylineno,$1); possible=0;}
        else {if(ts[recherche($1)].Taille==0) {printf("Erreur Semantique a la ligne %d: variable '%s' n'est pas un tableau!!\n",yylineno,$1);  possible=0;}   
        else {if($3>=ts[recherche($1)].Taille) {printf("Erreur Semantique a la ligne %d : Index hors limites \n",yylineno,$1); possible=0;}                                          
        else{if(strcmp(SaveType,ts[recherche($1)].TypeEntite)!=0) {printf("ErreuR semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType); possible=0;}
        else 
        if(strcmp(ts[recherche($1)].TypeEntite,"NUM")==0){snprintf(value,sizeof(value),"%d",t[rechercheTab($1)].adresseInt[$3 -'0']); strcat(in,value);}
        else 
        if(strcmp(ts[recherche($1)].TypeEntite,"REAL")==0){snprintf(value,sizeof(value),"%.2f",t[rechercheTab($1)].adresseFloat[$3] - '0'); strcat(in,value);}
        }}}}
    |
    NOT NUM  {if(strcmp(SaveType,"NUM")!=0) {printf("erreur semantique a la ligne %d, variables de type different %s \n",yylineno,SaveType); possible=0;} else {   snprintf(value,sizeof(value),"%d",!$2);  strcat(in,value);}}

    
    
        
      
   ;
   
opera:
  '+' {strcpy(inter,"+");}
  |
  '-' {strcpy(inter,"-");}
  |
  '*' {strcpy(inter,"*");}
  |
  AND {strcpy(inter,"AND")}
  |
  OR {strcpy(inter,"OR")}

  
  ;  
  CONDI:
  COND
  |
  CONDI AND COND;
  |
  CONDI OR COND;

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
    ID  {if (rechercheType($1)==0) printf("erreur semantique a la ligne %d, variable %s non declaree \n",yylineno,$1);}
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
    possible=1;
    in = (char*)malloc(100 * sizeof(char));
    strcpy(in,"");
    pre = (char*)malloc(100 * sizeof(char));
    strcpy(pre,"");
     yyparse();
    afficher();
    affichertab();
    
}
yywrap(){

}
