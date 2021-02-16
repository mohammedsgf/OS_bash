#!/bin/bash

daysThresh=30
now=$(date +'%m/%d/%Y')
if [ ! -d $HOME/trash ]
then
    echo "trash file and its hidden record has been created"
    mkdir $HOME/trash
    touch $HOME/.trashrc
fi

case $1 in

    -c)
        echo "checking"
        
        while IFS="," read filename fileDir fileDate
        do
            IFS='/' read filemonth fileday fileyear <<< "$fileDate"
            IFS='/' read mon day year <<< "$now"
        diffDays=$(( ($(date --date="$year-$mon-$day" +%s) - $(date --date="$fileyear-$filemonth-$fileday" +%s) )/(60*60*24) ))
        
        if [ $diffDays -gt $daysThresh ] #remove the file from the trash
        then
            rm $HOME/trash/$filename
        fi
        done < $HOME/.trashrc

        #update the record
        while IFS="," read filename fileDir fileDate
        do
        
          [[ -e $HOME/trash/$filename ]] && echo "$filename,$fileDir,$fileDate"
      done < $HOME/.trashrc > $HOME/.trashrc.t
      mv $HOME/.trashrc.t $HOME/.trashrc
        ;;

    -r)
        echo "recovery"
        
        for i in "$@"
        do
            while IFS="," read filename fileDir fileDate
            do
                if [ $i == $filename ]
                then
                    mv $HOME/trash/$i $fileDir
                 else
                    echo "$filename,$fileDir,$fileDate"
                fi
            done < $HOME/.trashrc > $HOME/.trashrc.t
            mv $HOME/.trashrc.t $HOME/.trashrc
        done
        ;;

    -h)
        echo "recovery2"
        currentDir=$(pwd)

        for i in "$@"
        do
            while IFS="," read filename fileDir fileDate
            do
                if [ $i == $filename ]
                then
                    mv $HOME/trash/$i $currentDir
                 else
                    echo "$filename,$fileDir,$fileDate"
                fi
            done < $HOME/.trashrc > $HOME/.trashrc.t
            mv $HOME/.trashrc.t $HOME/.trashrc
        done

        ;;

    *)
        echo "remove"
        fileDir=$(pwd)

        for n in "$@"
        do
            filename=$n

            if [ ! -e $fileDir/$filename ] #if the filename is from another directory
            then 
                fileDir=${filename%/*} #remove the file name from dir
                filename=${filename##*/} #remove the dir from the file name
            fi
           
            if [ -e $fileDir/$filename ] 
            then
                 mv $fileDir/$filename $HOME/trash

                printf "%s,%s,%s\n" $filename $fileDir $now >> $HOME/.trashrc
            else
                echo "No such file directory:$filename"
            fi
        done

        ;;
esac
