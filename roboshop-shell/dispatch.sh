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


yum install golang -y

useradd roboshop

mkdir /app 

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip

cd /app

unzip /tmp/dispatch.zip

cd /app 
go mod init dispatch
go get 
go build

cp home/centos/roboshop-shell/roboshop-shell/dispatch.service   /etc/systemd/system/dispatch.service

systemctl daemon-reload

systemctl enable dispatch 

systemctl start dispatch

