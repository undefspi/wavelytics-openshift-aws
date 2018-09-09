#!/bin/bash

##### Utility to delete all volumes based on the status flag. Good for clearing out volumes that 
##### have been created as a result of create-stack but that stack then gets deleted


STATUS=$1
FLAG=$1

VOL_ID_ARRAY=($(aws ec2 describe-volumes --filter "Name=status,Values=$STATUS" | jq .Volumes[].VolumeId))
echo "${VOL_ID_ARRAY[@]}"

for vol in "${VOL_ID_ARRAY[@]}" 
do 
    VOL_ID=$(echo "$vol" | tr -d '"')
    echo "Do you wish to delete vol $VOL_ID (y/n)"
    read status;
    [ "$status" == "y" ] && { echo "Deleting $VOL_ID; aws ec2 delete-volume --volume-id $VOL_ID }"
done