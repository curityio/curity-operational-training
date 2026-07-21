#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#############################################################################################################
# Create a schema init job container for the Curity Identity Server, to create or upgrade the database schema
#############################################################################################################

#
# Get infrastructure parameters
#
. ./infrastructure.env

#
# Get values envsubst needs
#
export ENVIRONMENT_ID=$(az containerapp env show --resource-group "$RESOURCE_GROUP" --name "$ENVIRONMENT" --query id --output tsv)

#
# Produce the final yaml file
#
envsubst < idsvr-schemainit/job-template.yml > idsvr-schemainit/job.yml
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Deploy the schema init job
#
az containerapp create \
    --name idsvr-schemainit \
    --resource-group "$RESOURCE_GROUP" \
    --yaml idsvr-schemainit/job.yml
if [ $? -ne 0 ]; then
  exit 1
fi
