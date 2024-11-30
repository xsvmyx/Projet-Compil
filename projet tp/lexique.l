%{
#include "syntax.tab.h"
extern YYSTYPE yylval;
%}
%option yylineno
%%

DEBUT {return DEBUT;}
EXECUTION {return EXECUTION;}
FIN {return FIN;}
NUM {return DNUM;}
REAL {return DREAL;}
TEXT {return DTEXT;}
"<-" {return aff;}
"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
";"  { return ';'; }
[a-zA-Z][a-zA-Z0-9_]* { yylval.text = strdup(yytext); return ID; }

[0-9]+\.[0-9]+ { yylval.real = atof(yytext);  return REAL ;}
[0-9]+        { yylval.num = atoi(yytext); return NUM; }
\"[^\"]*\" { yylval.text = strdup(yytext); return TEXT; }
--[^\n]*## {printf("commentaire sur une ligne\n");}
\{-(.|\n)*-\} {printf("commentaire sur plusieurs lignes\n");}
[ \t\n]              { /* Ignorer les espaces */ }
\{ {return DINS;}
\} {return FINS;}


.                    { printf("Caractère inattendu : %s\n", yytext); }

%%
