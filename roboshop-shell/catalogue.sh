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

if [ $USERID -ne 0 ]
then
    echo -e "$R Error: run the command with root or sudo"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e " $2  $R failure $N"
    else
        echo -e " $2  $G success $N"
    fi
}


curl -sL https://rpm.nodesource.com/setup_lts.x | bash 
VALIDATE $? "setting up  npm source"


yum install nodejs -y 
VALIDATE $? "installed nodejs"

useradd roboshop 

mkdir /app 


curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip 
VALIDATE $? "downloaded catalogue"

cd /app 
# VALIDATE $? "change directory" 

unzip /tmp/catalogue.zip 
VALIDATE $? "unzip catalogue"

npm cache clear --force

npm install
VALIDATE $? "install npm" 

npm fund

npm audit fix
echo pwd 
cp /home/centos/roboshop-shell/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service 


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
VALIDATE $? "loading catalogue data into mongodb"