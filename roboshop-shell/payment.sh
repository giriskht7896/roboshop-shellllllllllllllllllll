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

yum install python36 gcc python3-devel -y

useradd roboshop

mkdir /app 

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip

cd /app 

unzip /tmp/payment.zip


pip3.6 install -r requirements.txt

cp /home/centos/roboshop-shell/roboshop-shell/payment.service  /etc/systemd/system/payment.service

systemctl daemon-reload

systemctl enable payment 

systemctl start payment





