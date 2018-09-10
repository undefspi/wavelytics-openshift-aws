#!/bin/bash

# The bootstrap server acts as a touchdown for a multitude of jobs. One is to use 
# Ansible to deploy from the playbooks in this repositorie.  Using the cloudformation, 
# the repo is cloned and the relevant ansible playbooks can be run.

## PARAMETERS
# AWS_KEYPAIR_NAME - The standard aws keypair you would use to provision and connect to boxes
# RepoURL - Ok so you dont want to use this repo to use - maybe fork off then ;) - Add this yourself below

[[ -z $1 ]] && { echo "No supplied aws keypair"; exit 1; }

AWS_KEYPAIR_NAME=$1

aws cloudformation create-stack \
 --region "us-west-1" \
 --stack-name openshift-bootstrap \
 --template-body file://../templates/openshift_bootstrap.json \
 --parameters \
   ParameterKey=KeyName,ParameterValue=$AWS_KEYPAIR_NAME \
 --capabilities=CAPABILITY_IAM