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

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip 

VALIDATE $? "downloading user artifact"

cd /app 

VALIDATE $? "Moving into app directory"

unzip /tmp/user.zip 

VALIDATE $? "unzipping user"

npm install 

VALIDATE $? "Installing dependencies"

# give full path of user.service because we are inside /app
cp /home/centos/roboshop-shell/roboshop-shell/user.service /etc/systemd/system/user.service
VALIDATE $? "copying user.service"

systemctl daemon-reload
VALIDATE $? "daemon reload"

systemctl enable user 

VALIDATE $? "Enabling user"

systemctl start user

VALIDATE $? "Starting user"

cp /home/centos/roboshop-shell/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo 

VALIDATE $? "Copying mongo repo"

yum install mongodb-org-shell -y 

VALIDATE $? "Installing mongo client"

mongo --host mongodb.devopsskht.xyz </app/schema/user.js 

VALIDATE $? "loading user data into mongodb"