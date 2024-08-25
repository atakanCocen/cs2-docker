#!/bin/bash

REGISTRY=$1
IMAGE_NAME=$2
TAG=${3:-"latest"}

# Build, tag, and push the image to aws
docker build --no-cache . -t $IMAGE_NAME
docker tag cs2-server:latest "$1"/$IMAGE_NAME:$TAG
docker push $REGISTRY/$IMAGE_NAME:$TAG

sleep 5

# Restart the service
aws ecs update-service --cluster cs2-server-cluster --service cs2-server --force-new-deployment
