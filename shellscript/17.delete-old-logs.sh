# only .log files should be deleted, donot delete any other files
# go to the folder
# get all the log files with extension of .log 
# check the date
# if date is more than 2 weeks old date

#!/bin/bash
APP_LOGS_DIR=/home/centos/app-logs
DATE=$(date +%F)
LOGSDIR=/home/centos/shellscript-logs
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log

FILES_TO_DELETE=$(find $APP_LOGS_DIR -name "*.log" -type f -mtime +14 )

echo "$FILES_TO_DELETE"

while read line
do
    echo "Deleting $line" &>> $LOGFILE
    rm -rf $line
done <<< $FILES_TO_DELETE



