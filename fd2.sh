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

while true 
do
	read aline <&4 || break
	read bline <&5 || break

	[[ $aline == $bline ]] && continue;

	HOSTA=${aline%% *}
	PORTSA=( ${aline#* } )

	HOSTB=${bline%% *}
	PORTSB=( ${bline#* } )

	echo $HOSTA

	for porta in ${PORTSA[@]}
	do
		LOOKFOR=$porta NotInList ${PORTSB[@]} && echo "  closed: $porta"
	done

	for portb in ${PORTSB[@]}
	do
		LOOKFOR=$portb NotInList ${PORTSA[@]} && echo "   new: $portb"
	done
done 4< ${1:-day1.data} 5< ${2:-day2.data}
