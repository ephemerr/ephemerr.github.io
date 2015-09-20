#!/bin/bash
function files { 
    find  -name "*.jpg"  -printf "%p "
}

function max {
    for file in `files`
    do
        to_file="${file//.jpg/_max.jpg}"
        echo "$file" "to" "$to_file"
        convert "$file" -resize 1024x1024 -quality 75 "$to_file"
    done
}

function min {
    for file in `files`
    do
        to_file="${file//.jpg/_min.jpg}"
        echo "$file" "to" "$to_file"
        convert "$file" -resize 320x320 -quality 75 "$to_file"
    done
}

function out { 
    find  -name "*_m*_m*.jpg"  -printf "%p "
}

min
rm `out`
