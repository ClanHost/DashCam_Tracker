#!/bin/bash
# FOR SOME STUPID REASON GPS WILL NOT UPDATE EVERY SINGLE TIME, THIS FIXED IT
# https://forums.raspberrypi.com/viewtopic.php?t=331525&sid=3d088484b45e62242e02f4a2153af791&start=25
ubxtool -p RESET

while [ "$(fping google.com | grep alive)" != "google.com is alive" ]
    do
        sleep 3
done

    #DATA='{"token": "secret", "user": "secret", "message": "Car Movement"}'
    #curl -H 'Content-Type: application/json' -X POST https://api.pushover.net/1/messages.json -d "$DATA" > AAA.txt

while true
    do
        #BANDWIDTH CONSUMPTION
        BWT="$(cat /sys/class/net/eth1/statistics/tx_bytes)"
        BWR="$(cat /sys/class/net/eth1/statistics/rx_bytes)"
        SUM=$((BWT + BWR))
        BW="{\"BW\": $SUM}"

        #NEARBY WIFI ACCESS POINTS
        WIFIS="$(sudo iwlist wlan0 scan | grep "ESSID" | base64 -w 0)"
        WIFIS="{\"WIFIS\": \"$WIFIS\"}"

        #GPS LOCATION DETAILS
        GPS="$(gpspipe -w | grep -m 1 TPV | jq -c '{LAT: (.lat),LON: (.lon),SPD: (.speed),SATTIME: (.time),ALT: (.alt)}')"

        #APPEND JSON
        FINAL="$(jq --slurp 'add' <(echo "$BW") <(echo "$WIFIS") <(echo "$GPS"))"

        #SEND TO LOG FILE
        echo "$FINAL," >> /home/pi/GPS.log
        FILE=`tac /home/pi/GPS.log | sed '1,2s/,$//' | tac` #REMOVE COMMA AT THE END OF FILE

        #SEND FILE TO THE SERVER
        RESULT="$(curl --write-out '%{http_code}' --silent --output /dev/null --max-time 3 -X POST https://carpc.clanhost.com.au/API/index.php -H "Content-Type: application/json" -d "[{\"ACTION\": \"SETGPS\",\"GUID\": \"1234\", \"DATA\": [$FILE]}]")"

        #IF SUCCES THEN DELETE THE LOG FILE
        if [ $RESULT == 200 ]; then
            > /home/pi/GPS.log
        fi
done
