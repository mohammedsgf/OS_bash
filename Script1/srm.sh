#!/bin/bash

## This script make the safe remove for the files, any file after specfied daysThresh will be deleted.

## Aouther: Mohammed A. Alsaggaf
## Date: 2/19/2021

daysThresh=30 #number of days before removng files
now=$(date +'%m/%d/%Y') #current date

if [ ! -d $HOME/trash ] #trash and trash record creation
then
    echo "trash file and its hidden record has been created"
    mkdir $HOME/trash
    touch $HOME/.trashrc
fi

case $1 in #check the option

    -c) #check and delet overdue files
        
        
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

    -r) #recover the files to their directories
        
        
        for i in "$@"
        do
            while IFS="," read filename fileDir fileDate
            do
 #if the input files match with the record, then do the recovery and update the record
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

    -h) #recover to the curremt directory
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

    *) #remove
        
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
