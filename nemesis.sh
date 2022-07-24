#!/usr/bin/env bash


#    +================================+
#    			ADD VARİABLES                    
#    +================================+
WORK_SPACE=$(pwd)

LIB="$(pwd)/lib"

DATA_LIB=$LIB/data

IFACE_PATHS="/sys/class/net/"

LOGO_PATH="$LIB/logos"

MODE="grep -o "Mode:[A-Za-z]*"|cut -d ":" -f2"

DEFAULT_IFACE=""

GARBAGE="/dev/null 2>&1"

RESULT_CODE="$?"
NET_MANAGER=""
if [[ $EUID == 0 ]]; then
	S="#"
else
	S="$"
fi
source $LIB/printer_utils.sh
source $LIB/vend.sh
source $LIB/signal.sh
source $LIB/scanner.sh


CMD_PROMPT="${COLORS["red"]}┌─${COLORS["yellow"]}[$(whoami)${COLORS["cyan"]}@${COLORS["yellow"]}`hostname`]${COLORS["green"]}─${COLORS["blue"]}[${COLORS["yellow"]}⎋${COLORS["blue"]}]\n${COLORS["red"]}└──${COLORS["yellow"]} $S ➤ "

function import() {
	source $@
} #THİS FUNCTİON NOT WORKİNG ALSO DO NOT USE YOUR PROJECTS İ'M TRİED BUT AND THİS İS NOT WORKİNG


start_up() {
	if [[ ! $EUID == 0 ]]; then
		echo_error "Üzgünüm ama bu araç ROOT(Super User) yetkilerine ihtiyaç duymaktadır lütfen şöyle deneyin sudo $0"
		exit
	fi
	if [[ $(cat /etc/issue.net |cut -d " " -f1) == "Parrot" ]]; then
		NET_MANAGER+="NetworkManager"
	else
		NET_MANAGER+="network-manager"
	fi
	if [[ -e $DATA_LIB/.ifaces ]]; then
		rm -rf $DATA_LIB/.ifaces > $GARBAGE
	fi
	if [[ -e $(pwd)/input-01.csv ]]; then
		rm -rf input-01.csv
	fi
}

automate_lang() {
	lang=$(locale |head -n 1|grep -o "LANG=[a-z]*"|cut -d "=" -f2)
	if [[ $lang == "en" || $lang == "tr" ]]; then
		source $LIB/langs/$lang.sh
	else
		source $LIB/langs/tr.sh
	fi
	echo_succes "${LANG[1]}"
}

main_logo_typer() {
	echo -e "${COLORS["cyan"]}+${COLORS["yellow"]}============================================================================================================${COLORS["cyan"]}+"
	while IFS= read -r line
	do 
		echo -e "$line"
		sleep 0.12213123
	done < $LIB/logos/main_logo.txt
	echo -e "${COLORS["cyan"]}+${COLORS["yellow"]}============================================================================================================${COLORS["cyan"]}+"
	echo -e "\n\n\n\n\n"
}
line_by_line_typer() {
	declare -A MY_ARRAY=(
			[0]="ascii.txt"
			[1]="ascii2.txt"
			[2]="ascii3.txt"
			[3]="ascii4.txt"
			[4]="ascii5.txt"
			)
	RAND_FILE=$[$RANDOM%5]
	while IFS= read -r line_by_line
	do
		random=$[$RANDOM%5]
		echo -e "${COLOR_ARRAY[$random]} $line_by_line "
		sleep 0.1
	done < $LIB/logos/${MY_ARRAY[$RAND_FILE]}
}

word_by_word_typer() {
	for z in $(cat $LIB/logos/word.xcvf); do
		if [[ $z == "" ]]; then
			echo -ne "$z"
		else
			echo -ne "$z"
		fi
		sleep 0.11
	done
	echo -e "\n"
}

check_reqs() {
	local tool_list=( "airmon-ng" "iwconfig" "egrep" "grep" "cut" "aireplay-ng" "xterm" "lspci" "lsusb" )
	for ztool in ${tool_list[@]}; do 
		which $ztool > /dev/null 2>&1
		if [[ $RESULT_CODE == 0 ]]; then
			echo_succes "$ztool......................TAMAMDIR"
		else
			echo_succes "$ztool......................BULUNAMADI"
		fi
	sleep 0.1
	done
	echo_status "DEVAM ETMEK İÇİN [ENTER]' BASINIZ"
	read
}
select_iface() {
	local ifaces=""
	local counter=1
	for x in $(ls /sys/class/net/|egrep -o "wlan[0-9]|wlan[0-9]mon"); do
		ifaces[$counter]="$x"
		((counter++))
	done
	output
	while [[ true ]]; do
		echo -e $"$CMD_PROMPT \c"
		read islem
		if [[ -z $islem ]]; then
			echo "" > /dev/null
		else
			#echo $counter $(($counter-1)) $((counter+1))
			#if [[ $islem > $((${#ifaces[@]}-1)) ]]; then
			#	echo_warning "Hata $islem çok büyük bir değer"
			if [[ $islem -eq $(($counter-1)) ]]; then
				output
			elif [[ $islem == $counter ]]; then
				echo_happy "Tekrar görüşmek üzere BY BY"
			elif [[ $islem > $((${#ifaces[@]}-1)) ]]; then
				echo_warning "Girdiğin değer çok büyük"
			else
				DEFAULT_IFACE="${ifaces[$islem]}"
				mode_checker ${INTER_FACE[$islem]} 

			fi
		fi
		done

}
while [[ "" == "" ]]; do 
	case $1 in
		-s|--setup-path)
			if [[ ! $EUID == 0 ]]; then
				echo_error "lütfen root yetkileri ile çalıştırın\n sudo $0"
				exit
			fi 		
				cp -r ../Nemesis /usr/share
				echo "cd /usr/share/Nemesis && sudo bash nemesis.sh" > /usr/sbin/nemesis
				chmod 777 /usr/sbin/nemesis
				exit
				break
			;;
		*)
			break
			;;
		esac
	done

function main() {
start_up
automate_lang
line_by_line_typer
check_reqs
clear
main_logo_typer
word_by_word_typer
select_iface
}
main
