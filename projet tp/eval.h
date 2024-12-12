#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <math.h>

#define MAX 100

// Structure de la pile pour les opérateurs (char)
typedef struct {
    int top;
    char items[MAX];
} CharStack;

// Structure de la pile pour les entiers
typedef struct {
    int top;
    int items[MAX];
} IntStack;

// Structure de la pile pour les flottants
typedef struct {
    int top;
    float items[MAX];
} FloatStack;

// Initialisation de la pile char
void initCharStack(CharStack *s) {
    s->top = -1;
}

// Initialisation de la pile d'entiers
void initIntStack(IntStack *s) {
    s->top = -1;
}

// Initialisation de la pile de flottants
void initFloatStack(FloatStack *s) {
    s->top = -1;
}

// Vérifie si la pile char est vide
int isEmptyCharStack(CharStack *s) {
    return s->top == -1;
}

// Vérifie si la pile d'entiers est vide
int isEmptyIntStack(IntStack *s) {
    return s->top == -1;
}

// Vérifie si la pile de flottants est vide
int isEmptyFloatStack(FloatStack *s) {
    return s->top == -1;
}

// Vérifie si la pile char est pleine
int isFullCharStack(CharStack *s) {
    return s->top == MAX - 1;
}

// Vérifie si la pile d'entiers est pleine
int isFullIntStack(IntStack *s) {
    return s->top == MAX - 1;
}

// Vérifie si la pile de flottants est pleine
int isFullFloatStack(FloatStack *s) {
    return s->top == MAX - 1;
}

// Empile un élément de type char
void pushCharStack(CharStack *s, char item) {
    if (isFullCharStack(s)) {
        exit(1);
    }
    s->items[++s->top] = item;
}

// Empile un entier dans la pile d'entiers
void pushIntStack(IntStack *s, int item) {
    if (isFullIntStack(s)) {
        exit(1);
    }
    s->items[++s->top] = item;
}

// Empile un flottant dans la pile de flottants
void pushFloatStack(FloatStack *s, float item) {
    if (isFullFloatStack(s)) {
        exit(1);
    }
    s->items[++s->top] = item;
}

// Dépile un élément de type char
char popCharStack(CharStack *s) {
    if (isEmptyCharStack(s)) {
        exit(1);
    }
    return s->items[s->top--];
}

// Dépile un entier de la pile d'entiers
int popIntStack(IntStack *s) {
    if (isEmptyIntStack(s)) {
        exit(1);
    }
    return s->items[s->top--];
}

// Dépile un flottant de la pile de flottants
float popFloatStack(FloatStack *s) {
    if (isEmptyFloatStack(s)) {
        exit(1);
    }
    return s->items[s->top--];
}

// Consulte l'élément au sommet de la pile char
char peekCharStack(CharStack *s) {
    if (isEmptyCharStack(s)) {
        exit(1);
    }
    return s->items[s->top];
}

// Consulte l'élément au sommet de la pile d'entiers
int peekIntStack(IntStack *s) {
    if (isEmptyIntStack(s)) {
        exit(1);
    }
    return s->items[s->top];
}

// Consulte l'élément au sommet de la pile de flottants
float peekFloatStack(FloatStack *s) {
    if (isEmptyFloatStack(s)) {
        exit(1);
    }
    return s->items[s->top];
}

// Détermine la priorité des opérateurs
int precedence(char op) {
    switch (op) {
        case '+':
        case '-': return 1;
        case '*':
        case '/': return 2;
        case '(': return 0;
        default: return -1;
    }
}

// Conversion infixe vers postfixe (en utilisant la pile de char)
void infixToPostfix(const char *infix, char *postfix) {
    CharStack s;
    initCharStack(&s);
    int k = 0;
    int i = 0;

    while (infix[i] != '\0') {
        char token = infix[i];

        if (isdigit(token) || token == '.') {
            while (isdigit(infix[i]) || infix[i] == '.') {
                postfix[k++] = infix[i++];
            }
            postfix[k++] = ' ';  // Ajouter un espace pour séparer les nombres
        } else if (token == '(') {
            pushCharStack(&s, token);
            i++;
        } else if (token == ')') {
            while (!isEmptyCharStack(&s) && peekCharStack(&s) != '(') {
                postfix[k++] = popCharStack(&s);
                postfix[k++] = ' ';
            }
            popCharStack(&s); // Supprime '(' de la pile
            i++;
        } else {
            while (!isEmptyCharStack(&s) && precedence(peekCharStack(&s)) >= precedence(token)) {
                postfix[k++] = popCharStack(&s);
                postfix[k++] = ' ';
            }
            pushCharStack(&s, token);
            i++;
        }
    }

    while (!isEmptyCharStack(&s)) {
        postfix[k++] = popCharStack(&s);
        postfix[k++] = ' ';
    }

    postfix[k - 1] = '\0'; // Remplacer le dernier espace par le caractère nul
}

// Évaluation de la notation postfixe (entiers)
int evaluatePostfix(const char *postfix) {
    IntStack s;
    initIntStack(&s);
    int i;
    for (i = 0; postfix[i] != '\0'; i++) {
        if (isdigit(postfix[i])) {
            int num = 0;
            while (isdigit(postfix[i])) {
                num = num * 10 + (postfix[i] - '0');
                i++;
            }
            pushIntStack(&s, num);
            i--;
        } else if (postfix[i] == ' ') {
            continue;
        } else {
            int val2 = popIntStack(&s);
            int val1 = popIntStack(&s);

            switch (postfix[i]) {
                case '+': pushIntStack(&s, val1 + val2); break;
                case '-': pushIntStack(&s, val1 - val2); break;
                case '*': pushIntStack(&s, val1 * val2); break;
                case '/': pushIntStack(&s, val1 / val2); break;
            }
        }
    }

    return popIntStack(&s);
}

// Évaluation de la notation postfixe (flottants)
float evaluatePostfixFloat(const char *postfix) {
    FloatStack s;
    initFloatStack(&s);
    float num = 0.0;
    int i = 0;
    while (postfix[i] != '\0') {
        if (isdigit(postfix[i]) || postfix[i] == '.') {
            
            int decimal_place = -1;
            while (isdigit(postfix[i]) || postfix[i] == '.') {
                if (postfix[i] == '.') {
                    decimal_place = 0;
                } else {
                    if (decimal_place == -1) {
                        num = num * 10 + (postfix[i] - '0');
                    } else {
                        decimal_place++;
                        float m = pow(10, decimal_place);
                        
                        float bro = (postfix[i] - '0') / m;
                        num = num + bro ;
                        
                        
                    }
                }
                
                i++;
            }
            pushFloatStack(&s, num);
            
        } else if (postfix[i] == ' ') {
            num=0.0;
            i++;
        } else {
            num = 0.0;
            float val2 = popFloatStack(&s);
            float val1 = popFloatStack(&s);

            switch (postfix[i]) {
                case '+': pushFloatStack(&s, val1 + val2); break;
                case '-': pushFloatStack(&s, val1 - val2); break;
                case '*': pushFloatStack(&s, val1 * val2); break;
                case '/': pushFloatStack(&s, val1 / val2); break;
            }
            i++;
        }
    }
    float fin = popFloatStack(&s);
     
    return fin;
    
}

//évaluation expression logique
int evaluatePostfixLogiqueInt(const char *postfix){
 int i = evaluatePostfix(postfix);
 if (i!=0) return 1;
 else return 0;

 return -1;
}


//évaluation expression logique float
int evaluatePostfixLogiqueFloat(const char *postfix){
 float i = evaluatePostfixFloat(postfix);
 if (i!=0) return 1;
 else return 0;

 return -1;
}


