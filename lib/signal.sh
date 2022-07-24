#!/usr/bin/env bash

source $(pwd)/lib/printer_utils.sh 


ask_to_user() {

	echo_warning "$1 ALGILANDI ÇIKMAK İSTEDİĞİNİZE EMİN MİSİNİZ ??"


	if [[ $EUID == 0 ]]; then
		S="#"
	else
		S="$"
	fi
	CMD_PROMPT="${COLORS["red"]}┌─${COLORS["yellow"]}[$(whoami)${COLORS["cyan"]}@${COLORS["yellow"]}`hostname`]${COLORS["green"]}─${COLORS["blue"]}[${COLORS["yellow"]}exit${COLORS["blue"]}]\n${COLORS["red"]}└──${COLORS["yellow"]}╼ $S"

	echo -e "$CMD_PROMPT \c"
	read SIG
	case $SIG in
		
		E|EVET|YES|Y|evet|Evet|E|e|Yes|Yes|y)
			echo_happy "Tekrar görüşürüüüz"
			if [[ -e $(pwd)/input-01.csv ]]; then
				rm -rf $(pwd)/input-01.csv
			fi
			exit
			;;
		*)
			echo ""
			;;
		esac
}
ctrl_c() {
	ask_to_user "CTRL-C"
}


trap ctrl_c INT
