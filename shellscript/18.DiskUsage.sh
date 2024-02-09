#!/bin/bash

#Colours
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

#Validations

DATE=$(date +%F)
LOGFILE_DIRECTORY=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGFILE_DIRECTORY/$SCRIPT_NAME-$DATE.log

Disk_USAGE=$(df -hT | grep -vE 'tmpfs|Filesystem')
Disk_USAGE_THRESHOLD=1
message=""

#IFS= internal field seperator
while IFS= read line
do
    usage=$(echo $line | awk '{print $6}' | cut -d % -f1)
    partition=$(echo $line | awk '{print $1}')
    if [ $usage -gt $Disk_USAGE_THRESHOLD ];
    then
        message+="HIGH DISK USAGE ON $partition: $usage \n"
    fi
done <<<$Disk_USAGE

echo -e "message: $message"

sh mail.sh gireeshmunagaru@gmail.com "high disk usage" "$message" "devops team" "high disk usage"


