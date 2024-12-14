#!/bin/bash
set -e

if [ -z "${MYGET_PULL_API_KEY}" ]; then
    printf "ERROR: Please set environment variable MYGET_PULL_API_KEY for MYGET Pre-authentication.";
    exit 1;
fi

if [ -z "$1" ] && [ -d "$1" ]; then
    printf "ERROR: Artifacts path is missing. Please pass a correct argument";
    exit 1;
fi

cd $1 

printf "Setting Registry Url and Adding in npmrc file"

echo "@coreplatform:registry=https://ansible.myget.org/F/coreplatform-nodejs/npm/
//ansible.myget.org/F/coreplatform-nodejs/npm/:_authToken=${MYGET_PULL_API_KEY}
always-auth=true" > .npmrc