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
if [ "$CONFIGURATION_FOLDER" == '' ]; then

  #
  # By default the configuration from this folder is used.
  #
  docker build --no-cache -f ./idsvr/Dockerfile -t "idsvr:$TAG" .
  if [ $? -ne 0 ]; then
    exit 1
  fi

else

  #
  # The demo deployment also supports building Docker images with configurations from other folders.
  #
  cd "../$CONFIGURATION_FOLDER"
  docker build --no-cache -t "idsvr:$TAG" .
  if [ $? -ne 0 ]; then
    exit 1
  fi
  cd -
fi

#
# Get the latest MS SQL Server schema creation script
#
../utils/sqldatabase/get-scripts.sh
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Copy the script into the init container's folder
#
cp ../utils/sqldatabase/download/mssql-create_database.sql "$(pwd)/idsvr-dbinit"

#
# Build an image for the database initialization job
#
docker build --no-cache -f idsvr-dbinit/Dockerfile -t "idsvr-dbinit:$TAG" --build-arg DBSERVER_ARG="$DBSERVER" .
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
# Push the database init job Docker image
#
IDSVR_DBINIT_IMAGE="$REGISTRY.azurecr.io/idsvr-dbinit:$TAG"
docker tag "idsvr-dbinit:$TAG" "$IDSVR_DBINIT_IMAGE"
docker push "$IDSVR_DBINIT_IMAGE"
if [ $? -ne 0 ]; then
  exit 1
fi
