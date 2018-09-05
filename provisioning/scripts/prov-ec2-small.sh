#!/bin/bash

aws cloudformation create-stack \
 --region "us-west-1" \
 --stack-name openshift-bootstrap \
 --template-body file://../templates/basic_ec2_instance_tmp.json \
 --parameters \
   ParameterKey=KeyName,ParameterValue=VPN-US-WAVELYTICS \
 --capabilities=CAPABILITY_IAM