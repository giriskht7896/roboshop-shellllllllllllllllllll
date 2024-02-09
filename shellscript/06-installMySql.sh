#!/bin/bash

#check root user or not
#if not root user exit the program and inform user to run with sudo access
#if root user install mysql

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo "ERROR:: please run this with root access"
  
fi

yum install mysql -y

