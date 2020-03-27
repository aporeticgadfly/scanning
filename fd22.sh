#/bin/bash

#Desc: compares two port scans to find changes, both files must have same # of lines, each line with same host address, though with possibly different listed ports
#Usage: ./fd2.sh <file1> <file2>

function NotInList () {
        for port in "$@"
        do
                if [[ $port == $LOOKFOR ]]
                then
                        return 1
                fi
        done
        return 0
}

declare -i X
declare -i VAR1
declare -i VAR2
VAR1=0
VAR2=0
X=0
declare -a FIRST
declare -a SECOND
declare -a HOSTSPORTS1
declare -a HOSTSPORTS2

while [[ $VAR1 == 0 || $VAR2 == 0 ]]
do
        read aline <&4 || VAR1=1
        read bline <&5 || VAR2=1

	HOSTSPORTS1[$X]=$aline
	HOSTSPORTS2[$X]=$bline
	FIRST[$X]=${aline%% *}
	SECOND[$X]=${bline%% *}

	((X=$X + 1))

done 4< ${1:-day1.data} 5< ${2:-day2.data}

echo "1st Hosts and Ports: ${HOSTSPORTS1[@]}"
echo "2nd Hosts and Ports: ${HOSTSPORTS2[@]}"
echo "1st Hosts: ${FIRST[@]}"
echo "2nd Hosts: ${SECOND[@]}"

declare -i Y
Y=0
declare -a MATCHING

#generate list of matching hosts
for arg1 in ${FIRST[@]}
do
	for arg2 in ${SECOND[@]}
	do
		if [[ $arg1 == $arg2 ]]
		then
			MATCHING[$Y]=$arg1
			((Y=$Y+1))
		fi
	done
done

echo "Matching Hosts: ${MATCHING[@]}"

declare -i Z
Z=0
declare -a FULL

#generate full list of listed hosts; nonunique
for arg11 in ${FIRST[@]}
do
	FULL[$Z]=$arg11
	((Z=$Z+1))
done

for arg22 in ${SECOND[@]}
do
	FULL[$Z]=$arg22
	((Z=$Z+1))
done

echo "Full List of Hosts: ${FULL[@]}"

declare -i P
P=0
declare -a UNMATCHING
declare -i W
W=0
#generate list of unmatching hosts
for arg33 in ${FULL[@]}
do
	P=0
	for arg34 in ${MATCHING[@]}
	do
		if [[ $arg33 == $arg34 ]]
		then
			((P=$P+1))
		fi
	done
	if [[ $P == 0 ]]
	then
		UNMATCHING[$W]=$arg33
		((W=$W+1))
	fi
done

echo "Unmatching Hosts: ${UNMATCHING[@]}"

#unmatching belonging to first list
printf "Old Hosts: "
for arg44 in ${FIRST[@]}
do
	for arg45 in ${UNMATCHING[@]}
	do
		if [[ $arg44 == $arg55 ]]
		then
			printf "$arg55 "
		fi
	done
done

#unmatching belonging to second list
printf "New Hosts: "
for arg55 in ${SECOND[@]}
do
	for arg56 in ${UNMATCHING[@]}
	do
		if [[ $arg55 == $arg56 ]]
		then
			printf "$arg56 "
		fi
	done
done

declare -i V
V=0
declare -i U
U=0
declare -i S
S=0
declare -i T
T=0
declare -a MHOSTSPORTS1
declare -a MHOSTSPORTS2

#matching HOSTSPORTS1 and 2 generated using MATCHING
for((w=0;w<${#MATCHING[@]};w++))
do
	for((u=0;u<${#HOSTSPORTS2[@]};u++))
	do
		if [[ ${HOSTSPORTS1[$u]%% *} == ${MATCHING[$w]} ]]
		then
			MHOSTSPORTS1[$U]=${HOSTSPORTS1[$u]}
			((U=$U+1))
		fi
	done
done

for((z=0;z<${#MATCHING[@]};z++))
do
	for((y=0;y<${#HOSTSPORTS2[@]};y++))
	do
		if [[ ${HOSTSPORTS2[$y]%% *} == ${MATCHING[$z]} ]]
		then
			MHOSTSPORTS2[$S]=${HOSTSPORTS2[$y]}
			((S=$S+1))
		fi
	done
done

echo "1st Hosts and Ports from Matching: ${MHOSTSPORTS1[@]}"
echo "2nd Hosts and Ports from Matching: ${MHOSTSPORTS2[@]}"

#matching hosts with differing ports printed with old and new ports

printf "Unchanged hosts: "

#for((q=0; q<${#MATCHING[@]};q++))
#do
for((s=0;s<${#MHOSTSPORTS1[@]};s++))
do
	for((t=0;t<${#MHOSTSPORTS2[@]};t++))
	do
		if [[ ${MHOSTSPORTS1[$s]%% *} == ${MHOSTSPORTS2[$t]%% *} ]]
		then
			MATCH1=${MHOSTSPORTS1[$s]}
			MATCH2=${MHOSTSPORTS2[$t]}

			if [[ $MATCH1 == $MATCH2 ]]
       		        then
              			 echo $MATCH1
              			 continue
			fi
			printf "\n"

			printf "Port Changes: "

			HOSTA=${MATCH1%% *}
			PORTSA=( ${MATCH1#* } )

			HOSTB=${MATCH2%% *}
			PORTSB=( ${MATCH2#* } )

			echo $HOSTA

			for porta in ${PORTSA[@]}
			do
				LOOKFOR=$porta NotInList ${PORTSB[@]} && echo "  closed: $porta"
			done

			for portb in ${PORTSB[@]}
			do
				LOOKFOR=$portb NotInList ${PORTSA[@]} && echo "   new: $portb"
			done
		fi
	done
done
