#include <stdio.h>
#include<stdlib.h>
#include<math.h>
#include<string.h>
#include<fstream>
#include <iostream>
#include <vector>


void tempo_(float tempo,std::ofstream &out,char *def){


	int dias = tempo/86400;
	tempo = tempo-86400*dias;
	int horas = tempo/3600;	
	tempo = tempo-3600*horas;
	int minutos = tempo/60;
	double segundos = tempo-60*minutos;
	
 	out << def << "Total Runtime: "<< dias << ":" << horas  << ":" << minutos  << ":"<< segundos  << "|"<< std::endl;


}

void stats (std::ofstream &out,std::ifstream &in,char *def){


	std::string str;
	std::vector<float> vx;
	int count=0;
	float soma=0;
	float maior=0;
	float menor=0;

	while(!in.eof()) // To get you all the lines.
    {
	        getline(in,str); // Saves the line in STRING.
			float a = atof(str.c_str());
			if (a==0) break;
			if (maior < a) maior = a;
			if (menor == 0 || menor > a) menor=a;
			
			vx.push_back(a);
			std::cout<<vx[count]<<std::endl;
			
			soma=soma+vx[count];
			count++;

	        
    }
	soma=soma/(count);
	std::cout<<soma<<std::endl;
	std::cout<<menor<<std::endl;
	std::cout<<maior<<std::endl;
	
	
	
	
	
	if(def[0] == 'i'){
	
		tempo_(menor,out,"Menor/interna -");
		tempo_(maior,out,"Maior/interna - ");
		tempo_(soma,out,"Média/interna - ");
			out << "```<code>" << std::endl;
	}

	else{
		tempo_(menor,out,"Menor - ");
		tempo_(maior,out,"Maior - ");
		tempo_(soma,out,"Média - ");
	}
	return;

}
int main(int argc, char **argv){ 
	float tempo=atof(argv[1]);
	char *arquivo=argv[2];
	char *what=argv[3];
	char option=argv[4][0];
	std::ifstream in;
	if(argc>4)
		in.open(argv[5]);
	std::ofstream out;
	out.open(arquivo, std::ios::app);
	

	switch(option)
	{
		case 't':
			tempo_(tempo,out,what); break; 
		case 'c':
			stats(out,in,what); break;

	}

	return 0;
}
