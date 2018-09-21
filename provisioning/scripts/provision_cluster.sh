#!/bin/bash

# A Cloudformation command to provision node and master openshift cluster machines
# On tear down volumes remain so use the delete-volumes script to remove available 
# volumes that are unused

[[ -z $1 ]] && { echo "No supplied aws keypair"; exit 1; }

AWS_KEYPAIR_NAME=$1

aws cloudformation create-stack \
 --region "us-west-1" \
 --stack-name wavelytics-openshift \
 --template-body file://../templates/openshift_cluster_template.yml \
 --parameters \
   ParameterKey=AvailabilityZone,ParameterValue=us-west-1b \
   ParameterKey=KeyName,ParameterValue=$AWS_KEYPAIR_NAME \
 --capabilities=CAPABILITY_IAM 


