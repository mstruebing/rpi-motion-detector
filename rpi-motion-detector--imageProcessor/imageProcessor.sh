#!/usr/bin/env bash

set -e

IMAGE_DIR='/home/pi/Pictures/'
PROCESSED_DIR='/home/pi/Pictures/__processed'
COUNT=$(find $IMAGE_DIR -name '*.jpg'| wc -l)
LOCKFILE="$HOME/.image-processor.lock"


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
    done

    rsync -avz $PROCESSED_DIR/*.jpg alex:/var/www/html/image-api/files/incoming/
    rm $PROCESSED_DIR/*.jpg

fi

removeLockFile
