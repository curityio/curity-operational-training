#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"
. ../infrastructure.env

FQDN=$(az containerapp show \
    --name idsvr-runtime \
    --resource-group "$RESOURCE_GROUP" \
    --query properties.configuration.ingress.fqdn \
    --output tsv \
    --only-show-errors)
echo "https://$FQDN"
