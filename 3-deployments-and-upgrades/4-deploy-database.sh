#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#######################################################################
# Create an Azure SQL server and SQL database for identity data storage
#######################################################################

#
# Get infrastructure parameters
#
. ./infrastructure.env

#
# Create an Azure instance of SQL Server
# 
az sql server create \
    --name "$DBSERVER" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$REGION" \
    --admin-user 'superuser' \
    --admin-password 'Password1'
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Allow the container apps environment to make connections to Azure SQL
#
ENVIRONMENT_PUBLIC_IP=$(az network public-ip show --resource-group "$RESOURCE_GROUP" --name external-ip --query ipAddress --output tsv)
az sql server firewall-rule create \
    --name containerapp-access \
    --resource-group "$RESOURCE_GROUP" \
    --server "$DBSERVER" \
    --start-ip-address "$ENVIRONMENT_PUBLIC_IP" \
    --end-ip-address "$ENVIRONMENT_PUBLIC_IP"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create the database fgor the Curity Identity Server
# A real database deployment should set sufficient data and log sizes
# You should also configure backup related settings
# - https://curity.io/docs/idsvr/latest/system-admin-guide/system-requirements.html#database
#
az sql db create \
    --resource-group "$RESOURCE_GROUP" \
    --server "$DBSERVER" \
    --name "$DBNAME" \
    --edition Free
if [ $? -ne 0 ]; then
  exit 1
fi
