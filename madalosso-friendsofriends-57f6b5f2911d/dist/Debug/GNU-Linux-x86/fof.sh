#!/bin/bash
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

prog="$SCRIPTPATH/calc"

echo "Por favor insira o número de execuções: "
read -p "Número de execuções para o teste de desempenho " N
read -p "Arquivo de entrada " arc
read -p "Raio " R
read -p "Número de elementos " E
read -p "Para escrever o arquivo com resultados digite S ou s, ou qualquer coisa para não: " save
read -p "Para adicionar o cálculo do tempo internamente ao algoritmo FoF digite S ou s, ou qualquer coisa para não: " interno
read -p "Para habilitar o método original digite S ou s: " original
if [ "$save" != "S" ] && [ "$save" != "s" ]; then
	save1=0
	save=S
else
	save1=1
fi

if [ "$original" != "S" ] && [ "$original" != "s" ]; then

	make -C ~/madalosso-friendsofriends-57f6b5f2911d/ main CXXFLAGS=-DRange=$E CCFLAGS=-DRaio=$R CXXFLAGS1=-Doriginal=0 CXXFLAGS2=-Dparalelo=1 CXXFLAGS3=-Dthread=0
	make -C ~/madalosso-friendsofriends-57f6b5f2911d/
	original="N"
	paralelo="S"
	else
	read -p "Para habilitar o método original C/ PARARELISMO digite S ou s: " thread

		if [ "$thread" != "S" ] && [ "$thread" != "s" ]; then
			g++ -o FoF FoF02.cpp -std=c++11 -DRange=$E -DRaio=$R -DSave=$save1
			myprog="$SCRIPTPATH/FoF"
#make -C ~/madalosso-friendsofriends-57f6b5f2911d/ main CXXFLAGS=-DRange=$E CCFLAGS=-DRaio=$R CXXFLAGS1=-Doriginal=1 CXXFLAGS2=-Dparalelo=0 CXXFLAGS3=-Dthread=0
#make -C ~/madalosso-friendsofriends-57f6b5f2911d/ FUNCIONA, MAS USO DO CÓDIGO LIMPO ORIGINAL PARA MELHORES RESULTADOS.
#myprog="$SCRIPTPATH/friendsofriends"

		else
			read -p "Habilitar versão para definir o número de threads usado na parelização, digite S ou s: " threads
			if [ "$threads" != "S" ] && [ "$threads" != "s" ]; then
				g++ -o FoF02 FoF02Parallel.cpp -fopenmp -std=c++11 -DRange=$E -DRaio=$R -DSave=$save1
				myprog="$SCRIPTPATH/FoF02"
			else
				read -p "Quantas threads você deseja: " threads
				make CFLAGS0=-DThread=$threads CFLAGS1=-DRange=$E CFLAGS2=-DRaio=$R CFLAGS3=-DSave=$save1
				myprog="$SCRIPTPATH/FoF03"
			fi
#make -C ~/madalosso-friendsofriends-57f6b5f2911d/ main CXXFLAGS=-DRange=$E CCFLAGS=-DRaio=$R CXXFLAGS1=-Doriginal=1 CXXFLAGS2=-Dparalelo=0 CXXFLAGS3=-Dthread=1 CXXFLAGS4=-fopenmp
#make -C ~/madalosso-friendsofriends-57f6b5f2911d/ FUNCIONA, MAS COM DESEMPENHO PIOR.
#myprog="$SCRIPTPATH/friendsofriends"
		fi
	paralelo="N"
fi
#make -C ~/madalosso-friendsofriends-57f6b5f2911d/ main CXXFLAGS=-DRange=$E CCFLAGS=-DRaio=$R
#make -C ~/madalosso-friendsofriends-57f6b5f2911d/
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

echo "**Arquivo: $arc / Raio = $R/ Nº elementos = $E / Execuções = $N / T exec interno = $interno / Metódo Original = $thread / Save = $save**" > $file
echo " " >> $file
#echo "|------------------------------------------------------------------------------------------------------------------------------------------------------------------|" >> $file
echo "| Interno | Externo |" >> $file
echo "|---------| ------- |" >> $file


a=0
var="buffer.txt"
while [ $a -ne $N ];

do
 		res1=$(date +%s.%N)
   # var=`$myprog "$arc" "$E" "$R" "$save" "$interno"`
    $myprog "$arc" | tee $var
    var1=$(tail "-1" "$var")
    res2=$(date +%s.%N)
    dt=$(echo "$res2 - $res1" | bc)
    echo "$var1" >> $file2

	echo "$dt" >> $file1
	if [ "$interno" == "S" ] || [ "$interno" == "s" ]; then
		$prog "$var1" $file "|" "t" 0
	fi
	$prog "$dt" $file "" "t" 1
	a=$(($a+1))

done
#echo "-----------------------------------------------------------------------------------" >> $file
echo "" >> $file
echo "|Menor|Maior|Média|" >> $file
echo "|------|------|------|" >> $file
if [ "$interno" == "S" ] || [ "$interno" == "s" ]; then

	$prog "0" "$file" "i" "c" 0 "$file2"

fi

$prog "0" "$file" "0" "c" 1 "$file1"

lscpu >> $file
