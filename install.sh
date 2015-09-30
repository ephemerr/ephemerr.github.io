#!/bin/bash

# CSS compile
for file in less/*.less
do
  lessc $file -o ${file//less/css}
done
sed -i s/\;body/\ body/g css/index.css # format fix

#
cd cgi
lua genall.lua
cd -

# put index.html evrywere
IFS=$'\n'
DIRS=$(find * -type d)
for dir in $DIRS
do
	cp html/index.html $dir/
done
