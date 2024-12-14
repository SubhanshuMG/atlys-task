#!/bin/bash

# Validate required environment variables
if [ -z "${DOCKER_HUB_USER}" ]; then
    echo "ERROR: DOCKER_HUB_USER is not defined. Please set the environment variable."
    exit 1
fi

if [ -z "${DOCKER_HUB_PASSWORD}" ]; then
    echo "ERROR: DOCKER_HUB_PASSWORD is not defined. Please set the environment variable."
    exit 1
fi

if [ -z "${APP_TAG_PREFIX}" ]; then
    echo "ERROR: APP_TAG_PREFIX is not defined. Please set the environment variable."
    exit 1
fi

if [ -z "${GITHUB_REPOSITORY}" ]; then
    echo "ERROR: GITHUB_REPOSITORY is not defined. Please set the environment variable."
    exit 1
fi

if [ -z "${GITHUB_RUN_NUMBER}" ]; then
    echo "ERROR: GITHUB_RUN_NUMBER is not defined. Please set the environment variable."
    exit 1
fi

if [ -z "$1" ]; then
    echo "ERROR: Artifacts path is missing. Please pass it as an argument."
    exit 1
fi

# Define variables
ARTIFACTS_PATH="$1"
IMAGE_NAME="atlys-be"
DOCKER_HUB_REGISTRY_NAME="${DOCKER_HUB_USER}/${IMAGE_NAME}"

# Navigate to the artifacts directory
if [ -d "${ARTIFACTS_PATH}" ]; then
    echo "Navigating to artifacts directory: ${ARTIFACTS_PATH}"
    cd "${ARTIFACTS_PATH}" || exit 1
else
    echo "ERROR: Artifacts directory does not exist: ${ARTIFACTS_PATH}"
    exit 1
fi

# Set tag prefix based on branch
if [[ "${GITHUB_REF}" == "refs/heads/main" || "${GITHUB_REF}" == "refs/heads/dev" ]]; then
    APP_TAG_PREFIX="v${APP_TAG_PREFIX}"
fi

# Build Docker image
IMAGE_TAG="${DOCKER_HUB_REGISTRY_NAME}:${APP_TAG_PREFIX}.${GITHUB_RUN_NUMBER}"
LATEST_TAG="${DOCKER_HUB_REGISTRY_NAME}:latest"

echo "Building Docker image with tags: ${IMAGE_TAG} and ${LATEST_TAG}"
if docker build -f Dockerfile -t "${IMAGE_TAG}" -t "${LATEST_TAG}" .; then
    echo "Docker image built successfully."

    # Push Docker image
    echo "Pushing Docker image to DockerHub."
    if docker push "${IMAGE_TAG}" && docker push "${LATEST_TAG}"; then
        echo "Docker images pushed successfully: ${IMAGE_TAG}, ${LATEST_TAG}"
    else
        echo "ERROR: Failed to push Docker images."
        exit 1
    fi
else
    echo "ERROR: Docker image build failed."
    exit 1
fi
