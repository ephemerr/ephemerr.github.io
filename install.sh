#!/bin/bash
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
