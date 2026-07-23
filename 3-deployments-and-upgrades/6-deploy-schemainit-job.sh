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
# Get environment variables to deploy a container app
#
export ENVIRONMENT_ID=$(az containerapp env show --resource-group "$RESOURCE_GROUP" --name "$ENVIRONMENT" --query id --output tsv)

#
# Get environment variables for the schema creation or upgrade
#
export JDBC_URL="jdbc:sqlserver://$DBSERVER.database.windows.net;databaseName=idsvr;encrypt=false;sendStringParametersAsUnicode=false"
export JDBC_USERNAME='superuser'
export JDBC_PASSWORD='Password1'

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
