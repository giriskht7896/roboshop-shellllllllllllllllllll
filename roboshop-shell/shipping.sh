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

yum install maven -y

useradd roboshop

mkdir /app

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

cd /app

unzip /tmp/shipping.zip

mvn clean package

mv target/shipping-1.0.jar shipping.jar

cp /home/centos/roboshop-shell/roboshop-shell/shipping.service  /etc/systemd/system/shipping.service

systemctl daemon-reload

systemctl enable shipping 

systemctl start shipping

yum install mysql -y 

mysql -h mysql.devopsskht.xyz -uroot -pRoboShop@1 < /app/schema/shipping.sql 

systemctl restart shipping

