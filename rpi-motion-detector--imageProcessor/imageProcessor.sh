#!/usr/bin/env bash

set -e

IMAGE_DIR='/home/pi/Pictures/'
PROCESSED_DIR='/home/pi/Pictures/__processed'
COUNT=$(find $IMAGE_DIR -name '*.jpg'| wc -l)

# $1 filePath
# return timestamp
function getDeviceNameFromfilename() {
    local filePath="$1"
    echo "$filePath" | sed 's/.*\///g' | sed 's/\-.*//g'
} 

# $1 filePath
# return timestamp
function getTimestampFromFilename() {
    local filePath="$1"
    local deviceName=$(getDeviceNameFromfilename "$filePath")

    # TODO: read hostname dynamically (p)
    dateString=$(echo "$filePath" | sed 's/.*'"$deviceName"'\-//g' | sed 's/\-.*//g')
    date -d "${dateString:0:4}-${dateString:4:2}-${dateString:6:2} ${dateString:8:2}:${dateString:10:2}:${dateString:12:2}" +%s
}

if [[ $COUNT -gt 0 ]]; then
    if [[ ! -d $PROCESSED_DIR  ]]; then
        mkdir $PROCESSED_DIR
    fi

    IMAGES=$(ls $IMAGE_DIR*.jpg)
    for f in $IMAGES; do
        timestamp=$(getTimestampFromFilename "$f")
        deviceName=$(getDeviceNameFromfilename "$f")
        mv "$f" $PROCESSED_DIR/"$deviceName"_"$timestamp".jpg
        rm "$f"

        # TODO COPY TO ALEX's SERVER 
        # and remove processed file
        # optional trigger image sorter
    done

fi
