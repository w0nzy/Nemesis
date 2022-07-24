source $(pwd)/lib/printer_utils.sh
#source $(pwd)/lib/scanner
vends_and_iface() {
	VENDS=""
	IFACE=""
	local counter=0
	mode='grep -o "Mode:[A-Za-z]*"|cut -d ":" -f2'
	for x in $(ip link |egrep -o "wlan[0-9]|wlan[0-9]mon"); do
	IFACE_TYPE=$(cat /sys/class/net/$x/device/modalias | cut -d ":" -f1)
	case $IFACE_TYPE in
		"usb")
			VENDOR_ID=$(cut -d ":" -f 2 /sys/class/net/$x/device/modalias | cut -b 1-10 | sed 's/^.//;s/p/:/')
			MODE=$(iwconfig $x|grep -o "Mode:[A-Za-z]"*|cut -d ":" -f2)
			CHIP=`lsusb -d $VENDOR_ID`
			OUTPUT=`echo $CHIP|sed -e "s|Network controller||g"|cut -d ":" -f 3`
			CUTTED=${OUTPUT:4}
			IFACE[$counter]="$x<${CUTTED} >$MODE"
			;;
		"pci")
			VENDOR_DEVICE=$(cat /sys/class/net/$x/device/vendor):$(cat /sys/class/net/$x/device/device)
			CLEAN_HWID=$(echo $VENDOR_DEVICE|sed -e "s|0x||g")
			CHIPSET=`lspci -d $CLEAN_HWID`
			CUTTED=$(echo $CHIPSET|sed -e "s|Network controller||g"|cut -d ":" -f 3)
		
			MODE=$(iwconfig $x|grep -o "Mode:[A-Za-z]*"|cut -d ":" -f2)
			IFACE[$counter]="$x<${CUTTED} >$MODE"
			;;
		*)
			IFACE[$counter]=" $x<UNKNOWN>$(iwconfig $x|grep -o "Mode:[A-Za-z]*|cut -d ":" -f2 ")"
			;;
		esac
		((counter++))
	done
	counter=0
	#max=${#VENDS[@]}


}

output() {
	echo_status "Lütfen bir interface(Arayüz seçiniz)"
	vends_and_iface
	INTER_FACE=""
	MAX_LENGHT=$((${#IFACE[@]}-1))
	#echo ${IFACE[1]}
	local counter=0
	for ((i=0;i<=$MAX_LENGHT;i++)); do
		INTERFACE=$(echo ${IFACE[$i]}|cut -d "<" -f1)
		INTER_FACE[$i]="$INTERFACE"
		MODE=$(echo ${IFACE[$i]}|cut -d ">" -f2)
		CHIPSET=$(echo ${IFACE[$i]}|cut -d "<" -f2|cut -d ">" -f1)
		if [[ $MODE == "Monitor" ]]; then
			echo_succes "$i.$INTERFACE // $CHIPSET // $MODE [ KULLANIMA HAZIR ]"
		else
			echo_error "$i.$INTERFACE // $CHIPSET // $MODE  [ HENÜZ KULLANIMA HAZIR DEĞİL ]"
		fi
		((counter++))
	done
	echo -e "${COLORS["cyan"]}[${COLORS["yellow"]}${COLORS["yellow"]}↶${COLORS["cyan"]}] $(($counter)) TEKRARLA"
	echo -e "${COLORS["cyan"]}[${COLORS["yellow"]}${COLORS["yellow"]}↫${COLORS["cyan"]}] $(($counter+1)) ÇIKIŞ YAP"
}

mode_checker() {
	iwconfig $1 > /dev/null 2>&1
	if [[ $? == 250 ]]; then
		echo_error "Böyle bir arayüz yok"
	else
		if [[ $(iwconfig $1|grep -o "Mode:[A-Za-z]*"|cut -d ":" -f2 ) == "Monitor" ]]; then
			echo_status "$1 ARABİRİMİ KULLANILABİLİR"
			sleep 3
			sudo xterm -hold -ls -geometry 110x56 -sb -sl 1000 -e bash $(pwd)/lib/scanner.sh $1
		else
			echo_error "Saldırı için izleme modu gereklidir"
		fi
	fi
}