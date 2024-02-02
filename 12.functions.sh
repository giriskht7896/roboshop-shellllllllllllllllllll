#$/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo "run this with root user "
    exit 1
fi
# this function validate the previous command success or failure
VALIDATE(){

    if [ $1 -ne 0 ]
    then
        echo "$2 failure"
        exit 1
    else
        echo "$2 success" 
    fi

}

yum install nginx -y
VALIDATE $? " installed nginx "
yum install postfix -y
VALIDATE $? "installed postfix"