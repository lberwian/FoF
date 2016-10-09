#!/bin/bash


file="time.md"
file1="timein_ns.md"
prog=~/FoF/FoF/calc
count=0



#echo "Raio = $3/ Nº elementos = $2|" > $file
#echo "---------------------------------" >> $file

a=0


		count=0
while [ -f "$file" ];
do
	count=$((count+1))	
	file="time_$count.md"
	
done
	if [ "$count" -gt 1  ]; then
	count=$((count-1))	
	file="time_$count.md"
	else 
	file="time.md"	
fi	
		
	echo "$1" >> $file1
	$prog "$1" $file "in - " "t"
	


