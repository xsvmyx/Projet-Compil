%{
#include <stdio.h>
#include <stdlib.h>
%}

%union {
    int num;        
    float real;   
    char* text;     
}

%token <num> NUM   // NUM contient un int
%token <real> REAL // REAL contient un float 
%token <text> TEXT // TEXT contient une chaîne de caractères
 
%token aff DEBUT EXECUTION FIN <text>ID DNUM,DREAL,DTEXT

%%
program:
     DEBUT var_list FIN { printf("Programme syntaxiquement correct.\n"); }
    ;
    


var_list:
    var_list var 
    | var
    ;




var: DNUM ID ';'
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



stmt:
    ID aff NUM ';' {
        printf("Affectation : %s = %d\n", $1, $3);
    }
    ;
%%
int yyerror(char *msg) {
    fprintf(stderr, "Erreur syntaxique : %s\n", msg);
    return 0;
}
int main() {
    return yyparse();
}