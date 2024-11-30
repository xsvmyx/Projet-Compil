flex lexique.l
bison -d syntax.y
gcc lex.yy.c syntax.tab.c -lfl -ly -o compiler
pause
cls
compiler.exe<test.txt
pause
