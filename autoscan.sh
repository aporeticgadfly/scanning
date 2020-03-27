#!/bin/bash
#Desc: automatically performs port scan using scan.sh, compares output to previous results, and emails user
#Usage: ./autoscan.sh

./scan.sh < hostnames

FILELIST=$(ls scan_* | tail -2)
FILES=( $FILELIST )

TMPFILE=$(tempfile)

./fd2.sh ${FILES[0]} ${FILES[1]} > $TMPFILE

if [[ -s $TMPFILE ]]
then
	echo "mailing today's port differences to santiorellana@ymail.com"
	mail -s "today's port differences" santiorellana < $TMPFILE
fi

rm -f $TMPFILE
