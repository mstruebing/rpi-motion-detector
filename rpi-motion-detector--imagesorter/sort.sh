#!/usr/bin/env bash

COUNT=`ls -1 *.jpg 2>/dev/null | wc -l`
if [ $COUNT != 0 ]; then
	for f in *.jpg; do
		HOST=${f%_*}
		NAME=${f##*_}

		DATE=${NAME%.*}
		YEAR=$(date +%Y --date=@"$DATE")
		MONTH=$(date +%m --date=@"$DATE")
		DAY=$(date +%d --date=@"$DATE")

		DIR=../$HOST/$YEAR/$MONTH/$DAY

		if [ ! -d "$DIR" ]; then
			mkdir -p "$DIR"
		fi
		mv "$f" "$DIR"
	done
else
	echo "lol"
fi
