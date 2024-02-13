#!/bin/bash

apt update -y

apt upgrade -y 

apt auto-remove -y

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=
export AWS_DEFAULT_REGION=us-east-1

aws cloudformation delete-stack \
--stack-name tomcat \
