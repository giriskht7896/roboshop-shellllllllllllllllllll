#!bin/bash
DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log


USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e " $2  $R failure $N"
    else
        echo -e " $2  $G success $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo -e "$R Error: run the command with root or sudo"
    exit 1
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "copied mongodb repo in to yum.repos.d"

yum install mongodb-org -y &>>$LOGFILE
VALIDATE $? "install mongodb"

systemctl enable mongod &>>$LOGFILE
VALIDATE $? "enable mongod"

systemctl start mongod &>>$LOGFILE
VALIDATE $? " start mongod "

sed -i 's/127.0.0.1/0.0.0.0/'  /etc/mongod.conf &>>$LOGFILE
VALIDATE $? "edited mongod.conf"

systemctl restart mongod &>>$LOGFILE
VALIDATE $? "restart mongod"

