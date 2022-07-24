#!/usr/bin/env bash

#######################
# ADD COLOR VARİABLES #
#######################
declare -A COLOR_ARRAY=(
	[0]="\e[1;31m" 
	[1]="\e[1;32m" 
	[2]="\e[1;34m" 
	[3]="\e[1;36m" 
	[4]="\e[1;33m"
	[5]="\e[1;0m"
)

declare -A COLORS

COLORS["red"]="\e[1;31m"
COLORS["green"]="\e[1;32m"
COLORS["blue"]="\e[1;34m"
COLORS["yellow"]="\e[1;33m"
COLORS["cyan"]="\e[1;36m"



#ADD PRINTER FUNCS(s)
echo_error() {
	echo -e "${COLOR_ARRAY[0]}[-] $@ ${COLOR_ARRAY[5]}" 
}											

echo_succes() {
	echo -e "${COLOR_ARRAY[1]}[+] $@ ${COLOR_ARRAY[5]}"
}

echo_status() {
	echo -e "${COLOR_ARRAY[2]}[*] $@ ${COLOR_ARRAY[5]}"
}

echo_warning() {
	echo -e "${COLOR_ARRAY[4]}[${COLORS["red"]}!${COLORS["yellow"]}] $@ ${COLOR_ARRAY[5]}"
}

echo_happy() {
	echo -e "${COLORS["cyan"]} $@ :)${COLOR_ARRAY[5]}"
}
space() {
	echo -e "\n"
}
# ADD SOME ESCAPE CHARS
INDENTATION="\t"
NEW_LINE="\n"
