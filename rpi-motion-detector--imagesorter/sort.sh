#!/usr/bin/env bash

set -e

INCOMING_DIR='.'
TARGET_DIR='../processed'
THUMBNAIL_WIDTH='200'
THUMBNAIL_HEIGHT='200'
LOCKFILE="$HOME/.image-sorter.lock"

function createLockFile() {
    if [[ -f $LOCKFILE ]]; then
        exit 1
    fi

    touch "$LOCKFILE" 
    return 0
}

function removeLockFile() {
    if [[ -f $LOCKFILE ]]; then
        rm "$LOCKFILE"
    fi
}

createLockFile

# replace start of string ./ with nothing 
COUNT=$(find $INCOMING_DIR -name '*.jpg' | sed 's/^\.\///' | wc -l)
if [ "$COUNT" != 0 ]; then
	for f in *.jpg; do
		HOST=${f%_*}
		NAME=${f##*_}

		DATE=${NAME%.*}
		YEAR=$(date +%Y --date=@"$DATE")
		MONTH=$(date +%m --date=@"$DATE")
		DAY=$(date +%d --date=@"$DATE")

		DIR=$TARGET_DIR/$HOST/$YEAR/$MONTH/$DAY

		if [ ! -d "$DIR" ]; then
			mkdir -p "$DIR"
		fi

		WIDTH=$(identify -format "%W" "$f")
		HEIGHT=$(identify -format "%H" "$f")
		# If the image width is greater that 200 or the height is greater that 150 a thumb is created
		if [ "$WIDTH" -ge  201 ] || [ "$HEIGHT" -ge 201 ]; then
	        	#This line convert the image in a 200 x 150 thumb
	        	filename=$(basename "$f")
		        extension="${filename##*.}"
        		filename="${filename%.*}"
		        convert -sample "$THUMBNAIL_WIDTH"x"$THUMBNAIL_HEIGHT" "$f" "$DIR/${filename}_thumb.${extension}"
     		fi

		mv "$f" "$DIR"
	done
fi

removeLockFile
