#!/bin/bash
var="$(date +%F_%H-%M)"
echo $var
DIR=/home/user/Documents/
read -p 'Enter the Path to the file that you want to backup: ' back
if [ -e $var ]; then
    echo "File $var is exist"
else
    echo "File $var isn't exist"
    echo "Create file"
    namefile=$(basename "$back")
    echo $namefile
    mkdir $namefile
    cat $back >> "$DIR"/"$namefile"/"$var"
    echo "File created"    
fi
