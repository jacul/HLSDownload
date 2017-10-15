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

if [[ $url =~ (.*)/[^/]* ]]
then
	path=${BASH_REMATCH[1]}
else
	echo "the URL arguments is error."
	exit 1
fi

curl "$url" > temp.m3u8
cat temp.m3u8 | \
while read line; do
    if [[ $line == \#EXTINF* ]]
    then
        status="reading"
        continue
    fi
    
    if [[ $status == "reading" ]]
    then
		if [[ $line == */* ]] # if the Media Segment URI is an URL
		then
	        curl -s --show-error "${line}" >> "$filename"
		else # is an URN, guess its url with safari's logic
			curl -s --show-error "${path}/${line}" >> "$filename"
		fi
        status="begin"
        echo "$count segment(s) downloaded..."
        let "count += 1"
        continue
    fi
    
    if [[ $line == "#EXT-X-ENDLIST" ]]
    then
        status="done"
        echo "Download finished"
        rm temp.m3u8
        exit 0
    fi
done

