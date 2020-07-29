#!/bin/bash

function build_service() {
#this script need to be deleted
echo on
SERVICE_NAME=$1

TAG=t$(date "+%F")-$(git rev-parse --short HEAD)
LATEST_TAG=latest
BRANCH_PREFIX=$(git branch | grep \* | cut -d ' ' -f2 | cut -d '/' -f1)

REPO=$(pwd | awk -F / '{print $(NF -1)}')
BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
COMMIT=$(git rev-parse --short HEAD)

if [[ $BRANCH_PREFIX != "master" ]]; then
  TAG=${BRANCH_PREFIX}-t$(date "+%F")-$(git rev-parse --short HEAD)
  LATEST_TAG=${BRANCH_PREFIX}-latest
fi

#https://tonal.atlassian.net/wiki/spaces/MC/pages/836370865/How+to+create+and+set+up+a+GITHB+TOKEN
docker build --no-cache --build-arg GITHUB_TOKEN --build-arg REPO=${REPO} --build-arg BRANCH=${BRANCH} --build-arg COMMIT=${COMMIT} -t 925863516128.dkr.ecr.us-west-2.amazonaws.com/${SERVICE_NAME}:$LATEST_TAG \
             -t 925863516128.dkr.ecr.us-west-2.amazonaws.com/${SERVICE_NAME}:$TAG . && \

eval $(aws ecr get-login --no-include-email --region us-west-2) && \

docker push 925863516128.dkr.ecr.us-west-2.amazonaws.com/${SERVICE_NAME}:$LATEST_TAG && \
docker push 925863516128.dkr.ecr.us-west-2.amazonaws.com/${SERVICE_NAME}:$TAG


if [[ $BRANCH_PREFIX == "prod" ]]; then
    if [[ $SERVICE_NAME == "media-service" ]]; then
        echo "kubectl set image deployment/${SERVICE_NAME} ${SERVICE_NAME}=925863516128.dkr.ecr.us-west-2.amazonaws.com/${SERVICE_NAME}:$TAG --namespace=prod --record=true"
    else
        echo "kubectl set image deployment/qa-${SERVICE_NAME} qa-${SERVICE_NAME}=925863516128.dkr.ecr.us-west-2.amazonaws.com/${SERVICE_NAME}:$TAG --namespace=qa --record=true"
        echo "kubectl set image deployment/prod-${SERVICE_NAME} prod-${SERVICE_NAME}=925863516128.dkr.ecr.us-west-2.amazonaws.com/${SERVICE_NAME}:$TAG --namespace=prod --record=true"
    fi
else
    if [[ $SERVICE_NAME == "media-service" ]]; then
        printf "\n\nWarning: do not deploy media service from master or feature branch\n"
        echo "kubectl set image deployment/${SERVICE_NAME} ${SERVICE_NAME}=925863516128.dkr.ecr.us-west-2.amazonaws.com/${SERVICE_NAME}:$TAG --namespace=prod --record=true"
    else
        echo "kubectl set image deployment/dev-${SERVICE_NAME} dev-${SERVICE_NAME}=925863516128.dkr.ecr.us-west-2.amazonaws.com/${SERVICE_NAME}:$TAG --namespace=dev --record=true"
    fi
fi

}

