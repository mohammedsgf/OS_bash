#!/bin/bash


Dir="/home/$USERNAME/phonelist"

if [ $# -lt 1 ]
then
    cat $Dir
else
    opt=$1

    case $opt in

        -a)#adding name and number
            if [ $# -eq 3 ]
            then
                str="$2,$3"
                echo "$str" >> $Dir
                echo "saved"
                echo "$str"
            fi
            ;;
        -g)#get the name and number
            if [ $# -eq 2 ]
            then
                cat $Dir | grep $2
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
