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


curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

yum install rabbitmq-server -y 

systemctl enable rabbitmq-server 

systemctl start rabbitmq-server 

rabbitmqctl add_user roboshop roboshop123


rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"