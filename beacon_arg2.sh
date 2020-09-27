#!/bin/bash
ipmac=$(cat ipaddress.txt)
IFS=' ' read -r -a ip_data_array <<< "${ipmac}"
ipaddress=${ip_data_array[1]}
macarray=($1)
for u in "${macarray[@]}"
do
coproc sudo bluetoothctl
sleep 3
echo -e 'power on\n' >&${COPROC[1]}
sleep 3
echo -e 'discoverable on\n' >&${COPROC[1]}
sleep 3
echo -e 'agent on\n' >&${COPROC[1]}
sleep 3
echo -e 'default-agent\n' >&${COPROC[1]}
sleep 3
secs=5                         # Set interval (duration) in seconds.
endTime=$(( $(date +%s) + secs )) # Calculate end time.
while [ $(date +%s) -lt $endTime ]; do  # Loop until interval has elapsed.
    echo -e '' >&${COPROC[1]}
echo -e 'scan on\n' >&${COPROC[1]}
done
sleep 3
echo -e 'info '$u'\nexit' >&${COPROC[1]}
count_me=0
my_temp=0
output=$(cat <&${COPROC[0]})
for line in $output; do
count_me=$((count_me +1))
if [[ "$line" =~ "0x004c" ]]; then
      my_temp=$((count_me +66))
fi
if [[ "$count_me" -eq "$my_temp" ]]; then
temp_value=$((line))
temp_value=${temp_value//[-._]/}
echo $temp_value
today="$(date '+%Y-%m-%d %T')"
sleep 1
fi
done
sleep 5
done

if [ "$temp_value" -gt 25 ]; then

        if [ "$1" = "12:3B:6A:1B:9D:91" ]; then
        locationz="Conservatory"
        fi
        echo $1 $temp_value " C"| mailx  -s "High Temperature $locationz $temp_value C" $email_1
        echo $1 $temp_value " C"| mailx  -s "High Temperature $locationz $temp_value C" $email_2

fi
