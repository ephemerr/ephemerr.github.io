#!/bin/bash
file=$1
to_file="${file//.jpg/_min.jpg}"
convert "$file" -resize 320x320 -quality 75 "$to_file"
