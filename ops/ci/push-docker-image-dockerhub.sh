if [ -z "${DOCKER_HUB_USER}" ]; then
    printf "ERROR: DCOKER HUB USER ID is not defined, Please set environment variable DOCKER_HUB_USER.";
    exit 1;
fi
if [ -z "${DOCKER_HUB_ORG_NAME}" ]; then
    printf "ERROR: DCOKER HUB USER ID is not defined, Please set environment variable DOCKER_HUB_ORG_NAME.";
    exit 1;
fi

if [ -z "${DOCKER_HUB_PASSWORD}" ]; then
    printf "ERROR: DOCKER HUB PASSWORD is not defined, Please set environment variable DOCKER_HUB_PASSWORD.";
    exit 1;
fi

if [ -z "${BITBUCKET_REPO_SLUG}" ]; then
    printf "ERROR: BITCBUCKET REPO SLUG is not defined, Please set environment variable BITBUCKET_REPO_SLUG.";
    exit 1;
fi

if [ -z "${APP_TAG_PREFIX}" ]; then
    printf "ERROR: Tag Prefix is not defined, Please set environment variable APP_TAG_PREFIX Application Tag Prefix."
    exit 1
fi

if [ -z "${BITBUCKET_BUILD_NUMBER}" ]; then
    printf "ERROR: Build Number is not defined, please set Environment Variable, BITBUCKET_BUILD_NUMBER "
    exit 1
fi

if [ -z "$1" ]; then
    printf "ERROR: Artifacts path is missing please pass as Argument.";
    exit 1;
fi  


printf "Setting Registry Name..."
export DOCKER_HUB_REGISTRY_NAME=${DOCKER_HUB_ORG_NAME}"/"${BITBUCKET_REPO_SLUG}

printf "Building from Dockerfile"
printf "Navigate to Internal-Artifacts Directory."
    cd $1

if [[ "${BITBUCKET_BRANCH}" =~ ^release- ]]; then
    APP_TAG_PREFIX="release-${APP_TAG_PREFIX}"
fi

if [[ "${BITBUCKET_BRANCH}" =~ ^stage ]]; then
    APP_TAG_PREFIX="stage-${APP_TAG_PREFIX}"
fi

if [[ "${BITBUCKET_BRANCH}" =~ ^dev ]]; then
    APP_TAG_PREFIX="dev-${APP_TAG_PREFIX}"
fi

if [[ "${BITBUCKET_BRANCH}" =~ ^test ]]; then
    APP_TAG_PREFIX="test-${APP_TAG_PREFIX}"
fi

if [[ "${BITBUCKET_BRANCH}" =~ ^devops- ]]; then
    APP_TAG_PREFIX="devops-setup-${APP_TAG_PREFIX}"
fi

if [[ "${BITBUCKET_BRANCH}" =~ ^hotfix- ]]; then
    APP_TAG_PREFIX="hotfix-${APP_TAG_PREFIX}"
fi

if docker build -f Dockerfile -t ${DOCKER_HUB_REGISTRY_NAME}:${APP_TAG_PREFIX}.${BITBUCKET_BUILD_NUMBER} -t ${DOCKER_HUB_REGISTRY_NAME}:latest .; then
    printf "Docker image build successfully.";
        printf "Push Docker Image.";
        if docker push ${DOCKER_HUB_REGISTRY_NAME}:${APP_TAG_PREFIX}.${BITBUCKET_BUILD_NUMBER} && docker push ${DOCKER_HUB_REGISTRY_NAME}:latest; then
            printf "Image["${DOCKER_HUB_REGISTRY_NAME}:${BITBUCKET_BUILD_NUMBER}"] successfully pushed with "latest" tag."

        else 
            printf "Docker image push failed";
        fi

    else
        printf "Docker Image Build Failed";
    fi