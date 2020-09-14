#!/bin/bash

check_value () {
        #num=${1#*.}
        # bash struggles integers so remove temporarily modulus
        num=${1%.*}
        num=${num// 0/}
        numlength=${#num}
         
#pi@pi92c5:~ $ num="0 0 20"
#pi@pi92c5:~ $ echo ${num:(-2)}
#20
        if [ "$numlength" == "6" ]; then
        	num=${num:(-2)}
        fi
        if [ "$numlength" == "5" ]; then
                num=${num:(-1)}
        fi
       	if [ "$numlength" == "4" ]; then
       		num=${num:(-2)}
       	fi
        if [ "$numlength" == "3" ]; then
                num=${num:(-1)}
        fi



        echo "numlength "$numlength"  num "$num $2  

	if [ "$num" -gt "14" ]; then
		mailalert=$mailalert$(printf " $2 $3 $num $4\r\n")
        	sleep 2
        	temperature=0 
	fi
}

rain=$(sudo curl "https://api.openweathermap.org/data/2.5/weather?lat=54.38&lon=-5.54&APPID=be24cd1ab5d2f7fc33c7d2e43ca58cfb" | jq '.rain')
#rain="{ \"1h\": 5.02 }"
echo $rain
rain=$(echo "${rain#*:}")
rain=${rain//\}/}
rain=${rain// /}
rain=${rain//\/n/}

echo $rain
#|rainlength=${#rain}

if [ "${rain}" == "null" ]; then
    echo "VAR is unset or set to the empty string"
else
echo "$(date)|$rain" >> rainfall
fi



#alertlength=${#mailalert}
#if [ "$alertlength" -gt 0 ]; then
#	echo $mailalert| mailx  -s "Alerts" seamuskane@aim.com
#        echo $mailalert| mailx  -s "Alerts" branchaude@gmail.com

#fi
