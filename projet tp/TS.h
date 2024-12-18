#include <stdio.h>
#include <string.h>

//Declaration de la TS
typedef struct
{
  char NomEntite[20];
  char CodeEntite[20];
  char TypeEntite[20];
  char ValEntite[20];
  char ValFixe[20];
   int Taille;
} TypeTS;

TypeTS ts[100];

// init compteur 
int CpTS = 0;
/* La fonction recherche : cherche si l'entite existe deja ou pas dans la table de symbole
retourne sa position  i:  si l'entite existe déjà 
Sinon  -1 ( c-a-d l'entite n'existe pas  )
*/
int recherche(char entite[])
{
  int i = 0;
  while (i < CpTS)
  {
    if (strcmp(entite, ts[i].NomEntite) == 0)
        return i;
    i++;
  }

  return -1;
}

//Fonction d'insertion des entités du programme dans la TS

void inserer(char entite[], char code[])
{
  if (recherche(entite) == -1)
  {
    strcpy(ts[CpTS].NomEntite, entite);
    strcpy(ts[CpTS].CodeEntite, code);
    CpTS++;
  }
}

// fonction qui insère le type d'une etité une fois il va être reconnu dans la syntaxe 
void insererType(char entite[], char type[])
{
    int posEntite=recherche(entite);
    if (posEntite!=-1) // si l'entité existe dans la TS
    { 
        strcpy(ts[posEntite].TypeEntite,type);
        //printf("lentite est %s, son type est %s\n",ts[posEntite].NomEntite,ts[posEntite].TypeEntite);
    }
}
void insererTypeTaille(char entite[], char type[], int t)
{
    int posEntite=recherche(entite);
    if (posEntite!=-1) // si l'entité existe dans la TS
    { 
        strcpy(ts[posEntite].TypeEntite,type);
        ts[posEntite].Taille=t;
        //printf("lentite est %s, son type est %s\n",ts[posEntite].NomEntite,ts[posEntite].TypeEntite);
    }
}


//fonction qui insere les valeurs
void insererTypeVal(char entite[], char type[],char val[])
{
    int posEntite=recherche(entite);
    if (posEntite!=-1) // si l'entité existe dans la TS
    { 
        strcpy(ts[posEntite].TypeEntite,type);
        strcpy(ts[posEntite].ValEntite,val);
        //printf("lentite est %s, son type est %s\n",ts[posEntite].NomEntite,ts[posEntite].TypeEntite);
    }
}

//fonction pour inserer les constantes
void insererValFixe(char entite[])
{
    int posEntite=recherche(entite);
    if (posEntite!=-1) // si l'entité existe dans la TS
    { 
        strcpy(ts[posEntite].ValFixe,"OUI");
        
        //printf("lentite est %s, son type est %s\n",ts[posEntite].NomEntite,ts[posEntite].TypeEntite);
    }
}

//fonction pour inserer les valeurs lors des instructions
void insererVal(char entite[],char val[])
{
    int posEntite=recherche(entite);
    if (posEntite!=-1) // si l'entité existe dans la TS
    { 
       
        strcpy(ts[posEntite].ValEntite,val);
        //printf("lentite est %s, son type est %s\n",ts[posEntite].NomEntite,ts[posEntite].TypeEntite);
    }
}


// Fonction RechercheType : retourne le type de l'entité
int rechercheType(char entite[])
{
    int posEntite=recherche(entite);
    if(strcmp(ts[posEntite].TypeEntite,"")==0) return 0; // l'entité n'est pas encore déclarée
    else return -1; // elle est déclarée
}


int verifTableau(char nom[],int indice, int line,char SaveType[]){
  if (rechercheType(nom)==0)  {printf("ErreuR semantique a la ligne %d, variable %s non declaree \n",line,nom); return 0;}
        else {if(ts[recherche(nom)].Taille==0) {printf("Erreur Semantique a la ligne %d: variable '%s' n'est pas un tableau!!\n",line,nom);  return 0; }   
        else {if(indice>=ts[recherche(nom)].Taille || indice<0 ) {printf("Erreur Semantique a la ligne %d : Index hors limites \n",line,nom); return 0;}                                          
        else{if(strcmp(SaveType,ts[recherche(nom)].TypeEntite)!=0) {printf("ErreuR semantique a la ligne %d, variables de type different %s \n",line,SaveType); return 0;}
        }}}
        return 1;
}




//Fonction d'affichage de la TS
void afficher()
{
  printf("\n/***************************Table des symboles *****************************/\n");
  printf("___________________________________________________________________________________________\n");
  printf("\t| NomEntite |  CodeEntite  | TypeEntite  | ValEntite   |  ValFixe    |  taille \n");
  printf("___________________________________________________________________________________________\n");
  int i = 0;
  while (i < CpTS)
  {
    printf("\t|%10s |%12s  |%12s |%12s |%12s |%12d |\n", ts[i].NomEntite, ts[i].CodeEntite,ts[i].TypeEntite,ts[i].ValEntite,ts[i].ValFixe,ts[i].Taille);
    i++;
  }
}
