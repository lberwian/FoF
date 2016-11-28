/***************************************************************************
Programa que realiza o agrupamento de partículas de acordo com o raio de
percolação fornecido, usando o algoritmo Friends of Friends.
Ultima atualização 12/01/2009
Autor: Renata S. Rocha Ruiz
 ******************************************************************************/

using namespace std;
//---------------------------------------------------------------------------



#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <omp.h>
#include <sys/time.h>
#include <sstream>
#include <chrono>
#include <time.h>

#include "No.h"
#include "grupo.h"
#include "Corpo.h"
#include "common.h"
#include "Segmento.h"
#include "Tupla.h"


#include <vector>
#include <string>

#define debug false


int *igru, *iden, N;
float *x, *y, *z, *v1, *v2, *v3;

float max_x, min_x, max_y, min_y, max_z, min_z;
chrono::time_point<chrono::system_clock> start;
chrono::time_point<chrono::system_clock> final;
chrono::duration<double, ratio<1>> tempo_cro;
timeval tStart, tEnd;
timeval tempo_inicio, tempo_fim;

double ti = 0, tf = 0, tempo = 0;

double tempo_relabel = 0;
double tempo_verifica_grupo = 0;
double tempo_d = 0;

//float raio = 1.7; //1,7 p testes controlados
float raio = 0.1;
int No::numeroGrupos = 1;

vector<int> DivEntrada[8];

vector<Tupla*> t1, t2;
vector<int> r1, r2;

vector<grupo*> grupos_total;



//---------------------------------------------------------------------------
/********************* Lendo o arquivo de dados de entrada *****************/
//---------------------------------------------------------------------------

bool LeDados(char *fn) {
    int m;
    FILE *fp;
    fp = fopen(fn, "rt");

    fscanf(fp, "%d", &N);

    //********* alocando memória************//
    iden = new int [N + 1]; // indentificador da partícula
    igru = new int [N + 1]; // índice do grupo
    x = new float [N + 1]; // posição x da partícula;
    y = new float [N + 1]; // posição y da partícula;
    z = new float [N + 1]; // posição z da partícula
    v1 = new float [N + 1]; // coordenada x da velocidade
    v2 = new float [N + 1]; // coordenada y da velocidade
    v3 = new float [N + 1]; // coordenada z da velocidade
    fscanf(fp, "%d %f %f %f %f %f %f %d ", &m, &x[0], &y[0], &z[0], &v1[0], &v2[0], &v3[0], &iden[0]); //O: Valores de velocidade nao utilizados.
    igru[0] = 0;

    //set valores minimos e máximos
    max_x = min_x = x[0];
    max_y = min_y = y[0];
    max_z = min_z = z[0];

    for (int i = 1; i < N; i++) {// DA PRA PARALELIZAR AQUI.
        fscanf(fp, "%d %f %f %f %f %f %f %d ", &m, &x[i], &y[i], &z[i], &v1[i], &v2[i], &v3[i], &iden[i]);
        igru[i] = 0;
        if (x[i] > max_x)
            max_x = x[i];
        if (x[i] < min_x)
            min_x = x[i];
        if (y[i] > max_y)
            max_y = y[i];
        if (y[i] < min_y)
            min_y = y[i];
        if (z[i] > max_z)
            max_z = z[i];
        if (z[i] < min_z)
            min_z = z[i];
    }
    printf("\n Maximos e Minimos:\n\t x_max : %f \t y_max: %f \t z_max: %f \n\t x_min : %f \t y_min: %f \t z_min: %f \n", max_x, max_y, max_z, min_x, min_y, min_z);
    fclose(fp);
    return false;
}
//---------------------------------------------------------------------------
/**************************** Realiza o agrupamento ******************************/
//---------------------------------------------------------------------------

//void Friends(float *x, float *y, float *z, int *iden)

void Friends() {
    printf("\n Tempo n2 original\n");
    float dist, rperc;
    int i = 0;
    int k = 0;
    int j, l;

    //        printf("Raio de Percolação (em Mpc):");
    //        scanf("%f", &rperc);
    rperc = raio;
    printf("\nRaio = %f\n", rperc);

    //ORIGINAL! dont touch it!
    for (i = 0; i < N; i++) {
        k++; //set k pra 1, 0 é usado para quando a particula nao possui grupo
        while (igru[i] != 0)i++; // já tem designação, então passa para o próximo!
        igru[i] = k; //set identificar do grupo como indice k

        for (j = i; j < N; j++)//verifica todos os indices do vetor seguintes ao i.
        {
            if (igru[j] == k) //verifica se o vetor de identificação por grupos ja não poussui um valor previamente calculado
            {
                for (l = (i + 1); l < N; l++)//a partir do indice i+1 percorre o restante do vetor com o indice l
                {
                    if (igru[l] == 0)//caso o igrup ainda não tenha sido definido E a distancia entre as particulas j e l seja menor que rperc
                    {
                        dist = sqrt((x[j] - x[l])*(x[j] - x[l]) + (y[j] - y[l])*(y[j] - y[l]) + (z[j] - z[l])*(z[j] - z[l]));

                        //                        printf("\ndistancia : %d e %d é %f",iden[j],iden[l],dist);
                        if (dist <= rperc) {
                            igru[l] = k; //set o identificador do grupo como k.
                        }
                    }
                }
            }
        }
        //O:i=l;?
    }


    //    for (i = 0; i < N; i++) {
    //        k++; //set k pra 1, 0 é usado para quando a particula nao possui grupo
    //        while (igru[i] != 0)i++; // já tem designação, então passa para o próximo!
    //        igru[i] = k; //set identificar do grupo como indice k
    //
    //        for (j = i; j < N; j++)//verifica todos os indices do vetor seguintes ao i.
    //        {
    //            if (igru[j] == k) //verifica se o vetor de identificação por grupos ja não poussui um valor previamente calculado
    //            {
    //                for (l = (i + 1); l < N; l++)//a partir do indice i+1 percorre o restante do vetor com o indice l
    //                {
    //                    if (igru[l] == 0)//caso o igrup ainda não tenha sido definido E a distancia entre as particulas j e l seja menor que rperc
    //                    {
    //                        dist = sqrt((x[j] - x[l])*(x[j] - x[l]) + (y[j] - y[l])*(y[j] - y[l]) + (z[j] - z[l])*(z[j] - z[l]));
    //
    //                        //                        printf("\ndistancia : %d e %d é %f",iden[j],iden[l],dist);
    //                        if (dist <= rperc) {
    //                            igru[l] = k; //set o identificador do grupo como k.
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        //O:i=l;?
    //    }

#if debug==true
    for (i = 0; i < N; i++) {
        printf("\n no %d é grupo %d", iden[i], igru[i]);
    }
#endif
    //PRINT DE GRUPOS E SEUS ELEMENTOS (QUANDO O GRUPO TEM MAIS DE 1 CORPO)
    //        int contadornovo;
    //        for (int i = 0; i < N; i++) {
    //            //            printf("\nID: %d grupo %d", iden[i], igru[i]);
    //            int ngrupo = igru[i];
    //            contadornovo = 0;
    //            for (int j = i + 1; j < N; j++) {
    //                if (ngrupo == igru[j]) {
    //                    contadornovo++;
    //                    printf("\tcorpo %d pertence ao grupo %d\n", iden[j], ngrupo);
    //                }
    //            }
    //            if (contadornovo > 0) {
    //                printf("\tcorpo %d pertence ao grupo %d\n", iden[i], ngrupo);
    //                printf("grupo %d tem %d corpos\n", ngrupo, contadornovo + 1);
    //            }
    //        }

    /********************escrevendo arquivo de 
    ************************/
#ifdef SAVE
      char str1[10], str2[10];
    
        FILE *fp;
    
        int num;
        char resultado;
       num = sprintf(str2, "%.2lf", rperc);
    
       strcpy(str1, "Grupos_RP");
        strcat(str1, str2);
    
       fp = fopen(str1, "w");
    
       fprintf(fp, "%d %d \n", N, k);
    
       for (i = 0; i < N; i++)
          fprintf(fp, "%4d % 10d %4d % 10.6e % 10.6e % 10.6e % 10.6e % 10.6e % 10.6e \n", i, iden[i], igru[i], x[i], y[i], z[i],
                v1[i], v2[i], v3[i]);
    
        fclose(fp);
  #endif
       printf("Numero total de grupos: ");
       printf("%d \n", k);
    
       printf("Numero de nos: %d\n", N);

    /********* Calculando a quantidade de particulas por grupo ************/
    int nn, si, mult;
    int *Ngr;

    Ngr = new int [k + 1];
    for (nn = 1; nn <= k; nn++) {
        mult = 0;
        for (si = 0; si < N; si++)
            if (igru[si] == nn) mult = mult + 1;
        Ngr[nn] = mult;
    }


    int cont1 = 0;
    for (nn = 1; nn <= k; nn++)
        if (Ngr[nn] > 1) cont1++;

    printf("Grupos com massa maior que 1: %d \n", cont1);

    //    printf("Tempo de execução: %ld segundos e %ld microsegundos\n", tEnd.tv_sec - tStart.tv_sec, usec);

    delete Ngr;


}

//---------------------------------------------------------------------------
/**************************** Limpa a memória ******************************/
//---------------------------------------------------------------------------

void LimpaMemoria(void) {
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

//-------------------------CRIA ARVORE------------------------------------

void CriaArvore(Segmento *s, int quadro, vector<string> *log) {
    gettimeofday(&tempo_inicio, NULL);
    No::numeroGrupos = 0;
    int numeroGrupos = 0;
#if debug==true
    log->push_back("\nRaio utilizado: %.2f");
    printf("\n----------------------------------");
    printf("\nnlogn:");
    printf("\nRaio utilizado: %.2f", raio);
#endif

    //lista dos grupos
    s->l_grupos = new vector<grupo*>;

    //primeiro grupo
    grupo *g;
    g = new grupo(1);
    //primeiro corpo
    printf("\n\t Q%d, tamanho da entrada : %d", quadro, DivEntrada[quadro].size());
    if (DivEntrada[quadro].size() <= 0) {

#if debug==true
        printf("\n\n ENTRADA ZERADA\n\n");
        log->push_back("\n\n -- ENTRADA ZERADA -- \n\n");
#endif
        return;
    }

    float local_max_x, local_min_x, local_max_y, local_min_y, local_max_z, local_min_z;

    local_max_x = local_min_x = x[DivEntrada[quadro].at(0)];
    //    min_x = x[DivEntrada[quadro].at(0)];
    local_max_y = local_min_y = y[DivEntrada[quadro].at(0)];
    //    min_y = y[DivEntrada[quadro].at(0)];
    local_max_z = local_min_z = z[DivEntrada[quadro].at(0)];
    //    min_z = z[DivEntrada[quadro].at(0)];
    printf("\nQ:%d \tEntrada : %d corpos",quadro,DivEntrada[quadro].size());
    for (int i = 1; i < DivEntrada[quadro].size(); i++) {
//        printf("\nQ%d - check %d",quadro, DivEntrada[quadro].at(i));
//        printf("\n\tX:%f\tY:%f\tZ:%f",x[DivEntrada[quadro].at(i)],y[DivEntrada[quadro].at(i)],z[DivEntrada[quadro].at(i)]);
        int atual = DivEntrada[quadro].at(i);
        if (x[atual] > local_max_x)
            local_max_x = x[atual];
        if (x[atual] < local_min_x)
            local_min_x = x[atual];
        if (y[atual] > local_max_y)
            local_max_y = y[atual];
        if (y[atual] < local_min_y)
            local_min_y = y[atual];
        if (z[atual] > local_max_z)
            local_max_z = z[atual];
        if (z[atual] < local_min_z)
            local_min_z = z[atual];
    }

    //#if debug==true
    printf("\nLIMITES Segmento %d\n\t MAX \t\t MIN \nX:\t %f\t %f\nY:\t %f\t %f\nZ:\t %f\t %f\n",
            quadro, local_max_x, local_min_x, local_max_y, local_min_y, local_max_z, local_min_z);
    //#endif
    int frst = DivEntrada[quadro].at(0);

    Corpo *primeiro;
    primeiro = new Corpo(iden[frst], x[frst], y[frst], z[frst]);
    primeiro->igru = 1;

    s->l_grupos->push_back(g);
    s->l_grupos->at(0)->add_no(primeiro);
    No::numeroGrupos += 1;
    numeroGrupos++;
    //inicia arvore
    s->arvore = new No(primeiro, local_max_x, local_min_x, local_max_y, local_min_y, local_max_z, local_min_z);
    //    printf("\nprimeiro no: id %d\n", s->arvore->c->id);
    ostringstream stream;
    //    stream << "\nprimeiro no id :" << s->arvore->c->id;
    //    log->push_back(stream.str());
    s->arvore->populado = true;
    if (primeiro->x < s->arvore->f_xmin || primeiro->x > s->arvore->f_xmax ||
            primeiro->y < s->arvore->f_ymin || primeiro->y > s->arvore->f_ymax ||
            primeiro->z < s->arvore->f_zmin || primeiro->z > s->arvore->f_zmax) {
        s->arvore->fronteira.push_back(primeiro);
    }

    //    printf("\n\n");
    //adiciona demais corpos
    unsigned long int i;
    for (i = 1; i < DivEntrada[quadro].size(); i++) {
        frst = DivEntrada[quadro].at(i);

#if debug==true
        //        printf("\n--------------\n\t index:%d , index: %d e  id no : %d", i, frst, iden[frst]);
        stream.str("");
        //        stream << "\n--------------\n\t index: " << i << " , index: " << frst << " e  id no : " << iden[frst];
        log->push_back(stream.str());
#endif
        Corpo *seguinte = new Corpo(iden[frst], x[frst], y[frst], z[frst]);
        s->arvore->add(s->l_grupos, seguinte, local_max_x, local_min_x, local_max_y, local_min_y, local_max_z, local_min_z, &numeroGrupos, log);
    }
    //    if (s->arvore->fronteira.size() != 0) {
    //        printf("\n size fronteira: %d", s->arvore->fronteira.size());
    //        for (int i = 0; i < s->arvore->fronteira.size(); i++) {
    //            printf("\n\t id:%d", s->arvore->fronteira.at(i)->id);
    //        }
    //    }

    gettimeofday(&tempo_fim, NULL);

   // tf = (double) tempo_fim.tv_usec + ((double) tempo_fim.tv_sec * (1000000.0));
   // ti = (double) tempo_inicio.tv_usec + ((double) tempo_inicio.tv_sec * (1000000.0));
    tempo = (tf - ti) / 1000;

    //    printf("\n Numero de grupos : %d\n", No::numeroGrupos);
    //    printf("\n Numero de grupos : %d\n", numeroGrupos);

    //    printf("\ntestando acesso a nó %d\n", s->l_grupos->at(0)->lista->at(0)->id);
    //    int gp = 0;
    //    for (int x = 0; x < s->l_grupos->size(); x++) {
    //        //printf("\nG:%d size : %d", x, s->l_grupos->at(x)->lista->size());
    //        if (s->l_grupos->at(x)->lista->size() > 1) {
    //            gp++;
    //        }
    //    }
    //
    //    printf("\n Grupos com massa maior que 1 : %d", gp);
}

void DivideEntrada() {
    float meioX = min_x + ((max_x - min_x) / 2);
    float meioY = min_y + ((max_y - min_y) / 2);
    float meioZ = min_z + ((max_z - min_z) / 2);
    printf("\nMX: %f\nMY: %f\nMZ: %f", meioX, meioY, meioZ);
    int quadro;
#if paralelo==1

//#pragma omp parallel for
    for (int contador = 0; contador < N; contador++) {
        quadro = 0;
        if (x[contador] > meioX) {
            quadro += 1;
        }                                                   
        if (y[contador] > meioY) {
            quadro += 2;
        }
        if (z[contador] > meioZ) {
            quadro += 4;
        }
        DivEntrada[quadro].push_back(contador);
    }
#endif
    
    //#if debug==true
    printf("\n\nEntrada dividida:");
    for (int c = 0; c < 8; c++) {
        printf("\nQuadro %d", c);
//        int i;
        //        for (i = 0; i < DivEntrada[c].size(); i++) {
        //            printf("\n\tcorpo index : %d   \t id: %d", DivEntrada[c].at(i), iden[DivEntrada[c].at(i)]);
        //        }
        printf("\n\tnumero total corpos : %d", DivEntrada[c].size());
    }
    //#endif
}

float verif(Corpo* n1, Corpo* n2) {
    return sqrt(pow(n1->x - n2->x, 2) + pow(n1->y - n2->y, 2) + pow(n1->z - n2->z, 2));
}

main(int argc, char **argv) {
    //float local_v[100];
    char *Arg1;
    if (argc != 2) {
        puts("Por favor entre com o nome do arquivo de dados! ");
        getchar();
        exit(1);
    }

    puts("Iniciando...");
    Arg1 = argv[1];
start = chrono::system_clock::now();
    LeDados(Arg1);
#if Range>0
	if(Range<=N)
		N=Range;
    printf("\n Entrada : %d dados", N);
#endif
#if Raio>0
	raio=Raio;
    printf("\nraio = %f", raio);
    
#endif 
#if original==1
    printf("\nOriginal Executando\n");
#endif
#if paralelo==1
    printf("\nOpenMP Executando\n");
#endif
    //gettimeofday(&tempo_inicio, NULL);

#if original==0

#if paralelo==1 
    	printf("asdasd");
        DivideEntrada();
        vector<string> logs[8];
        Segmento root[8];
        int i;
#pragma omp parallel for
        for (i = 0; i < 8; i++) {
            //            max_x = min_x = max_y = max_z = min_z = min_y = 0;

#if debug==true
            //            printf("\n\n\tSEGMENTO %d\n", i);
            //            logs[i].push_back("Primeiro Log");
#endif
            CriaArvore(&root[i], i, &logs[i]);
            //#if debug==true
            printf("\nSEMICUBO %d \t size grupos : %d", i, root[i].l_grupos->size());
            printf("\n----------------------- IMPRIMINDO GRUPOS ------------------------\n");
            //                        for (int y = 0; y < root[i].l_grupos->size(); y++) {
            //                            printf("\n\t sub - Grupo %d contem %d corpos", y, root[i].l_grupos->at(y)->lista->size());
            //                            for (int w = 0; w < root[i].l_grupos->at(y)->lista->size(); w++) {
            //                                printf("\n\t\t id: %d", root[i].l_grupos->at(y)->lista->at(w)->id);
            //                }
            //                        }
            //                        printf("\n----------------------\n");
            //
            printf("\nTerminou loop %d \n", i);
            //#endif
        }
        //        for (int x = 0; x < 7; x++) {
        //            for (int i = 0; i < logs[x].size(); i++) {
        //                printf("\nLOG %d -> ", x);
        //                printf(logs[x].at(i).c_str());
        //            }
        //        }
        printf("\n-----\n");
        printf("\nVerificando zonas de fronteira\n");

        //print zonas de fronteira
        for (int i = 0; i < 8; i++) {
            if (root[i].l_grupos->size() == 0) {
                printf("\n Root %d tem 0 grupos", i);
                continue;
            }
            printf("\n Root %d tem %d grupos", i, root[i].l_grupos->size());
            printf("\n\t Fronteira de seg %d", i);
            printf("\n\t Numero de nos na fronteira: %d", root[i].arvore->fronteira.size());
            //            for (int j = 0; j < root[i].arvore->fronteira.size(); j++) {
            //                printf("\n\t ID : %d", root[i].arvore->fronteira.at(j)->id);
            //            }
        }
        printf("\n-----\n");
        //comprar zonas de fronteiras
        for (int x = 0; x < 7; x++) {
            //            printf("\n x=%d \n", x);
            if (root[x].l_grupos->size() <= 0) {

                printf("\nPULOU SEGMENTO %d", x);

                continue;
            }

            printf("\nVERIFICANDO SEGMENTO %d", x);
            //            for (int i = 0; i < root[x].l_grupos->size(); i++) {
            //                printf("\n\tGRUPO %d", root[x].l_grupos->at(i)->getI_gru());
            //            }
            for (int y = x + 1; y < 8; y++) {
                if (root[y].l_grupos->size() <= 0) {
                    printf("\n\tCOMPARA COM SEGMENTO %d\t size: Zero", y);
                    continue;
                }
                printf("\n\tCOMPARA COM SEGMENTO %d", y);
                //verificar grupos ligados via zona de fronteira.
                for (int i = 0; i < root[x].arvore->fronteira.size(); i++) {
                    Corpo *c1 = root[x].arvore->fronteira.at(i);

                    //                    printf("\n i=%d, ID = %d, IGRU = %d", i, c1->id, c1->igru);
                    for (int j = 0; j < root[y].arvore->fronteira.size(); j++) {
                        Corpo *c2 = root[y].arvore->fronteira.at(j);
                        //                        printf("\n j=%d, ID = %d", j, c2->id);
                        float dist = verif(c1, c2);
                        //                        printf("\n\t dist : %.2f", dist);
                        if (dist < raio) {
                            bool teste = false;
                            //                            printf("\nRELABEL ENTRA GRUPO\n\t %d do segmento %d \n\t%d do segmento %d\n", root[x].arvore->fronteira.at(i)->igru, x + 1, root[y].arvore->fronteira.at(j)->igru, y + 1);
                            for (int z = 0; z < t1.size(); z++) {
                                if (t1.at(z)->segmento == x && t1.at(z)->ngrupos == root[x].arvore->fronteira.at(i)->igru) {
                                    if (t2.at(z)->segmento == y && t2.at(z)->ngrupos == root[y].arvore->fronteira.at(j)->igru)
                                        //                                        printf("\nSemelhanca de grupos ja existente \n");
                                        //                                    printf("\nsemelhanca entre S%dG%d e S%dG%d", x + 1, root[x].arvore->fronteira.at(i)->igru, y + 1, root[y].arvore->fronteira.at(j)->igru);
                                        teste = true;
                                }
                            }
                            if (!teste) {
                                t1.push_back(new Tupla(root[x].arvore->fronteira.at(i)->igru, x));
                                t2.push_back(new Tupla(root[y].arvore->fronteira.at(j)->igru, y));

#if debug==true
                                printf("\nAdicionou semelhanca : S%d-G%d e S%d-G%d", x + 1, root[x].arvore->fronteira.at(i)->igru, y + 1, root[y].arvore->fronteira.at(j)->igru);
#endif
                            } else {
                                //                                printf("\n Semelhança já existe");
                            }
                        } else {
                            //                            printf(".");
                        }
                    }
                }
            }
        }
        for (int i = 0; i < 8; i++) {
            for (int y = 0; y < root[i].l_grupos->size(); y++) {
                grupos_total.push_back(root[i].l_grupos->at(y));
            }
        }
        printf("\nsize tupla(Semelhanças) %d", t1.size());
        for (int i = 0; i < t1.size(); i++) {
            Tupla *p1 = t1.at(i);
            int contador = 0;
            for (int j = 0; p1->segmento > j; j++) {
                contador += root[j].l_grupos->size();
            }
            contador += p1->ngrupos;

#if debug==true
            printf("\n S%d-G%d", t1.at(i)->segmento, t1.at(i)->ngrupos);
            printf(" vira o no %d\n", contador);
#endif
            Tupla *p2 = t2.at(i);
            int contador2 = 0;
            for (int j = 0; p2->segmento > j; j++) {
                contador2 += root[j].l_grupos->size();
            }
            contador2 += p2->ngrupos;

#if debug==true
            printf("\n S%d-G%d", t2.at(i)->segmento, t2.at(i)->ngrupos);
            printf(" vira o no %d\n", contador2);
#endif
            r1.push_back(contador);
            r2.push_back(contador2);
        }

#if debug==true
        printf("\nsize tupla %d", r1.size());
        printf("\tNumero total de grupos: %d", grupos_total.size());
#endif


#if debug==true
        for (int i = 0; i < t1.size(); i++) {
            printf("\n S%d-G%d", t1.at(i)->segmento, t1.at(i)->ngrupos);
            printf(" e S%d-G%d", t2.at(i)->segmento, t2.at(i)->ngrupos);
            printf("\t G %d e G %d ,size1: %d e size2: %d", r1.at(i), r2.at(i), grupos_total.at(r1.at(i) - 1)->lista->size(), grupos_total.at(r2.at(i) - 1)->lista->size());
        }
#endif
        while (r1.size() != 0) {
            vector<int> iguais;
            iguais.push_back(r1.at(0));
            for (int j = 0; j < iguais.size(); j++) {
                int atual = iguais.at(j);
                for (int conta1 = 0; conta1 < r1.size(); conta1++) {
                    if (r1.at(conta1) == atual) {
                        iguais.push_back(r2.at(conta1));
                        r2.erase(r2.begin() + conta1);
                        r1.erase(r1.begin() + conta1);
                    }
                }
                for (int conta1 = 0; conta1 < r2.size(); conta1++) {
                    if (r2.at(conta1) == atual) {

#if debug==true
                        printf("\n s Adiciona %d ao vetor", r1.at(conta1));
#endif
                        iguais.push_back(r1.at(conta1));
                        r2.erase(r2.begin() + conta1);
                        r1.erase(r1.begin() + conta1);
                    }
                }

            }

#if debug==true
            printf("\n iguais:");
            for (int x = 0; x < iguais.size(); x++) {
                printf("\n\t Grupo %d", iguais.at(x));
            }
#endif
            for (int x = 1; x < iguais.size(); x++) {

#if debug==true
                printf("\ntamanho q sera adicionado : %d", grupos_total.at(iguais.at(x) - 1)->lista->size());
                printf("GRUPO %d", iguais.at(x));
#endif
                for (int y = 0; y < grupos_total.at(iguais.at(x) - 1)->lista->size(); y++) {
                    grupos_total.at(iguais.at(0) - 1)->lista->push_back(grupos_total.at(iguais.at(x) - 1)->lista->at(y));
                }

#if debug==true
                printf("\n\tsize do 1o após add\t  %d\n", grupos_total.at(iguais.at(0) - 1)->lista->size());
#endif
                //                grupos_total.erase(grupos_total.begin()+iguais.at(x)-1); // se apagar perde o referencial de index
                grupos_total.at(iguais.at(x) - 1)->lista->clear();



                //                printf("\nsize do 1o: %d", grupos_total.at(iguais.at(0) - 1)->lista->size());
                //                printf("\neliminando o grupo %d\n", iguais.at(x));
                //                grupos_total.erase(grupos_total.begin()+iguais.at(x));//                eliminar grupos vazios ao final
            }

        }

        //        printf("\nnumero de grupos %d", grupos_total.size());

        //elimina grupos vazios
        printf("\n Limpa grupos vazios");
        for (int contador = 0; contador < grupos_total.size(); contador++) {
            if (grupos_total.at(contador)->lista->size() == 0) {
                grupos_total.erase(grupos_total.begin() + contador);
                contador--;
            }
        }
        printf("\nnumero de grupos %d", grupos_total.size());
        int cont = 0;
        for (int contador = 0; contador < grupos_total.size(); contador++) {
            if (grupos_total.at(contador)->lista->size() > 1) {
                cont++;
            }
        }
        int tamanho = 0;
        for (int contador = 0; contador < grupos_total.size(); contador++) {
            tamanho += grupos_total.at(contador)->lista->size();
#if debug==true
            //            printf("\n G %d size: %d", contador, grupos_total.at(contador)->lista->size());
            //            for (int j = 0; j < grupos_total.at(contador)->lista->size(); j++) {
            //                printf("\n\t id : %d", grupos_total.at(contador)->lista->at(j)->id);
            //            }
#endif
        }

#if debug==true
        printf("\n tamanho: %d", tamanho);
#endif
        gettimeofday(&tempo_fim, NULL);
        tf = (double) tempo_fim.tv_usec + ((double) tempo_fim.tv_sec * (1000000.0));
        ti = (double) tempo_inicio.tv_usec + ((double) tempo_inicio.tv_sec * (1000000.0));
        tempo = (tf - ti) / 1000;
        printf("\nTempo total :    %.5f (ms)\n", tempo);
        printf("\nnumero de grupos %d", grupos_total.size());
        printf("\nNumero de grupos + 1 elemento: %d", cont);
#endif
#if paralelo==0 //verificar p/ nao paralelo
        printf("\n--------------------------------------------------");
        printf("\n\t\tSERIAL");


        for (int i = 0; i < N; i++) {
            DivEntrada[0].push_back(i);
        }
        Segmento s;
        vector<string> log;
        CriaArvore(&s, 0, &log);

#if debug==true
        //                for (int i = 0; i < s.l_grupos->size(); i++) {
        //                    printf("\n Grupo %d size: %d", i + 1, s.l_grupos->at(i)->lista->size());
        //            for (int j = 0; j < s.l_grupos->at(i)->lista->size(); j++) {
        //                printf("\n\t ID: %d", s.l_grupos->at(i)->lista->at(j)->id);
        //            }
        //        }
#endif
        int cont = 0;
        // printf("\n---------------LIMPANDO----------------");
        for (int x = 0; x < s.l_grupos->size(); x++) {
            //printf("\nG %d size: %d", x, s.l_grupos->at(x)->lista->size());
            if (s.l_grupos->at(x)->lista->size() == 0) {
                s.l_grupos->erase(s.l_grupos->begin() + x);
                x--;
                //                 printf("\napagou");
            } else {
                if (s.l_grupos->at(x)->lista->size() > 1) {
                    cont++;
                }
            }
        }
        //      IMPRIME TEMPO 

        gettimeofday(&tempo_fim, NULL);
        tf = (double) tempo_fim.tv_usec + ((double) tempo_fim.tv_sec * (1000000.0));
        ti = (double) tempo_inicio.tv_usec + ((double) tempo_inicio.tv_sec * (1000000.0));
        tempo = (tf - ti) / 1000;
        printf("\nTempo total :    %.5f (ms)\n", tempo);


        //        printf("\n-------------------IMPRIME GRUPOS-----------------");
        //        int cont2 = 0;
        //        int cont3 = 0;
        //        for (int i = 0; i < s.l_grupos->size(); i++) {
        //            if (s.l_grupos->at(i)->lista->size() == 1) {
        //                cont2++;
        //                cont3++;
        //            } else {
        //                if (s.l_grupos->at(i)->lista->size() > 1) {
        //                    printf("\n G %d size: %d", i, s.l_grupos->at(i)->lista->size());
        //                    cont3 += s.l_grupos->at(i)->lista->size();
        //                    for (int j = 0; j < s.l_grupos->at(i)->lista->size(); j++) {
        //                        printf("\n\t id : %d", s.l_grupos->at(i)->lista->at(j)->id);
        //                    }
        //                }
        //            }
        //        }
        printf("\nNumero de grupos: %d", s.l_grupos->size());
        printf("\nNumero de grupos + 1 elemento: %d", cont);
        //        printf("\nNumero de grupos exatamente 1 elemento: %d", cont2);
        //        printf("\nNumero de corpos nos grupos: %d", cont3);
#endif
#endif
#if original==1
    Friends();
#endif
    gettimeofday(&tempo_fim, NULL);
    tf = (double) tempo_fim.tv_usec + ((double) tempo_fim.tv_sec * (1000000.0));
    ti = (double) tempo_inicio.tv_usec + ((double) tempo_inicio.tv_sec * (1000000.0));
    final = std::chrono::system_clock::now();		

    tempo_cro = final-start;
    tempo = (tf - ti) / 1000;
    printf("\nTempo total :    %.5f (ms)\n", tempo);
    printf("\nFIM EXECUCAO\n\n");
    printf("%f", tempo_cro);
#if original==1
    LimpaMemoria();
#endif


    return 0;
}
