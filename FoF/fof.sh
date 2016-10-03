#!/bin/bash
myprog=~/fof/FoF/FoF
echo "Por favor insira o número de execuções: "
read -p "Número de execuções para o teste de desempenho " N 
read -p "Arquivo de entrada " arc 
read -p "Raio " R
read -p "Número de elementos " E
read -p "Para escrever o arquivo com resultados digite S/s, ou qualquer coisa para não: " save
if [ $save == "S"  ]; then
	echo "Isso"
else
	echo "Isso nao"
	save="N"
fi
echo "Arquivo: $arc / Raio = $R/ Nº elementos = $E / Execuções = $N / Escrita habilitado (S/N) = $save |" > time.md 
echo "-----------------------------------------------------------------------------------" >> time.md


a=0

while [ $a -ne $N ];
do
    
	 
	res1=$(date +%s.%N)
    $myprog "$arc" "$E" "$R" "$save"
	res2=$(date +%s.%N)
       
	dt=$(echo "$res2 - $res1" | bc)
	dd=$(echo "$dt/86400" | bc)
	dt2=$(echo "$dt-86400*$dd" | bc)
	dh=$(echo "$dt2/3600" | bc)
	dt3=$(echo "$dt2-3600*$dh" | bc)
	dm=$(echo "$dt3/60" | bc)
	ds=$(echo "$dt3-60*$dm" | bc) 
LANG=C	printf " $(($a+1)) - Total runtime: %d:%02d:%02d:%02f |\n"  $dd $dh $dm $ds >>time.md
  # echo "$dm:$ds |" >> time.md
	a=$(($a+1))

done

lscpu >> time.md

