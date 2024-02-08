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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
VALIDATE $? "setting up  npm source"

yum install nodejs -y &>>$LOGFILE
VALIDATE $? "installed nodejs"

roboshop=$(id roboshop )
if [ $roboshop -ne 0 ]
then 
    echo -e "$R roboshop user not exist, $G creating roboshop user "
    useradd roboshop &>>$LOGFILE
else
    echo -e "$G roboshop user already existed"
fi

mkdir /app &>>$LOGFILE


curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE
VALIDATE $? "downloaded catalogue"

cd /app &>>$LOGFILE
VALIDATE $? "change directory" 

unzip /tmp/catalogue.zip &>>$LOGFILE
VALIDATE $? "unzip catalogue"

npm install &>>$LOGFILE
VALIDATE $? "install npm" 

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

systemctl daemon-reload 
VALIDATE $? "daemon-reload"

systemctl enable catalogue 
VALIDATE $? "enable catalogue"

systemctl start catalogue
VALIDATE $? "start catalogue"

cp /home/centos/roboshop-shell/mongo.repo   /etc/yum.repos.d/mongo.repo
VALIDATE $? "copied mongo.repo"

yum install mongodb-org-shell -y
VALIDATE $? "install mongodb"

mongo --host mongodb.devopsskht.xyz </app/schema/catalogue.js
