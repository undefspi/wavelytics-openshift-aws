#!/bin/bash
## Run the playbooks using the environment variables set up in the cloudformation template.
## If you want to alter the repo specified in provision_cluster.sh and you set the different RepoURL
## and invContext parameters then this should still work bar the playbookname if you also change that.
## if you just fork it it should be fine


LOGPATH=/var/log/wavelytics
PREAMBLE_PLAYBOOK=aws-openshift-node-preamble.yml
OPENSHIFT_PLAYBOOK=playbook/byo/config.yml

mkdir $LOGPATH

echo "Running in preamble playbooks"
cd $REPO_PATH/$INV_CONTEXT_PATH
ansible-playbook -i inventory $PREAMBLE_PLAYBOOK

[[ $? -eq 0 ]] || { echo "Preamble Playbook Failed > $LOGPATH/wavelyticserror.log"}
echo "############### Running in Cluster ##############"
cd $REPO_PATH/configuration/openshift-ansible
ansible-playbook -i $REPO_PATH/$INV_CONTEXT_PATH $OPENSHIFT_PLAYBOOK

#symlink the hosts file in configuration/openshift-ansible-wavelytics/inventory/hosts to openshift-ansible/inventory
#Run the playbook aws-openshift-node-preamble
#Run the playbook openshift-ansible/playbooks/byo/config.yml
#Run the playbook aws-openshift-usersetup.yml

