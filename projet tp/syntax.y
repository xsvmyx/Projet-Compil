%{
#include <stdio.h>
#include <stdlib.h>

extern yylineno;
char SauvType[20];
%}

%union {
    int num;        
    float real;   
    char* text;     
}
%left '+' '-'    // priorité et associativité pour + et -


%token <num> NUM  // NUM contient un int

%token <real> REAL // REAL contient un float 
 
%token <text> TEXT // TEXT contient une chaîne de caractères
 
%token aff DEBUT EXECUTION DINS FINS FIN <text>ID DNUM DREAL DTEXT IF S SE I IE E NE ELSE WHILE

%%
program:
     DEBUT var_list EXECUTION DINS inst_list FINS FIN { printf("Programme syntaxiquement correct.\n"); YYACCEPT;}
    ;
    


var_list:
     var_list var ';' 
    | var ';'
    ;




var:
 DNUM ID  { insererType($2,$1); }
 |
 DNUM ID aff NUM  
 |
 DREAL ID 
 |
 DREAL ID aff REAL 
 |
 DTEXT ID 
 |
 DTEXT ID aff TEXT  
 ;




val:
    val '+' val       
  | val '-' val       
  | val '*' val       
  | val '/' val { if ($3 == 0) printf("Erreur semantique a la ligne %d : division par zero\n", yylineno); }
  | '(' val ')'       
  | ID                
  | NUM                           
  | REAL                       




inst_list:
    inst_list stmt
    |
    stmt
    ;


stmt:
    ID aff val ';' 
    |
    IF '(' COND ')' DINS stmt FINS
    |
    IF '(' COND ')' DINS stmt FINS ELSE DINS stmt FINS
    |
    WHILE '(' COND ')' DINS stmt FINS
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
    fprintf(stderr, "Erreur syntaxique : %s\n a la ligne %d", msg,yylineno);
    return 0;
}
int main() {
     yyparse();
    afficher();
}
yywrap(){

}
