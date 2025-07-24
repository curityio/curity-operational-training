#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#################################################
# Deploy resources for the Curity Identity Server
#################################################

#
# Get the license
#
if [ ! -f ./license.json ]; then
  echo 'Please provide a license.json file in this folder before deploying'
  exit 1
fi
export LICENSE_KEY=$(cat ./license.json | jq -r .License)
if [ "$LICENSE_KEY" == '' ]; then
  echo 'An invalid license file was provided for the Curity Identity Server'
  exit 1
fi

#
# Prevent accidental checkins of license files
#
cp ../hooks/pre-commit ../.git/hooks

#
# Get infrastructure parameters
#
. ./infrastructure.env

#
# Get the tag of the last pushed Docker image
#
az acr login --name "$REGISTRY"
TAG=$(az acr repository show-tags --name "$REGISTRY" --repository idsvr --orderby time_desc --top 1 --output tsv)
if [ "$TAG" == '' ]; then
  echo 'Please push a Docker image before deploying the Curity Identity Server'
  exit 1
fi

#
# Set infrastructure-related values that envsubst needs to dynamically update
#
export IDSVR_IMAGE="$REGISTRY.azurecr.io/idsvr:$TAG"
export ENVIRONMENT_ID=$(az containerapp env show --resource-group "$RESOURCE_GROUP" --name "$ENVIRONMENT" --query id --output tsv)
export IDENTITY_ID=$(az identity show --resource-group "$RESOURCE_GROUP" --name "$IDENTITY" --query id --output tsv)
export IDENTITY_CLIENT_ID=$(az identity show --resource-group "$RESOURCE_GROUP" --name "$IDENTITY" --query clientId --output tsv)
export IDENTITY_PRINCIPAL_ID=$(az identity show --resource-group "$RESOURCE_GROUP" --name "$IDENTITY" --query principalId --output tsv)

#
# You only need to create crypto keys once per stage of your deployment pipeline
#
export GENERATE_CLUSTER_KEY='true'
../utils/crypto/create-crypto-keys.sh "$(pwd)"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Run crypto tools to create protected secrets
#
../utils/crypto/run-crypto-tools.sh "$(pwd)"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Export all parameters so that envsubst can use them
#
. ./config/parameters.env
. ./vault/protected-secrets.env

#
# Use the envsubst tool to populate yaml files with the values to use in Azure
#
echo 'Preparing final parameters ...'
envsubst < idsvr/admin-template.yml > idsvr/admin.yml
if [ $? -ne 0 ]; then
  exit 1
fi
envsubst < idsvr/runtime-template.yml > idsvr/runtime.yml
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Copy the cluster configuration to the storage share
#
az storage file upload \
    --account-name "$STORAGE_ACCOUNT" \
    --share-name "$STORAGE_SHARE" \
    --source config/cluster.xml \
    --path cluster.xml
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Deploy the admin workload first
#
az containerapp create \
    --name idsvr-admin \
    --resource-group "$RESOURCE_GROUP" \
    --yaml idsvr/admin.yml
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Then deploy runtime workloads
#
az containerapp create \
    --name idsvr-runtime \
    --resource-group "$RESOURCE_GROUP" \
    --yaml idsvr/runtime.yml
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Report generated base URLs
#
ADMIN_BASE_URL=$(az containerapp show \
    --name idsvr-admin \
    --resource-group "curity-rg" \
    --query properties.configuration.ingress.fqdn --output tsv)
echo "Admin base URL is https://$ADMIN_BASE_URL/admin"

RUNTIME_BASE_URL=$(az containerapp show \
    --name idsvr-runtime \
    --resource-group "curity-rg" \
    --query properties.configuration.ingress.fqdn --output tsv)
echo "Runtime base URL is https://$RUNTIME_BASE_URL"
