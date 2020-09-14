#!/bin/bash

olddate="FIRST_DATE"
dailyrainfall=0
totalrainfall=0
rainfall_lines=$(wc -l rainfall)
rainfall_lines=$(IFS=" " read -ra ADDR <<< "${rainfall_lines}"; echo ${ADDR[0]})
#echo "lines $rainfall_lines"

while read line; do
#Sat  5 Sep 16:00:02 BST 2020|0.1
newdate=""
myrainfall=0
mydate=$(IFS="|" read -ra ADDR <<< "${line}"; echo ${ADDR[0]})
myrainfall=$(IFS="|" read -ra ADDR <<< "${line}"; echo ${ADDR[1]})
mydate1=$(IFS=" " read -ra ADDR <<< "${mydate}"; echo ${ADDR[0]})
mydate2=$(IFS=" " read -ra ADDR <<< "${mydate}"; echo ${ADDR[1]})
mydate3=$(IFS=" " read -ra ADDR <<< "${mydate}"; echo ${ADDR[2]})
newdate="$mydate1 $mydate2 $mydate3"
#echo $newdate $myrainfall

if [[ "$olddate" == "$newdate" ]]; then
	dailyrainfall=$(echo ${dailyrainfall} + ${myrainfall}| bc)
        totalrainfall=$(echo ${totalrainfall} + ${myrainfall}| bc)

	else
             if [[ "$olddate" != *"FIRST"* ]]; then
        	echo total rainfall $olddate $dailyrainfall
             fi	
        dailyrainfall=${myrainfall}
fi

olddate=$newdate
done <rainfall
#last line
echo total rainfall $olddate $dailyrainfall

echo "total rainfall $totalrainfall mms"

