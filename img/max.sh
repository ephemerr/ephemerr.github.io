#!/bin/bash
file=$1
to_file="${file//.jpg/_max.jpg}"
convert "$file" -resize 1024x1024 -quality 75 "$to_file"

