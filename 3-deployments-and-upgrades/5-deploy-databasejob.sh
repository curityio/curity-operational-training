#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

################################################################
# Create a database job container for the Curity Identity Server
################################################################

#
# Get infrastructure parameters
#
. ./infrastructure.env

#
# Get the tag of the last pushed Docker image
#
az acr login --name "$REGISTRY"
TAG=$(az acr repository show-tags --name "$REGISTRY" --repository idsvr-dbinit --orderby time_desc --top 1 --output tsv)
if [ "$TAG" == '' ]; then
  echo 'Please push a Docker image before deploying the Curity Identity Server dbinit job'
  exit 1
fi

#
# Get values envsubst needs
#
export IDSVR_DBINIT_IMAGE="$REGISTRY.azurecr.io/idsvr-dbinit:$TAG"
export ENVIRONMENT_ID=$(az containerapp env show --resource-group "$RESOURCE_GROUP" --name "$ENVIRONMENT" --query id --output tsv)
export IDENTITY_ID=$(az identity show --resource-group "$RESOURCE_GROUP" --name "$IDENTITY" --query id --output tsv)
export IDENTITY_CLIENT_ID=$(az identity show --resource-group "$RESOURCE_GROUP" --name "$IDENTITY" --query clientId --output tsv)
export IDENTITY_PRINCIPAL_ID=$(az identity show --resource-group "$RESOURCE_GROUP" --name "$IDENTITY" --query principalId --output tsv)

#
# Produce the final yaml file
#
echo 'Preparing final parameters ...'
envsubst < idsvr-dbinit/job-template.yml > idsvr-dbinit/job.yml
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Deploy the DB init job, using the custom Docker image
#
az containerapp create \
    --name idsvr-dbinit \
    --resource-group "$RESOURCE_GROUP" \
    --yaml idsvr-dbinit/job.yml
if [ $? -ne 0 ]; then
  exit 1
fi
