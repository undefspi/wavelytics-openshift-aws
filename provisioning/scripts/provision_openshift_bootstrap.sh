#!/bin/bash

[[ -z $1 ]] && { echo "No supplied aws keypair"; exit 1; }

AWS_KEYPAIR_NAME=$1

aws cloudformation create-stack \
 --region "us-west-1" \
 --stack-name openshift-bootstrap \
 --template-body file://../templates/openshift_bootstrap.json \
 --parameters \
   ParameterKey=KeyName,ParameterValue=$AWS_KEYPAIR_NAME \
 --capabilities=CAPABILITY_IAM