/***************************************************************************
Programa que realiza o agrupamento de partículas de acordo com o raio de 
percolação fornecido, usando o algoritmo Friends of Friends.  
Ultima atualização 12/01/2009
Autor: Renata S. Rocha Ruiz
******************************************************************************/

//---------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <fstream>
#include <chrono>

//---------------------------------------------------------------------------
//2clock_t tempo_inicial, tempo_final;
int  *igru, *iden, N;
float  *x, *y, *z, *v1, *v2, *v3;
std::chrono::time_point<std::chrono::system_clock> start;
  // última vez que uma movimentação foi feita
 std::chrono::time_point<std::chrono::system_clock> end;


//---------------------------------------------------------------------------
/********************* Lendo o arquivo de dados de entrada *****************/
//---------------------------------------------------------------------------
bool LeDados(char *fn,int limit)
  {
  int m;
  float vx, vy, vz;
  FILE  *fp;
  fp = fopen(fn,"rt");
 
  fscanf (fp, "%d", &N);
  if(N>limit)
	N=limit;
 	printf("%d\n",N);
 // tempo_inicial = clock();
	 start = std::chrono::system_clock::now();
//********* alocando memória************//
  iden  = new int [N+1];  // indentificador da partícula
  igru  = new int [N+1];  // índice do grupo
  x  = new float [N+1];  // posição x da partícula;
  y  = new float [N+1];  // posição y da partícula;
  z  = new float [N+1];  // posição z da partícula
  v1 = new float [N+1];  // coordenada x da velocidade
  v2 = new float [N+1];  // coordenada y da velocidade
  v3 = new float [N+1];  // coordenada z da velocidade

  for (int i = 0 ; i < N ; i++)
    {
    //fscanf (fp, "%f  %f %f %f  %f %f %f ",&x[i], &y[i],&z[i],&v1[i],&v2[i],&v3[i],&iden[i]);
    fscanf (fp, "%d %f %f %f  %f %f %f %d ", &m , &x[i], &y[i],&z[i],&v1[i],&v2[i],&v3[i],&iden[i]);    
	//printf ("%d %f %f %f %f %f %f %d \n ", m , x[i], y[i], z[i],v1[i],v2[i],v3[i],iden[i]);    
    igru[i] = 0;
    }
  
 
  fclose (fp);
  return false;
  }
 //---------------------------------------------------------------------------
/**************************** Realiza o agrupamento ******************************/ 
//---------------------------------------------------------------------------

//void Friends(float *x, float *y, float *z, int *iden)
void Friends(float rperc, int read)
  {
   
  float dist;
  int i = 0;
  int k = 0;
  int j, l;
 
  //printf ("Raio de Percolação (em Mpc):");
 // scanf("%f", &rperc);

  for (i = 0; i < N; i++)
    {
    k++;
    
    while (igru[i] != 0 )i++; // já tem designação, então passa para o próximo!
            
    igru[i] = k;
      
    for (j = i ; j < N ; j++)
      { 
      if(igru[j] == k) 
        { 
        for (l = (i + 1) ; l < N ; l++)  
          {
          if (igru[l] == 0) 
            {
            dist = sqrt((x[j] - x[l])*(x[j] - x[l]) + (y[j] - y[l])*(y[j] - y[l]) + (z[j] - z[l])*(z[j] - z[l]) );
            if (dist <= rperc) 
              {
              igru[l] = k;
              }
             }
           }
         } 
       }
       
     }
 // tempo_final = clock();
	 end = std::chrono::system_clock::now();
 // double tempo = (tempo_final-tempo_inicial)/(double)CLOCKS_PER_SEC;
  std::chrono::duration<double, std::ratio<1>> tempo = end-start;
	
  //auto tempo=	 std::chrono::duration_cast<std::chrono::duration<float>>(temp);
	
        printf("%f\n",tempo);
  char cmdLine[1000];
  char a[] = {"timein.md"};
  char b[100000];
  sprintf(b,"%.6f",tempo);
  sprintf(cmdLine,"~/FoF/FoF/internal.sh %f %d %f",tempo,N,rperc);
  system(cmdLine);

  if(read != 'S' && read != 's')
	return;
  

/********************escrevendo arquivo de saida ************************/
  
  
  char str1[10],str2[10];

  FILE *fp;
  
  int num;
  char resultado;
  num = sprintf(str2, "%.2lf", rperc);

  strcpy(str1, "Grupos_RP");
  strcat(str1,str2);
  
  fp = fopen(str1,"w");

  fprintf(fp, "%d %d \n", N, k);
  
  for (i = 0 ; i < N ; i++)
  fprintf(fp,"%4d % 10d %4d % 10.6e % 10.6e % 10.6e % 10.6e % 10.6e % 10.6e \n", i,iden[i],igru[i],x[i], y[i],z[i],
  v1[i], v2[i],v3[i]);

  fclose (fp);
  
  printf("Numero total de grupos: ");
  printf("%d \n", k);

  /********* Calculando a quantidade de particulas por grupo ************/
  int nn, si, mult;
  int *Ngr; 
  
  Ngr  = new int [k+1];
    for ( nn = 1; nn <= k; nn++ )
      {
      mult = 0;
      for (si = 0; si < N; si++)
        if(igru[si] == nn) mult =  mult + 1;
        Ngr[nn] = mult;
       }
        
       
  int cont1 = 0;
  for (nn = 1 ; nn <= k ; nn++)
    if (Ngr[nn] > 1) cont1++; 
      
    printf("Grupos com massa maior que 1: %d \n", cont1);
  
  delete Ngr;
  
  }

//---------------------------------------------------------------------------
/**************************** Limpa a memória ******************************/
//---------------------------------------------------------------------------
void LimpaMemoria(void)
  {
  delete iden;
  delete igru;
  delete x; 
  delete y;
  delete z;
  delete v1;
  delete v2;
  delete v3;
  }
//---------------------------------------------------------------------------
/***************************************************************************/
//---------------------------------------------------------------------------

int main(int argc, char **argv)
  {
  float  local_v[100] ;
 // char *Arg1;
  

  if(argc < 4 || argc > 5 )
    {
    puts( "MODO DE USO: ./FoF 'arquivo' 'limite de dados de entrada' 'Raio de Percolação' 'Escrita dos Resultados (S/s)' \n Ex: ./FoF V000_part_cut 10 2 S ");
    getchar();
    exit(1);
    }
  puts ("Iniciando...");
  float raio = atof(argv[3]);
  int limit=atoi(argv[2]);
  char *Arg1 = argv[1];
  int read = argv[4][0];
  
 

  LeDados(Arg1,limit);
  Friends(raio,read);
  LimpaMemoria();
 /* std::ofstream entrada("tempos.md");
  std::string a;
  entrada << "N="<< argv[2]<< " Raio="<<argv[3]<<" Arquivo: " <<argv[1]<< "|" <<std::endl;

  */
  printf(" Terminou \n");
 
  return 0;
  }
