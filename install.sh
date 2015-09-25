#!/bin/bash

# CSS compile
cd css
lessc "index.less" -o "index.css"
lessc "playbill.less" -o "playbill.css"
for file in *.less
do  
  lessc $file -o ${file//less/css}
done
sed -i s/\;body/\ body/g index.css # format fix
cd -

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
