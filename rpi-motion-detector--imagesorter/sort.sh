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

		IMAGE_SIZE=`file -b $f | sed 's/ //g' | sed 's/,/ /g' | awk  '{print $2}'`
		WIDTH=`identify -format "%W" "$f"`
		HEIGHT=`identify -format "%H" "$f"`
		echo size: $WIDTH $HEIGHT
		# If the image width is greater that 200 or the height is greater that 150 a thumb is created
		if [ $WIDTH -ge  201 ] || [ $HEIGHT -ge 201 ]; then
	        	#This line convert the image in a 200 x 150 thumb
	        	filename=$(basename "$f")
		        extension="${filename##*.}"
        		filename="${filename%.*}"
		        convert -sample 200x200 "$f" "$DIR/${filename}_thumb.${extension}"
     		fi

		if [ ! -d "$DIR" ]; then
			mkdir -p "$DIR"
		fi
		mv "$f" "$DIR"
	done
else
	echo "lol"
fi
