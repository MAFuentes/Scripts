#!/bin/bash
path="/home/sitron/Temp/iconCopia/"
find /home/sitron/Temp/iconNew/ -name "*.png" | while read line;
do
    out=`echo $line | cut -d'/' -f6`;
    echo "$line to $path$out";
    convert  $line  -resize 716x694^  -gravity center  -extent 716x694  $path$out
    #convert  $line  -resize 1270x728^  -gravity center  -extent 1270x728  $path$out
done