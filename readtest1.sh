#!/bin/bash




#columns lengths
col1=9
col3=14
col4=4
col5=5
col6=3
col7=12

IFS=','

#specfiyng the length of each length by reading all th file and save the max length in each column
count=1
while read -r label1 label2 label3 label4 label5 label6 label7
do
    if [ $count -gt 1 ]
    then

        temp1=$((${#label1} + ${#label2} + 1))
        if [ "$temp1" -gt "$col1" ]
        then
            col1="$temp1"
            #echo "$temp1"
        fi

        if [ "${#label3}" -gt "$col3" ]
        then
            col3="${#label3}"
            #echo "$col3"
        fi

        if [ "${#label4}" -gt "$col4" ]
        then
            col4="${#label4}"
            #echo "$col4"
        fi

        if [ "${#label5}" -gt "$col5" ]
        then
            col5="${#label5}"
            #echo "$col5"
        fi

        if [ "${#label6}" -gt "$col6" ]
        then
            col6="${#label6}"
            #echo "$col6"
        fi

        if [ "${#label7}" -gt "$col7" ]
        then
            col7="${#label7}"
            #echo "$col7"
        fi

    fi
    ((count++))

done < test1comma.csv



name="Full Name"
addrs="Street Address"
city="City"
state="State"
zip="Zip"
num="Phone Number"

space1=$((${#name} - $col1 + 5))
echo "$space1"

printf "%-20s%-20s %-20s %-20s %-20s %-20s\n" $name $addrs $city $state $zip $num

count=1
for i in {$col1,$col3,$col4,$col5,$col6,$col7}; do

    str="-"
    str2="${str}"
    while (( ${#str2} < $i ))
    do
        str2="${str2}${str}"
        done
        str2="${str2}"
        printf "%s" $str2
        printf "   "
        
        if [ $count -eq 6 ]
        then
            printf "\n"
        fi
        ((count++))

done

count=1

while read -r label1 label2 label3 label4 label5 label6 label7
do
    if [ $count -gt 1 ]
    then
        printf "%s %s    %-${col3}s    %-${col4}s    %-${col5}s    %-${col6}s    %-${col7}s\n" ${label1} ${label2} ${label3} $label4 $label5 $label6 $label7
    fi
    ((count++))
done < test1comma.csv

