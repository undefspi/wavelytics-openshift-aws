# Wavelytics AWS Openshift Provisioning Scripts and Playbooks
A series of playbooks and scripts to provision an AWS Openshift Cluster.

Learning on openshift is really simple and recommended with minishift local to your laptop. 
Using Openshift Online is also a good choice but are not publically accessible easily in the
former instance and lack grunt in both situations 9/10.  What would be good is if you could bring up
and control your own cluster and potentially not run out of grunt - albeit at a charge from AWS.

This is provisioning scripts for CloudFormation to set up all the boxes + a submodule of the openshift-ansible repo provided by the origin project https://github.com/openshift/openshift-ansible 

All this was based off https://sysdig.com/blog/deploy-openshift-aws/ which is a great guide.  This just makes it a little more automated by ensuring the right sw versions are installed and includes the dynamic aspect of aws and ansible i.e. you dont have to manually configure any hosts

The point of the extra bits is so you can easily tear up and tear down, provision a test project with little to no effort.  By running the bootstrap.sh all should be taken care of.  You should have at the very least a marginal knowledge of AWS (relies on AWS CLI) and Ansible but if you are trying openshift then this should not be an issue.

## Provisioning
Use AWS CloudFormation to stand up the boxes.  BEWARE - You will be charged for these but its not much. Just remember to run the delete-volumes script to remove the unused volumes when you tear things down - USE WITH CAUTION.

1 x Master - medium
2 x Nodes - medium
1 x Bootstrap (to do stuff on like run the ansible scripts etc) - small

PREREQUISITE: You must have an existing Key Pair and IAM Role Setup.  The IAM Role can be a power user to 
start if you are not sure and then you can reduce it down if needed

1. From the provisioning/scripts folder run ./provision_cluster.sh [aws_keypair_name]
1. run ./provision_openshift_bootstrap.sh [aws_keypair_name] [IAM_Role_Name]

## Configuration
Contains two repos with Playbooks
1. Wavelytics provided to do all the initial node set up plus initial user setup post deployment
1. openshift-ansible provided submodule which is automatically checked out to the right branch

The passwords for the generated accounts are in the aws-openshift-usersetup.yml file BUT please change these
and ideally place them in your own ansible vault etc

### Initial Setup
1. scp the AWS KeyPair PEM file your specified in the provision_cluster.sh command to the bootstrap box into the ec2_user .ssh folder
1. Change the passwords located in aws-openshift-usersetup.yml (Recommended)

### Run the deployment script
1. Log onto your newly provisioned bootstrap server using your keypair pem file for ssh connection
1. cd /Github/
1. ./bootstrap.sh ~/.ssh/[PEM FILE]

This takes an age to setup so go make a coffee/tea/cake then come back in half an hour.  
You should now be able to log onto your cluster via http://[masternode]:8443

## Login to openshift
1.  Your openshift address will be your master nodes address at 8443. eg. https://ec-1233-abc-211-us-west-1:8443
1. Login in as admin with the provided password - access to all projects should be available
1. Login in as developer - should be shiny and new - TODO run in test project.

Congratulations you now have a fairly reasonable openshift cluster with the possibility of just adding in extra boxes to the cloudformation as you see fit.
