#!/bin/bash
function files { 
    find  -name "*.jpg"  -printf "%p "
}



for file in `files`
do
    to_file="${file//.jpg/_max.jpg}"
    echo "$file" "to" "$to_file"
    convert "$file" -resize 1024x1024 -quality 75 "$to_file"
done



function out { 
    find  -name "*_*_*.jpg"  -printf "%p "
}

rm `out`
