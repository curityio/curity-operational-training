#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Manage license details
#
if [ ! -f ./license.json ]; then
  echo 'Please provide a license.json file in this folder before deploying'
  exit 1
fi

cp ../../hooks/pre-commit ../../.git/hooks

export LICENSE_KEY=$(cat ./license.json | jq -r .License)
if [ "$LICENSE_KEY" == '' ]; then
  echo 'An invalid license file was provided for the Curity Identity Server'
  exit 1
fi

#
# Use the config encryption key generated on the first deployment
#
export CONFIG_ENCRYPTION_KEY='e3b860830de04cc47214d3363d00ed4b1d8d9fb8c9ec7c9877046c35665ac68c'

#
# Supply parameters to control URLs
#
export RUNTIME_BASE_URL='https://login.demo.example'
export ADMIN_BASE_URL='https://admin.demo.example'

#
# Ensure that there is no leftover configuration data from a cached Docker image
#
rm -rf cdb 2>/dev/null
mkdir cdb
chmod 777 cdb

#
# Run the deployment
#
docker pull kong/kong:latest
docker compose up
if [ $? -ne 0 ]; then
  exit 1
fi