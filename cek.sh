#!/bin/bash

merah='\e[91m'
cyan='\e[96m'
kuning='\e[93m'
oren='\033[0;33m' 
margenta='\e[95m'
biru='\e[94m'
ijo="\e[92m"
putih="\e[97m"
normal='\033[0m'
bold='\e[1m'
labelmerah='\e[41m'
labelijo='\e[42m'
labelkuning='\e[43m'

checkMoz(){
	moz=$(curl -skL --compressed -x "socks5://$socks" 'https://checkpagerank.net/index.php' \
			-H 'content-type: application/x-www-form-urlencoded' \
			-H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36' \
			-H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' \
			-H 'referer: https://checkpagerank.net/check-page-rank.php' \
			-H 'accept-encoding: gzip, deflate, br' \
			-H 'accept-language: id-ID,id;q=0.9,en-US;q=0.8,en;q=0.7' \
			--data 'name='$website'')
	if [[ $moz == '' ]]; then
			printf "\r${bold}${putih}[ ${biru}checkMoz ${putih}] ${cyan}$website ${putih}=> ${kuning}$socks ${merah}BAD SOCKS\033[K"
			run
	else
		DA=$(echo $moz | grep -Po '(?<=Domain Authority: )[^<]*' | head -1)
		PA=$(echo $moz | grep -Po '(?<=Page Authority: )[^<]*' | head -1)
		AlexaGlobal=$(echo $moz | grep -Po '(?<=Global Rank: )[^<]*' | head -1)
		AlexaUS=$(echo $moz | grep -Po '(?<=Alexa USA Rank: )[^<]*' | head -1)
		printf "\r${bold}${putih}[ ${biru}checkMoz ${putih}] ${cyan}$website ${putih}[ ${cyan}DA${putih}: ${ijo}$DA ${putih}| ${cyan}PA${putih}: ${ijo}$PA ${putih}| ${cyan}Alexa${putih}: ${ijo}$AlexaGlobal ${putih}| ${cyan}Alexa USA${putih}: ${ijo}$AlexaUS ${putih}] ${cyan}with ${kuning}$socks ${cyan}socks${normal}\n"
		echo "$website [ DA: $DA | PA: $PA | Alexa: $AlexaGlobal | Alexa USA: $AlexaUS ]"
	fi
}
run(){
		socks=$(cat $socksList | sort -R | head -1)
		check=$(curl -skL --compressed -x "socks5://$socks" --connect-timeout 5 --max-time 5 "https://pastebin.com/raw/k7T8yKev")
		if [[ $check =~ 'ANALGANTENG' ]]; then
			checkMoz
		else
			printf "\r${bold}${putih}[ ${biru}checkMoz ${putih}] ${cyan}$website ${putih}=> ${kuning}$socks ${merah}SOCKS5 DIE\033[K"
			run
		fi
}

clear

printf "${bold}${cyan}Your Web List${putih}: ${margenta}";read targetList;
printf "${bold}${cyan}SOCKS5 List${putih}: ${margenta}";read socksList;
printf "${bold}${cyan}Thread${putih}: ${margenta}";read sending;
printf "${bold}${cyan}Delay${putih}: ${margenta}";read tidur;
echo;echo;

# sending=5
# tidur=2
xnxx=0
IFS=$'\r\n' GLOBIGNORE='*' command eval 'target=($(cat $targetList))'
for (( i = 0; i <"${#target[@]}"; i++ )); do
	website="${target[$i]}"

	ngesend=$(expr $xnxx % $sending)
	if [[ $ngesend == 0 && $xnxx > 0 ]]; then
		sleep $tidur
	fi

		run &
		xnxx=$[$xnxx+1]
done
wait
echo;