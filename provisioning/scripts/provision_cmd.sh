#!/bin/bash

aws cloudformation create-stack \
 --region "us-west-1" \
 --stack-name wavelytics-openshift \
 --template-url "https://s3-us-west-1.amazonaws.com/wavelytics/openshift_template.yml" \
 --parameters \
   ParameterKey=AvailabilityZone,ParameterValue=us-west-1b \
   ParameterKey=KeyName,ParameterValue=VPN-US-WAVELYTICS \
 --capabilities=CAPABILITY_IAM


