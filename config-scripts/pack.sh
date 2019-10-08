#!/usr/bin/env bash

if [ -z $VAR_FILE ]
then
    varfile='variables.json'
else
    varfile=$VAR_FILE
fi

if [ -z $1 ]
then
    echo "Validate and build new image from file.json"
    echo "pack.sh file.json"
else
    echo $1
    packer validate -var-file=${varfile} $1 && packer build -var-file=${varfile} $1
fi
