%{
#include "syntax.tab.h"

extern YYSTYPE yylval;
%}
%option yylineno
ID [a-zA-Z][a-zA-Z0-9_]{0,9} 
%%

DEBUT {return DEBUT;}
EXECUTION {return EXECUTION;}
FIN {return FIN;}
"NUM" {yylval.text=strdup(yytext); return DNUM;}
"REAL" {yylval.text=strdup(yytext); return DREAL;}
"TEXT" {yylval.text=strdup(yytext); return DTEXT;}
FIXE { return FIXE; }
lire {return INPUT;}
affiche {return OUTPUT;}

"<-" {return aff;}
"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
";"  { return ';'; }
"," {return ',';}
":" {return ':';}
SI {return IF;}
SINON {return ELSE;}
TANTQUE {return WHILE;}
"ET" {return AND;}
"OU" {return OR;}
"NON" {return NO;}

">" {return S;}
">=" {return SE;}
"<" {return I;}
"<=" {return IE;}
"=" {return E;}
"!=" {return NE;}
"(" {return '(';}
")" {return ')';}
"[" {return '[';}
"]" {return ']';}
{ID} { yylval.text = strdup(yytext); inserer(yytext,"id"); return ID; }

-?[0-9]+\.[0-9]+ { yylval.real = atof(yytext);  return REAL ;}


-?[0-9]+        { yylval.num = atoi(yytext); return NUM; }
\"[^\"]*\" { yylval.text = strdup(yytext); return TEXT; }
--[^\n]*## {printf("commentaire sur une ligne\n");}
\{-(.|\n)*-\} {printf("commentaire sur plusieurs lignes\n");}
[ \t\n]              { /* Ignorer les espaces */ }
\{ {return DINS;}
\} {return FINS;}


.                    { printf("Caractère inattendu : %s\n", yytext); }

%%
