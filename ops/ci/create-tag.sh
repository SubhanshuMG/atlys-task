#!/bin/bash
set -e

if [ -z $BITBUCKET_ACCESS_KEY ]; then
    printf "ERROR: Please set environment variable Bitbucket Oauth Key."
    exit 1
fi

if [ -z $BITBUCKET_ACCESS_SECRET ]; then
    printf "ERROR: Please set environment variable Bitbucket Oauth Secret."
    exit 1
fi

if [ -z $BB_TAG_USERNAME ]; then
    printf "ERROR: Please set environment variable Bitbucket Repository Author Username."
    exit 1
fi


if [ -z $BB_TAG_USER_EMAIL ]; then
    printf "ERROR: Please set environment variable Bitbucket Repository User Email."
    exit 1
fi


if [ -z $APP_TAG_PREFIX ]; then
    printf "ERROR: Tag Prefix is not defined, Please set environment variable Application Tag Prefix."
    exit 1
fi

if [ -z $TOKEN ]; then
    printf "ERROR: TOKEN not present, Please set environment variable Token"

printf "Download json parser."
fi

wget -q -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod 755 jq
TOKEN=`curl -X POST -u "${BITBUCKET_ACCESS_KEY}:${BITBUCKET_ACCESS_SECRET}"       https://bitbucket.org/site/oauth2/access_token       -d grant_type=client_credentials | ./jq .access_token -r`

printf "Change Remote Url."
git remote set-url origin https://x-token-auth:${TOKEN}@bitbucket.org/getsafle/${BITBUCKET_REPO_SLUG}.git

printf "Set Bitbucket Username & Email."
git config user.name "${BB_TAG_USERNAME}"
git config user.email "${BB_TAG_USER_EMAIL}"

printf "Create & Push Bitbucket Tag."
if [[ "${BITBUCKET_BRANCH}" =~ ^hotfix- ]]; then
  APP_TAG_PREFIX="hotfix-${APP_TAG_PREFIX}"
fi

git tag ${APP_TAG_PREFIX}.${BITBUCKET_BUILD_NUMBER}
git push origin ${APP_TAG_PREFIX}.${BITBUCKET_BUILD_NUMBER}