#!/bin/bash

IFS=$'\n'

function files { 
    #! -name "*_m*jpg"
    find  -iname "*.jpg"  -printf "%p\n"
}

function max {
    for file in `files`
    do	
        to_file=${file//.jpg/_max.jpg}
	to_file=${to_file//.JPG/_max.jpg}
        echo "$file" "to" "$to_file"
        convert "$file" -resize 1280 -quality 90  -unsharp 0x1 "$to_file"
    done
}

function min {
    for file in `files`
    do
        to_file="${file//_max.jpg/_min.jpg}"
        to_file="${file//.JPG/_min.jpg}"
        echo "$file" "to" "$to_file"
        convert "$file" -resize 320x320 -quality 75 "$to_file"
    done
}

function outfiles {
    find  -name "*_max.jpg" 
}

function clean {
	rm `outfiles`
}

$1