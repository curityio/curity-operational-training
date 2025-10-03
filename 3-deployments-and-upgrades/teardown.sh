#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

######################################
# Free and destroy all Azure resources
######################################

export RESOURCE_GROUP='curity-rg'
az group delete --name $RESOURCE_GROUP -y
