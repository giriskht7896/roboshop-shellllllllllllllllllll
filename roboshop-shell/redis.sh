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


yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

VALIDATE $? "repo install "

yum module enable redis:remi-6.2 -y
VALIDATE $? "enable redis "

yum install redis -y 
VALIDATE $? "install redis "

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf  /etc/redis/redis.conf
VALIDATE $? "sed command change ip "
systemctl enable redis
VALIDATE $? "enable redis "

systemctl start redis
VALIDATE $? "start redis "