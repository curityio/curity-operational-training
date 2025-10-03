#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

####################################################################
# Create a Docker registry with which to deploy custom Docker images
####################################################################

#
# Get infrastructure parameters
#
. ./infrastructure.env

#
# Create a container registry
#
az acr create \
    --resource-group "$RESOURCE_GROUP" \
    --location "$REGION" \
    --name "$REGISTRY" \
    --sku Standard
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create an identity for Curity containers that can pull images from the registry
#
az identity create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$IDENTITY"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Work around this issue, where the identity is not ready for a short time
# https://github.com/Azure/azure-cli/issues/8530
#
sleep 30

#
# Grant pull permissions to the identity
#
REGISTRY_ID=$(az acr show --name "$REGISTRY" --query id --output tsv)
IDENTITY_PRINCIPAL=$(az identity show --resource-group "$RESOURCE_GROUP" --name "$IDENTITY" --query principalId --output tsv)
az role assignment create \
    --assignee "$IDENTITY_PRINCIPAL" \
    --role 'AcrPull' \
    --scope "$REGISTRY_ID"
if [ $? -ne 0 ]; then
  exit 1
fi
