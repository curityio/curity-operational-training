#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#################################################
# Deploy resources for the Curity Identity Server
#################################################

#
# By default CONFIGURATION_FOLDER is the current folder.
# It is also possible to deploy configurations from other folders, to test flows in Azure.
# Set deployment variables here that the run-crypto-tools.sh script uses.
#
if [ "$CONFIGURATION_FOLDER" == '6-token-issuance' ]; then
  export USER_MANAGEMENT='true'
  export USER_AUTHENTICATION='true'
  export TOKEN_ISSUANCE='true'
elif [ "$CONFIGURATION_FOLDER" == '5-user-authentication' ]; then
  export USER_MANAGEMENT='true'
  export USER_AUTHENTICATION='true'
elif [ "$CONFIGURATION_FOLDER" == '4-user-management' ]; then
  export USER_MANAGEMENT='true'
else
  export CONFIGURATION_FOLDER='3-deployments-and-upgrades'
fi

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
../utils/crypto/create-crypto-keys.sh ../../"$CONFIGURATION_FOLDER"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Run crypto tools to create protected secrets
#
export DBSERVER_HOSTNAME="$DBSERVER.database.windows.net"
../utils/crypto/run-crypto-tools.sh ../../"$CONFIGURATION_FOLDER"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Some unpleasant bash manipulation rather than having to list each environment variable individually in yaml files
#
echo 'Preparing environment variables ...'
rm environment_variables.txt 2>/dev/null
touch environment_variables.txt
declare -a files=(../"$CONFIGURATION_FOLDER"/config/parameters.env ../"$CONFIGURATION_FOLDER"/vault/protected-secrets.env)
for file in "${files[@]}"
do
  while IFS= read -r LINE; do
    LINE_DATA="${LINE#'export '}"
    PART1=$(cut -d '=' -f 1  <<< "$LINE_DATA")
    PART2=$(cut -d '=' -f 2- <<< "$LINE_DATA")
    echo "      - name: ${PART1}"  >> environment_variables.txt
    echo "        value: ${PART2}" >> environment_variables.txt
  done < $file
done
export ENVIRONMENT_VARIABLES="$(cat environment_variables.txt)"

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
envsubst < idsvr/maildev-template.yml > idsvr/maildev.yml
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
# Then deploy the maildev utility
#
az containerapp create \
    --name smtpserver \
    --resource-group "$RESOURCE_GROUP" \
    --yaml idsvr/maildev.yml
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Output Azure generated domain names
#
export ADMIN_BASE_URL=$(./postdeployment/admin-base-url.sh)
export RUNTIME_BASE_URL=$(./postdeployment/runtime-base-url.sh)
export MAILDEV_BASE_URL=$(./postdeployment/maildev-base-url.sh)
echo "Admin base URL is $ADMIN_BASE_URL"
echo "Runtime base URL is $RUNTIME_BASE_URL"
echo "Email inbox for testing is at $MAILDEV_BASE_URL"
