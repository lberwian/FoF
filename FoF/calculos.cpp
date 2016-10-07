#include <stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string.h>
#include<fstream>

void tempo_ (float tempo,char *str,char *def){





	int dias = tempo/86400;
	tempo = tempo-86400*dias;
	int horas = tempo/3600;	
	tempo = tempo-3600*horas;
	int minutos = tempo/60;
	float segundos = tempo-60*minutos;

	 std::ofstream out;

 
	 out.open( str, std::ios::app);

 	 out << def << "Total Runtime: "<< dias << ":" << horas  << ":" << minutos  << ":"<< segundos  << "|"<< std::endl;




}


int main(int argc, char **argv){

	float tempo=atof(argv[1]);

	switch(argv[4][0])
	{
		case 't':
			tempo_ (tempo,argv[2],argv[3]); break; 
		case '+':
			max(); break;
		case '-':
			min(); break;

	}

	return 0;
}
