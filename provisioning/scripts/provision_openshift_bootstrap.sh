#!/bin/bash

# The bootstrap server acts as a touchdown for a multitude of jobs. One is to use 
# Ansible to deploy from the playbooks in this repositorie.  Using the cloudformation, 
# the repo is cloned and the relevant ansible playbooks can be run.

# The bootstrap natively deploys an openshift cluster which contains the following
# Openshift-Ansible Repo  + Openshift-ansible-wavelytics under the configuration folder
# If you use a different repo and use the params below this may break the userData 
# script if you do not follow the same dir approach.  It is fairly simple though

## CloudFormation Parameters
# KeyName: The standard aws keypair you would use to provision and connect to boxes
# RepoURL: Ok so you dont want to use this repo to use - maybe fork off then ;)
# InvContext: Inventory Dir to reference your static + dynamic hosts file and vars.  This uses a custom playbook
# to role out the setup of nodes before the openshift submodule provided ones. however, if you want to ditch that
# this bootstrap can still be used with a differnet playbook and invnetory.
# in the parameters section
# WorkingOSAnsibleBranch:  Change the working branch of the openshift-ansible submodule

[[ -z $1 ]] && { echo "No supplied aws keypair"; exit 1; }

AWS_KEYPAIR_NAME=$1

aws cloudformation create-stack \
 --region "us-west-1" \
 --stack-name openshift-bootstrap \
 --template-body file://../templates/openshift_bootstrap.json \
 --parameters \
   ParameterKey=KeyName,ParameterValue=$AWS_KEYPAIR_NAME \
 --capabilities=CAPABILITY_IAM