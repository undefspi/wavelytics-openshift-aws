#!/bin/bash

if [[ -z $1 ]] && { echo "No supplied aws keypair"; exit 1 }

AWS_KEYPAIR_NAME=$1

aws cloudformation create-stack \
 --region "us-west-1" \
 --stack-name wavelytics-openshift \
 --template-body file://../templates/openshift_cluster_template.yml \
 --parameters \
   ParameterKey=AvailabilityZone,ParameterValue=us-west-1b \
   ParameterKey=KeyName,ParameterValue=$AWS_KEYPAIR_NAME \
 --capabilities=CAPABILITY_IAM


