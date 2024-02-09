#$/bin/bash
DATE=$(date +%F)
SCRIPT_NAME=$0
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log

# this function validate the previous command success or failure
VALIDATE(){

    if [ $? -ne 0 ]
    then
        echo " $2.....failure"
        exit 1
    else
        echo "$2..... success" 
    fi
    
}
USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo "run this with root user "
    exit 1
fi

yum install nginx -y &>>$LOGFILE
VALIDATE $? " installed nginx "
yum install postfix -y &>>$LOGFILE
VALIDATE $? "installed postfix"
yum install git -y &>>$LOGFILE
VALIDATE $? "installed git"