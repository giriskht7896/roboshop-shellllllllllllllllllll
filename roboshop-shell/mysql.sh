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

yum module disable mysql -y 

cp  /home/centos/roboshop-shell/roboshop-shell/mysql.repo   /etc/yum.repos.d/mysql.repo

yum install mysql-community-server -y

systemctl enable mysqld

systemctl start mysqld

mysql_secure_installation --set-root-pass RoboShop@1


