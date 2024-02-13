#!/bin/bash

apt update -y

apt upgrade -y 

apt auto-remove -y

apt install awscli -y

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
export AWS_DEFAULT_REGION=us-east-1

aws cloudformation deploy \
--template-file ubuntu.yml \
--stack-name "tomcat" \
--capabilities CAPABILITY_NAMED_IAM
if [ $? -eq 0 ]; then
aws cloudformation list-exports \
--profile default \
--query "Exports[?Name=='DNSPublica'].Value"
fi
