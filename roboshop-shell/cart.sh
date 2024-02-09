#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash 

VALIDATE $? "Setting up NPM Source"

yum install nodejs -y 

VALIDATE $? "Installing NodeJS"

#once the user is created, if you run this script 2nd time
# this command will defnitely fail
# IMPROVEMENT: first check the user already exist or not, if not exist then create
useradd roboshop 

#write a condition to check directory already exist or not
mkdir /app 

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip 

VALIDATE $? "downloading cart artifact"

cd /app 

VALIDATE $? "Moving into app directory"

unzip /tmp/cart.zip 

VALIDATE $? "unzipping cart"

npm install 

VALIDATE $? "Installing dependencies"

# give full path of cart.service because we are inside /app
cp /home/centos/roboshop-shell/roboshop-shell/cart.service /etc/systemd/system/cart.service 

VALIDATE $? "copying cart.service"

systemctl daemon-reload 

VALIDATE $? "daemon reload"

systemctl enable cart 

VALIDATE $? "Enabling cart"

systemctl start cart 

VALIDATE $? "Starting cart"