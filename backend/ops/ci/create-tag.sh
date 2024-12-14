#!/bin/bash
set -e

# Check if the required environment variables are set
if [ -z "$GITHUB_ACCESS_TOKEN" ]; then
    printf "ERROR: Please set environment variable GitHub Access Token.\n"
    exit 1
fi

if [ -z "$GH_TAG_USER_EMAIL" ]; then
    printf "ERROR: Please set environment variable GitHub Repository User Email.\n"
    exit 1
fi

if [ -z "$APP_TAG_PREFIX" ]; then
    printf "ERROR: Tag Prefix is not defined, Please set environment variable Application Tag Prefix.\n"
    exit 1
fi

# Extract repository owner and name from the GITHUB_REPOSITORY variable
GITHUB_REPO_OWNER=$(echo "${GITHUB_REPOSITORY}" | cut -d'/' -f1)
GITHUB_REPO_SLUG=$(echo "${GITHUB_REPOSITORY}" | cut -d'/' -f2)

# Set GitHub actor as the default username if GH_TAG_USERNAME is not set
GH_TAG_USERNAME=${GH_TAG_USERNAME:-$GITHUB_ACTOR}
printf "GITHUB_ACTOR and GITHUB_REPO_SLUG === ${GITHUB_ACTOR}.${GITHUB_REPO_SLUG}"

printf "Download json parser.\n"

wget -q -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod 755 jq

printf "Change Remote Url.\n"
git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_ACCESS_TOKEN}@github.com/${GITHUB_REPO_OWNER}/${GITHUB_REPO_SLUG}.git

printf "Set GitHub Username & Email.\n"
git config user.name "${GH_TAG_USERNAME}"
git config user.email "${GH_TAG_USER_EMAIL}"

printf "GitHub Username & Email === ${GH_TAG_USERNAME}.${GH_TAG_USER_EMAIL}"

printf "Create & Push GitHub Tag.\n"
# Extract branch name from GITHUB_REF
GITHUB_BRANCH=$(echo "${GITHUB_REF}" | sed 's/refs\/heads\///')
printf "GITHUB_BRANCH === ${GITHUB_BRANCH}.${GH_TAG_USER_EMAIL}"

if [[ "${GITHUB_BRANCH}" == "dev" ]]; then
  APP_TAG_PREFIX="v${APP_TAG_PREFIX}"
fi

if [[ "${GITHUB_BRANCH}" == "main" ]]; then
  APP_TAG_PREFIX="v${APP_TAG_PREFIX}"
fi

if [ "$1" ]; then
    APP_TAG_PREFIX="$1${APP_TAG_PREFIX}"
fi

printf "tag === ${APP_TAG_PREFIX}.${GITHUB_RUN_NUMBER}"

git tag ${APP_TAG_PREFIX}.${GITHUB_RUN_NUMBER}
git push origin ${APP_TAG_PREFIX}.${GITHUB_RUN_NUMBER}
