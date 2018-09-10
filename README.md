# Wavelytics AWS Openshift Provisioning Scripts and Playbooks
A series of playbooks and scripts to provision a AWS Openshift Cluster.

Learning on openshift is really simple with minishift local to your laptop. Using Openshift Online
is also a good choice but are not publically accessible easily in the former instance and lack grunt in both situations 9/10.  What would be good is if I could bring up and control my own cluster to my needs and not run out of grunt - Albeit at a charge from AWS.

This is provisioning scripts for CloudFormation to set up all the boxes + a submodule of the openshift-ansible repo provided by the origin project https://github.com/openshift/openshift-ansible 

All this was based off https://sysdig.com/blog/deploy-openshift-aws/ which is a great guide.  This just makes it a little more automated and stops you from installing stuff like the wrong ansible version etc.

The point of the extra bits is so you can easily tear up and tear down, provision a test project with little to no effort.  You should have at the very least a marginal knowledge of AWS (relies on AWS CLI) and Ansible but if you are trying openshift then this should not be an issue.

## Provisioning
Use AWS CloudFormation to stand up the boxes.  BEWARE - You will be charged for these but its not much. Just remember to run the delete-volumes script to remove the unused volumes.

1 x Master - medium
2 x Nodes - medium
1 x Bootstrap (to do stuff on like run the ansible scripts etc) - small

1. From the provisioning/scripts folder run ./provision_cluster.sh [aws_keypair_name]
1. run ./provision_openshift_bootstrap.sh

## Configuration
As part of the provisioning for the bootstap box, 

Pulls down this repo into /github/wavelytics-openshift-aws and checkouts the right branch (release-3.6-hotfix)
Creates a symlink to custom host file for this cluster into the submodule openshift-ansible

### Now a bit of work soon to be automated
ssh onto the box and carry out the following - This should all soon be dynamic and run off the provisioning
template

#### Prepare Nodes
1. Edit the host file in openshift-ansible-wavelytics/inventory/hosts to include your own cluster addresses (TODO make dynamic)
1. cd openshift-ansible-wavelytics
1. run ansible-playbook aws-openshift-node-preamble.yml -i inventory

#### Role out cluste
1. cd openshift-ansible
1. run ansible-playbook playbooks/byo/config.yml -i inventory/hosts
(the last step takes a while)

#### Setup Users and Roles
1. cd openshift-ansible-wavelytics
1. run ansible-playbook aws-openshift-usersetup.yml -i inventory/hosts --extra-vars "os_admin_password=[your password] os_developer_password=[your developer password]"

BEWARNED:  This is not a secure way of doing this on command line. You should use a vault for the above two vars but for ease I have listed it like this.

## Login to openshift
1.  Your openshift address will be your master nodes address at 8443. eg. https://ec-1233-abc-211-us-west-1:8443
1. Login in as admin with the provided password - access to all projects should be available
1. Login in as developer - should be shiny and new - TODO run in test project.

