#!/bin/bash

NAMES=$@
INSTANCE_TYPE=""
SECURITY_GROUP=sg-0d2c442d103270735
IMAGE_ID=ami-0f3c7d07486cad139
DOMAIN_NAME=devopsskht.xyz
HOSTED_ZONE=Z01278211VH22AL56K3B8

for i in $@
do
    if [[  $i == "mongodb" ||  $i == "mysql" ]];
    then 
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "creating $i instance"

    IP_Address=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "created $i instance: $IP_Address"

#     aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE --change-batch '{"Changes": [{
#       "Action": "CREATE",
#       "ResourceRecordSet": {
#         "Name": "$DOMAIN_NAME",
#         "Type": "A",
#         "TTL": 300,
#         "ResourceRecords": [
#           {
#             "Value": "$IP_Address"
#           }]}}]
# }
# '

done 
