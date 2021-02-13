#!/bin/bash


if [ $# -eq 3 ] #to check if all the arguments is specfied
then
    if [ -s $1 ] && [ -s $3 ]; then #to check if the files is exist
    while read name; do #While to read the names from the names list
        while read line; do #while to read lines from the tamplate file
            echo ${line//$2/$name} #replace
        done < $1 > "message-to-$name" #redirect from tmaplate to new file
    done < $3 #redirect from nameslist
    echo "Mergining is Done!"
    else
       printf "Error: File %s or File %s is empty or does not exist.\n" $1 $3
    fi
else
    echo "Error...The program format is as follow:"
    echo "mmerge [tamplate] [Keyword] [maeslist]"
    echo "----------------------------------------"
    echo -e "tamplate: the tamplate mesage need to be use.\nKeyword: the keyword need to be replaced.\nnameslits: list of names each in spreat line."
fi

