#!/bin/bash
## Run the playbooks using the environment variables set up in the cloudformation template.
## If you want to alter the repo specified in provision_cluster.sh and you set the different RepoURL
## and invContext parameters then this should still work bar the playbookname if you also change that.
## if you just fork it it should be fine


ERROR_LOGPATH_DIR=/tmp/wavelytics
ERROR_FILEPATH=$ERROR_LOGPATH_DIR/wavelytics.log
PREAMBLE_PLAYBOOK=prerequisites.yml
OPENSHIFT_PLAYBOOK=deploy_cluster.yml
USERSETUP_PLAYBOOK=aws-openshift-usersetup.yml


[[ -d $ERROR_LOGPATH_DIR ]] || mkdir $ERROR_LOGPATH_DIR

PEM_FILE_PATH=$1

###  SSH AGENT ####
[[ -f $PEM_FILE_PATH ]] || {
    echo "ERROR: You require you keypair pem file.  Place pem file in ~/.ssh/";
    echo "Failed to load Pem keypair > $ERROR_LOGPATH"
    exit 1;
}

###  So ssh sessions to openshift cluster hosts can happend
eval `ssh-agent`
ssh-add $PEM_FILE_PATH

### Run in node setups
echo "Running in preamble playbooks"
cd $REPO_PATH/configuration/openshift-ansible/playbooks;
ansible-playbook -i $REPO_PATH/$INV_CONTEXT_PATH $PREAMBLE_PLAYBOOK 

## Provision Cluster
[[ $? -eq 0 ]] || { echo "Preamble Playbook Failed" > $ERROR_FILEPATH; }
echo "Do you want to run cluster playbook? This will take about half an hour (y/n):"
read RUN_CLUSTER

[[ 'y' == $RUN_CLUSTER ]] && {
	echo "############### Running in Cluster ##############";
	cd $REPO_PATH/configuration/openshift-ansible/playbooks;
	ansible-playbook -i $REPO_PATH/$INV_CONTEXT_PATH $OPENSHIFT_PLAYBOOK -vvv;
}

[[ $? -eq 0 ]] || { echo "Cluster Provisioning Failed" > $ERROR_FILEPATH; }
echo "############### Setting up initial Users  ##############"
cd $REPO_PATH/$INV_CONTEXT_PATH/../
ansible-playbook -i inventory $USERSETUP_PLAYBOOK

[[ $? -eq 0 ]] || { echo "User Setup Failed" > $ERROR_FILEPATH; }
MASTER_URL=$(aws ec2 describe-instances --filter --region us-west-1 Name=tag-value,Values=openshift-master | jq .Reservations[].Instances[].PublicDnsName)

echo "Congratulations your cluster is all setup"
echo "your openshift is at https://$MASTER_URL:8443"
