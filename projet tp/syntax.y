%{
#include <stdio.h>
#include <stdlib.h>
extern yylineno;
%}

%union {
    int num;        
    float real;   
    char* text;     
}

%token <num> NUM   // NUM contient un int
%token <real> REAL // REAL contient un float 
%token <text> TEXT // TEXT contient une chaîne de caractères
 
%token aff DEBUT EXECUTION DINS FINS FIN <text>ID DNUM,DREAL,DTEXT

%%
program:
     DEBUT var_list EXECUTION DINS inst_list FINS FIN { printf("Programme syntaxiquement correct.\n"); }
    ;
    


var_list:
    var_list var 
    | var
    ;




var:
 DNUM ID ';'
 |
 DNUM ID aff NUM ';';
 |
 DREAL ID ';'
 |
 DREAL ID aff REAL ';'
 |
 DTEXT ID ';'
 |
 DTEXT ID aff TEXT ';' 
 ;


inst_list:
 inst_list stmt
 |
 stmt
 ;




stmt:
    ID aff val ';' 
    
    ;
val:
   val opera ID  
   |
   val opera NUM  
   |
   val '/' ID
   |
   val '/' NUM {if($3 == 0) printf("Erreur semantique a la ligne %d division par zero \n",yylineno);}
   |
   ID  
   |
   NUM  
   ;

opera:
  '+'
  |
  '-'
  |
  '*'
  
  ;   
%%
int yyerror(char *msg) {
    fprintf(stderr, "Erreur syntaxique : %s\n", msg);
    return 0;
}
int main() {
    return yyparse();
}
