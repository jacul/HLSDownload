#!/bin/bash

if [ -z $1 ]
then
    echo "usage: download-hls URL [name to save]"
    exit 1
fi

filename=${2:-"save"}.ts

if [ -f "$filename" ]
then
    echo "File ${filename} already exists!"
    exit 1
fi

echo "Save file to $filename"

status="begin"
count=1
url="$1"
curl "$url" > $filename.m3u8
cat $filename.m3u8 | \
while read line; do
    if [[ $line == \#EXTINF* ]]
    then
        status="reading"
        continue
    fi

    if [[ $status == "reading" ]]
    then
        curl -s --show-error "${line}" >> "$filename"
        status="begin"
        echo "$count segment(s) downloaded..."
        let "count += 1"
        continue
    fi

    if [[ $line == "#EXT-X-ENDLIST" ]]
    then
        status="done"
        echo "Download finished"
        rm $filename.m3u8
        exit 0
    fi
done
