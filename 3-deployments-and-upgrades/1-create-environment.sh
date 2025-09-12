#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

##################################################################################################
# Create a SaaS container environment with an internal network that can connect to Azure SQL later
##################################################################################################

#
# Create infrastructure parameters, and use randomness when values must be globally unique
#
SUFFIX="$RANDOM"
echo "export REGION='uksouth'"                         > infrastructure.env
echo "export RESOURCE_GROUP='curity-rg'"              >> infrastructure.env
echo "export NETWORK='curity-net'"                    >> infrastructure.env
echo "export SUBNET='curity-subnet'"                  >> infrastructure.env
echo "export ENVIRONMENT='curity-env'"                >> infrastructure.env
echo "export DBSERVER='curity$SUFFIX'"                >> infrastructure.env
echo "export DBNAME='idsvr'"                          >> infrastructure.env
echo "export STORAGE_ACCOUNT='curitystorage$SUFFIX'"  >> infrastructure.env
echo "export STORAGE_SHARE='curity-share'"            >> infrastructure.env
echo "export STORAGE_MOUNT='curity-mount'"            >> infrastructure.env
echo "export REGISTRY='curitytraining$SUFFIX'"        >> infrastructure.env
echo "export IDENTITY='curity-identity'"              >> infrastructure.env
. ./infrastructure.env

#
# Create the resource group
#
az group create \
    --name "$RESOURCE_GROUP" \
    --location "$REGION"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create a virtual network that runs Azure container apps
# https://learn.microsoft.com/en-us/cli/azure/azure-cli-vm-tutorial-2
#
az network vnet create \
    --resource-group "$RESOURCE_GROUP" \
    --name "$NETWORK" \
    --address-prefixes '10.0.0.0/16' \
    --subnet-name "$SUBNET" \
    --subnet-prefixes '10.0.0.0/24'
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create a predictable IP address when container apps call Azure services like Azure SQL
#
az network public-ip create \
    --resource-group "$RESOURCE_GROUP" \
    --name external-ip \
    --allocation-method Static \
    --sku Standard
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create a gateway for outbound connections from container apps, that uses the IP address
#
az network nat gateway create \
    --resource-group "$RESOURCE_GROUP" \
    --name external-gateway \
    --public-ip-addresses external-ip
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create a subnet that uses the gateway
# https://docs.azure.cn/en-us/container-apps/networking
#
az network vnet subnet update \
    --resource-group "$RESOURCE_GROUP" \
    --vnet-name "$NETWORK" \
    --name "$SUBNET" \
    --nat-gateway external-gateway \
    --delegations Microsoft.App/environments
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create an Azure container apps environment that uses the network
#
SUBNET_ID=$(az network vnet subnet show --resource-group "$RESOURCE_GROUP" --vnet-name "$NETWORK" --name "$SUBNET" --query id --output tsv)
az containerapp env create \
    --resource-group "$RESOURCE_GROUP" \
    --location "$REGION" \
    --name "$ENVIRONMENT" \
    --infrastructure-subnet-resource-id "$SUBNET_ID"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create a storage account for files shared into containers as volumes
#
echo 'Creating storage ...'
az storage account create \
    --resource-group "$RESOURCE_GROUP" \
    --location "$REGION" \
    --name "$STORAGE_ACCOUNT" \
    --sku Standard_LRS \
    --kind StorageV2
if [ $? -ne 0 ]; then
  exit 1
fi  

#
# Create a share for the storage account
#
az storage share create \
    --name "$STORAGE_SHARE" \
    --account-name "$STORAGE_ACCOUNT"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create a storage mount that containers can use
#
STORAGE_ACCOUNT_KEY=$(az storage account keys list -n "$STORAGE_ACCOUNT" --query "[0].value" -o tsv)
az containerapp env storage set \
    --resource-group "$RESOURCE_GROUP" \
    --name "$ENVIRONMENT" \
    --access-mode ReadWrite \
    --azure-file-account-name "$STORAGE_ACCOUNT" \
    --azure-file-account-key "$STORAGE_ACCOUNT_KEY" \
    --azure-file-share-name "$STORAGE_SHARE" \
    --storage-name "$STORAGE_MOUNT"
if [ $? -ne 0 ]; then
  exit 1
fi
