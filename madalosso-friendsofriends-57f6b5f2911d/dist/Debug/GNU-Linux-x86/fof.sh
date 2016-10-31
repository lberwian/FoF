#!/bin/bash
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

myprog="$SCRIPTPATH/friendsofriends"
prog="$SCRIPTPATH/calc" 

echo "Por favor insira o número de execuções: "
read -p "Número de execuções para o teste de desempenho " N 
read -p "Arquivo de entrada " arc 
read -p "Raio " R
read -p "Número de elementos " E
# read -p "Para escrever o arquivo com resultados digite S ou s, ou qualquer coisa para não: " save
read -p "Para adicionar o cálculo do tempo internamente ao algoritmo FoF digite S ou s, ou qualquer coisa para não: " interno

#if [ "$save" != "S" ] && [ "$save" != "s" ]; then
#	make -C ~/madalosso-friendsofriends-57f6b5f2911d/ main
	#make -C ~/madalosso-friendsofriends-57f6b5f2911d/
	#save="N"
	#else
#	make -C ~/madalosso-friendsofriends-57f6b5f2911d/ main CXXFLAGS=-DSave
#	make -C ~/madalosso-friendsofriends-57f6b5f2911d/
#fi
make -C ~/madalosso-friendsofriends-57f6b5f2911d/ main CXXFLAGS=-DRange=$E CCFLAGS=-DRaio=$R
make -C ~/madalosso-friendsofriends-57f6b5f2911d/
if [ "$interno" != "S" ] && [ "$interno" != "s" ]; then

	interno="N"
fi

file="time.md"
file1="time_ns.md"
file2="timein_ns.md"
count=0

while [ -f "$file" ];
do
	count=$((count+1))	
	file="time_$count.md"
	file1="time_ns_$count.md"
	file2="timein_ns_$count.md"

done

echo "Arquivo: $arc / Raio = $R/ Nº elementos = $E / Execuções = $N / T exec interno = $interno |" > $file
echo "-------------------------------------------------------------------------------------------------------------------------------" >> $file

a=0
var="buffer.txt"
while [ $a -ne $N ];

do 
 	res1=$(date +%s.%N)
   # var=`$myprog "$arc" "$E" "$R" "$save" "$interno"` 
    $myprog "$arc" > $var
    var1=$(tail "-1" "$var")
    res2=$(date +%s.%N)
    dt=$(echo "$res2 - $res1" | bc)
    echo "$var1" >> $file2
	echo "$dt" >> $file1
	if [ "$interno" == "S" ] || [ "$interno" == "s" ]; then
		$prog "$var1" $file "in - " "t"
	fi
	$prog "$dt" $file "$a - " "t"
	a=$(($a+1))

done

if [ "$interno" == "S" ] || [ "$interno" == "s" ]; then

	$prog "0" "$file" "i" "c" "$file2"

fi

$prog "0" "$file" "0" "c" "$file1"

lscpu >> $file
