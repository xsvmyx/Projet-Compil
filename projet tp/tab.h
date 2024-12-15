#include <stdlib.h>
#include <stdio.h>
#include <string.h>



typedef struct 
{
    char nomTableau[20];
    char typeTableau[20];
    int taille;
    int* adresseInt;
    float* adresseFloat;
    
}TabTs;

TabTs t [100];
int cpt = 0;

int rechercheTab(char entite[])
{
  int i = 0;
  while (i < cpt)
  {
    if (strcmp(entite, t[i].nomTableau) == 0)
        return i;
    i++;
  }

  return -1;
}

//création tableau
int* creerTableauINT(int taille ){

 int *tabInt = (int*)malloc( taille *sizeof(int)); 

 return tabInt;
}


float* creerTableauFloat(int taille){
   float *tabFloat = (float*)malloc(taille * sizeof(float));


    return tabFloat;
    
}



void inserertab(char entite[],char type[], int taille)
{
 strcpy(t[cpt].nomTableau,entite);
 strcpy(t[cpt].typeTableau,type);
 t[cpt].taille = taille;
 if(strcmp(type,"NUM")==0) t[cpt].adresseInt = creerTableauINT(taille);
 else
 if(strcmp(type,"REAL")==0) t[cpt].adresseFloat = creerTableauFloat(taille);

 cpt++;


}

void insererValCaseInt(char entite[],int val,int cas){
  
    t[rechercheTab(entite)].adresseInt[cas]=val;
}

void insererValCaseFloat(char entite[],float val,int cas){
 
  t[rechercheTab(entite)].adresseFloat[cas]=val;
   
}





void affichertab()
{
  printf("\n/**************Table des tableaux ***************/\n");
  printf("___________________________________________________________________________________________\n");
  printf("\t| NomEntite |TypeEntite |  taille  | adresseInt  |  adresseFloat \n");
  printf("___________________________________________________________________________________________\n");
  int i = 0;
  while (i < cpt)
  {
    printf("\t|%10s |%12s  |%12d  |%12d  |%12d |\n", t[i].nomTableau, t[i].typeTableau,t[i].taille,t[i].adresseInt,t[i].adresseFloat);
    i++;
  }
}  
