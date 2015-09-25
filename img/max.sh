#!/bin/bash
file=$1
to_file="${file//.jpg/_max.jpg}"
to_file="${to_file//.JPG/_max.jpg}"
echo "$file" "to" "$to_file"
convert "$file" -resize 1280 -quality 90  -unsharp 0x1 "$to_file"