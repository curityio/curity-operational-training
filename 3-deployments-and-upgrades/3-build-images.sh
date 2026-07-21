#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#############################
# Deploy custom Docker images
#############################

#
# Get infrastructure parameters
#
. ./infrastructure.env

#
# Get the configuration for this deployment
#
./config-override/get-configuration.sh
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Make sure we are logged into the Azure container registry
#
az acr login --name "$REGISTRY"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create a timestamp based tag
#
TAG="$(date +%Y%m%d%H%M%S)"

#
# Build a Curity Identity Server Docker image to include shared resources
#
docker build --no-cache --platform linux/amd64 -f ./idsvr/Dockerfile -t "idsvr:$TAG" .
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Build an image for the database server initialization job
#
docker build --no-cache --platform linux/amd64 -f idsvr-dbserverinit/Dockerfile -t "idsvr-dbserverinit:$TAG" --build-arg DBSERVER_ARG="$DBSERVER" .
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Push the Curity Docker image
#
IDSVR_IMAGE="$REGISTRY.azurecr.io/idsvr:$TAG"
docker tag "idsvr:$TAG" "$IDSVR_IMAGE"
docker push "$IDSVR_IMAGE"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Push the dbserver init job Docker image
#
IDSVR_DBSERVERINIT_IMAGE="$REGISTRY.azurecr.io/idsvr-dbserverinit:$TAG"
docker tag "idsvr-dbserverinit:$TAG" "$IDSVR_DBSERVERINIT_IMAGE"
docker push "$IDSVR_DBSERVERINIT_IMAGE"
if [ $? -ne 0 ]; then
  exit 1
fi
