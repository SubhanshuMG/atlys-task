if [ -z "${DOCKER_HUB_USER}" ]; then
    printf "ERROR: DCOKER HUB USER ID is not defined, Please set environment variable DOCKER_HUB_USER.";
    exit 1;
fi
if [ -z "${DOCKER_HUB_USER}" ]; then
    printf "ERROR: DCOKER HUB USER ID is not defined, Please set environment variable DOCKER_HUB_USER.";
    exit 1;
fi

if [ -z "${DOCKER_HUB_PASSWORD}" ]; then
    printf "ERROR: DOCKER HUB PASSWORD is not defined, Please set environment variable DOCKER_HUB_PASSWORD.";
    exit 1;
fi

if [ -z "${APP_TAG_PREFIX}" ]; then
    printf "ERROR: Tag Prefix is not defined, Please set environment variable APP_TAG_PREFIX Application Tag Prefix."
    exit 1
fi

if [ -z "${GITHUB_REPOSITORY}" ]; then
    printf "ERROR: GITHUB REPOSITORY is not defined, Please set environment variable GITHUB_REPOSITORY.";
    exit 1;
fi

if [ -z "${GITHUB_RUN_NUMBER}" ]; then
    printf "ERROR: GITHUB RUN NUMBER is not defined, Please set environment variable GITHUB_RUN_NUMBER.";
    exit 1;
fi

if [ -z "$1" ]; then
    printf "ERROR: Artifacts path is missing please pass as Argument.";
    exit 1;
fi  


printf "Setting Registry Name..."
export DOCKER_HUB_REGISTRY_NAME=${DOCKER_HUB_USER}"/"${GITHUB_REPOSITORY}

printf "Building from Dockerfile"
printf "Navigate to Internal-Artifacts Directory."
    cd $1

if [[ "${GITHUB_REF}" == "refs/heads/main" ]]; then
        APP_TAG_PREFIX="v${APP_TAG_PREFIX}"
    fi

if [[ "${GITHUB_REF}" == "refs/heads/dev" ]]; then
        APP_TAG_PREFIX="v${APP_TAG_PREFIX}"
    fi

if docker build -f Dockerfile -t atlys-fe:${APP_TAG_PREFIX}.${github.run_number} -t atlys-fe:latest .; then
    printf "Docker image build successfully.";
        printf "Push Docker Image.";
        if docker push atlys-fe:${APP_TAG_PREFIX}.${github.run_number} && docker push atlys-fe:latest; then
            printf "Image["atlys-fe:${github.run_number}"] successfully pushed with "latest" tag."

        else 
            printf "Docker image push failed";
        fi

    else
        printf "Docker Image Build Failed";
    fi