#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#########################################################################
# For Container Apps, patch the configuration system with generated URLs 
# Use of RESTCONF will be explained in the API Automation training course
#########################################################################

echo "Getting the Curity Identity Server's external URLs ..."
export ADMIN_BASE_URL=$(./admin-base-url.sh)
export RUNTIME_BASE_URL=$(./runtime-base-url.sh)

envsubst < patch-template.xml > patch.xml
if [ $? -ne 0 ]; then
  echo 'Problem encountered using envsubst to create the patch.xml file'
  exit 1
fi

RESTCONF_BASE_URL="$ADMIN_BASE_URL/admin/api/restconf/data"
ADMIN_USER='admin'
ADMIN_PASSWORD='Password1'

echo "Applying a patch to configure the Curity Identity Server's external URLs ..."
HTTP_STATUS=$(curl -s \
  -X PATCH "$RESTCONF_BASE_URL" \
  -u "$ADMIN_USER:$ADMIN_PASSWORD" \
  -H 'Content-Type: application/yang-data+xml' \
  -d @patch.xml \
  -o response.txt -w '%{http_code}')
if [ "$HTTP_STATUS" != '204' ]; then
  echo "Problem encountered patching the Curity Identity Server's configuration: $HTTP_STATUS"
  cat response.txt
  exit 1
fi
