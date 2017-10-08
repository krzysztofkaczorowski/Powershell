// lista_krawedzi.cpp : main project file.

#include "stdafx.h"
#include <iostream>
#include <time.h>

using namespace std;
class lista_k
{
public:
	int tab[3];
	int wieszcholki;

	lista_k();
	lista_k(int, int, int);
	~lista_k();

	void wyprowadz();
	int losuj(int,int,int);
};

lista_k* generuj(int,int,int);

lista_k::lista_k()
{
	tab[0]=0;
	tab[1]=0;
	tab[2]=0;
}

lista_k::lista_k(int wieszcholek1, int wieszcholek2, int waga)
{
	tab[0]=wieszcholek1;
	tab[1]=wieszcholek2;
	tab[2]=waga;
}
lista_k::~lista_k()
{
	tab[0]=0;
	tab[1]=0;
	tab[2]=0;
}
lista_k* generuj(int ile_krawedzi, int ile_wieszcholkow, int max_waga)
{
	int w1, w2, w, k=0, p=0;
	lista_k *lista_krawedzi;
	srand(time(NULL));
	lista_krawedzi=new lista_k[ile_krawedzi];
	k=ile_wieszcholkow;
	for(int i=0;i<ile_krawedzi-1;i+k)
	{
		w=rand() % max_waga +1;
		for(int j=0+p;j<ile_wieszcholkow-2;j++)
		{
			lista_krawedzi[j].tab[0]=i+1;
			lista_krawedzi[j].tab[1]=j+2;
			j=k;
			p=j+p;
		}
	}
	return lista_krawedzi;
}
int lista_k::losuj(int wiesz, int ile_wiesz, int waga)
{
	int i=0;
	ile_wiesz=ile_wiesz-1;
	while(ile_wiesz)
	{
		this->tab[0]=wiesz;
		this->tab[1]=i+1;
		this->tab[2]=waga;
		ile_wiesz--;
		i++;
	}
	return ile_wiesz;
}

void lista_k::wyprowadz()
{
		cout<<this->tab[0]<<" "<<this->tab[1]<<" "<<this->tab[2]<<endl;
}
int main()
{
  int wiesz, kraw, m_waga;
  lista_k *lista_kraw;
	
  cout<<"Podaj liczbe wieszcholkow, krawedzi oraz maksymalna wage"<<endl;	
  cin>>wiesz
	  >>kraw
	  >>m_waga;
  lista_kraw = generuj(kraw, wiesz, m_waga);
  
  for(int i=0; i<kraw; i++)
  {
	  cout<<i+1<<") ";
		  lista_kraw[i].wyprowadz();
  }

  system("pause") ;
  return EXIT_SUCCESS;
}
