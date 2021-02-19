#!/bin/bash

## This script creates a phone list in the home directory,
## eahc line consist of two fields (Name,Number).

## -a:  add new field to the list (phone -a Name Number)
## -g: get a specfied field by name or number or both (phone -g Name/Number)
## -c: change spicfied number with another one (phone -c Number1 Number2)
## -d: dlete spicfied name or number or both (phone -d Name/Number)
## default: the phone list will be dispalyed on the screen (phone)

## Aouther: Mohammed A. Alsaggaf
## Date: 2/19/2021


Dir="$HOME/phonelist" #list directory

if [ $# -lt 1 ] #default call
then
    cat $Dir
else
    opt=$1 #option

    case $opt in

        -a)#adding name and number
            if [ $# -eq 3 ]
            then
                str="$2,$3"
                echo "$str" >> $Dir
                #echo "saved"
                #echo "$str"
            fi
            ;;
        -g)#get the name and number
            if [ $# -eq 2 ]
            then
                echo "$2"
                grep "$2" $Dir
            fi
            ;;
        -c)#change number1 with number2
            if [ $# -eq 3 ]
            then
                while read a; do
                    echo ${a//$2/$3}
                    done < $Dir > "$Dir.t"
                    mv $Dir{.t,}
            fi
            ;;
        -d)#delete
            if [ $# -eq 3 ]
            then
                str="$2,$3"
                grep -v "$str" $Dir > "$Dir.t"
                mv $Dir{.t,}

            else
                grep -v "$2" $Dir > "$Dir.t"
                mv $Dir{.t,}
            fi
            ;;
    esac
fi
