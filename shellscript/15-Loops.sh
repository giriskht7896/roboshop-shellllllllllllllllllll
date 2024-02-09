#!/bin/bash

for i in $@
do
     yum install $i -y
    #amazon-linux-extras install $i -y
done