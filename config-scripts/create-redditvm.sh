#!/usr/bin/env bash

###
#
# create and run reddit-full instance
#

## MY_PROJ_ID - set it -> export MY_PROJ_ID=my-project-id
if [ -z "$MY_PROJ_ID" ]
then
    if [ -z "$1" ]
    then
        echo "Setup MY_PROJ_ID or pass through parameter."
        echo "e.g. script.sh MY_PROJ_ID"
    else
        MY_PROJ_ID=$1
    fi
fi
echo "Project ID: $MY_PROJ_ID"

# get first image from reddit-full
IMAGE_NAME=`gcloud beta compute images describe-from-family reddit-full | grep name | awk '{print $2}'`

# create ext IP
gcloud compute addresses create aaa --project=${MY_PROJ_ID} --region=us-central1
# save it in var
MY_IP=`gcloud compute addresses list | grep aaa | awk '{print $2}'`

# create instace
gcloud beta compute --project=${MY_PROJ_ID} instances create reddit-full-instance-1 --zone=us-central1 \
                    --machine-type=f1-micro \
                    --subnet=default \
                    --address=${MY_IP} \
                    --network-tier=STANDARD \
                    --maintenance-policy=MIGRATE \
                    --tags=http-server,https-server \
                    --image=${IMAGE_NAMA} \
                    --image-project=my-project-id \
                    --boot-disk-size=10GB \
                    --boot-disk-type=pd-standard \
                    --boot-disk-device-name=instance-1 \
                    --reservation-affinity=any
