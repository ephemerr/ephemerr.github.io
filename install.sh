#!/bin/bash

cd css
lessc "index.less" -o "index.css"
lessc "playbill.less" -o "playbill.css"
for file in *.less
do  
  lessc $file -o ${file//less/css}
done
cd -

cd haml 
lua gen.lua
cd -
