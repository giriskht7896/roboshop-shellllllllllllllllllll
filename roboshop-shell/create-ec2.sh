#!/bin/bash

NAMES=( "mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment"  "web")

IMAGE_ID=ami-0f3c7d07486cad139
SECURITY_GROUP_ID=sg-0d2c442d103270735 
INSTANCE_TYPE=""
DOMAIN_NAME=devopsskht.xyz
HOSTED_ZONE_ID=Z01278211VH22AL56K3B8

for i in "${NAMES[@]}"
do
    if  [[ $i == "mongodb" || $i == "mysql" ]];
    then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro" 
    fi

    echo "creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$i}]' | jq -r '.Instances[0].PrivateIpAddress')

    echo "created $i instance: $IP_ADDRESS"

    aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '{"Changes": [ { "Action": "CREATE","ResourceRecordSet": {"Name": "$i.$DOMAIN_NAME", "Type": "A", "TTL": 3600, "ResourceRecords": [{ "Value": "$IP_ADDRESS" }] } } ]}'

done






