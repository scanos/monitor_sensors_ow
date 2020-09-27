#!/bin/bash
source ./config_weather.sh
check_zero () {
checkzero=${1:0:1} #check if first argument has zero as first character
if [ "$checkzero" == "0" ]; then
                num=${num#?} #remove first character ie 0
fi

}

check_value () {
        num=${1}
        #echo "start num XX${num}XX"
        num="$(echo "$num"|tr -d '\n')" #strip out newlines
        numlength=${#num}
        check_zero $num
        check_zero $num
	check_zero $num
  
#        echo "first num $num length $numlength"
        	echo "numlength "$numlength"  num "$num $2  

	if (( $(echo "$num > 6" |bc -l) )); then
		mailalert=$mailalert$(printf " $2 $3 $num $4\r\n")
        	sleep 2
        	temperature=0 
	fi
}

#temperature=$(./read_esp32_temp2.sh 192.168.1.135)
temperature=$(sudo curl -X GET --proto-default http "http://192.168.1.64/cm?cmnd=status%208" | jq '.StatusSNS.AM2301.Temperature')
check_value "$temperature" "upstairs" "temperature" "C"
temperature=$(./beacon_arg2.sh 12:3B:6A:1B:8D:E8)  
check_value "$temperature" "greenhouse" "temperature" "C"
temperature=$(./beacon_arg2.sh 12:3B:6A:1B:9D:91)
check_value "$temperature" "conservatory" "temperature" "C"
temperature=$(./beacon_arg2.sh 12:3B:6A:1B:B8:3D)
check_value "$temperature" "kitchen" "temperature" "C"


outside_temp=$(echo $(sudo curl "https://api.openweathermap.org/data/2.5/weather?lat=54.38&lon=-5.54&APPID=$ow_api" | jq .main.temp) - 273.15 | bc)
check_value "$outside_temp" "Outside" "temperature" "C"
#$wind_speed = $temp*2.23694;
wind=$( echo $(sudo curl "https://api.openweathermap.org/data/2.5/weather?lat=54.38&lon=-5.54&APPID=APPID=$ow_api" | jq '.wind.speed'))
wind=$(echo "scale=0; $wind * 2.23694" | bc )
#$ echo "scale=2; 100/3" | bc
wind=${wind%.*} #return substring before decimal point

check_value "$wind" "Wind" "Speed" "mph"


alertlength=${#mailalert}
if [ "$alertlength" -gt 0 ]; then
        rainalert=$(cat rainfall_total)
        echo $mailalert $rainalert| mailx  -s "Alerts" test@test.com
        echo $mailalert $rainalert| mailx  -s "Alerts" test@test.com


fi

