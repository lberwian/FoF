#!/bin/bash
myprog=~/FoF/FoF/FoF
prog=~/FoF/FoF/calc
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
file="time.md"
count=0
while [ -f "$file" ];
do
	count=$((count+1))	
	file="time_$count.md"
done



echo "Arquivo: $arc / Raio = $R/ Nº elementos = $E / Execuções = $N / Escrita habilitado (S/N) = $save |" > $file
echo "-------------------------------------------------------------------------------------------" >> $file


a=0
resmax=0
resmin=0
while [ $a -ne $N ];
do
    
	 
	res1=$(date +%s.%N)
        $myprog "$arc" "$E" "$R" "$save"
	res2=$(date +%s.%N)
		
       	dt=$(echo "$res2 - $res1" | bc)

	if [ "$resmin" -e 0 -o "$resmin" -gt "$dt" ]; then
		resmin=$dt 
	fi
	
	if [ $dt > $resmax ]; then
		resmax=$dt
        fi
		
	$prog "$dt" $file "$a"
	
	a=$(($a+1))

done
$prog "$resmin" $file "Tempo minimo - "
$prog "$resmax" $file "Tempo maximo - "


lscpu >> $file
