#!/bin/bash
## Run the playbooks using the environment variables set up in the cloudformation template.
## If you want to alter the repo specified in provision_cluster.sh and you set the different RepoURL
## and invContext parameters then this should still work bar the playbookname if you also change that.
## if you just fork it it should be fine


ERROR_LOGPATH=/var/log/wavelytics/wavelyticserror.log
PREAMBLE_PLAYBOOK=aws-openshift-node-preamble.yml
USERSETUP_PLAYBOOK=aws-openshift-usersetup.yml
OPENSHIFT_PLAYBOOK=playbook/byo/config.yml

mkdir $LOGPATH

###  SSH AGENT ####
[[ -f ~/.ssh/$KEY_NAME ]] || { 
    echo "ERROR: You require you keypair pem file.  Place pem file in ~/.ssh/"; 
    echo "Failed to load Pem keypair > $ERROR_LOGPATH"
    exit 1; 
}

eval `ssh-agent`
ssh-add ~/.ssh/$PEM_FILE

### Run in node setups
echo "Running in preamble playbooks"
cd $REPO_PATH/$INV_CONTEXT_PATH/..
ansible-playbook -i inventory $PREAMBLE_PLAYBOOK

## Provision Cluster
[[ $? -eq 0 ]] || { echo "Preamble Playbook Failed > $ERROR_LOGPATH"}
echo "############### Running in Cluster ##############"
cd $REPO_PATH/configuration/openshift-ansible
ansible-playbook -i $REPO_PATH/$INV_CONTEXT_PATH $OPENSHIFT_PLAYBOOK

[[ $? -eq 0 ]] || { echo "Cluster Provisioning Failed" > $ERROR_LOGPATH"}
echo "############### Running in Cluster ##############"
cd $REPO_PATH/$INV_CONTEXT_PATH/..
ansible-playbook -i inventory $USERSETUP_PLAYBOOK

[[ $? -eq 0 ]] || { echo "User Setup Failed" > $ERROR_LOGPATH"}

