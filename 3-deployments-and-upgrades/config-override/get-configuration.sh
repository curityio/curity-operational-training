#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#########################################################################################################
# The example Azure Container Apps deployment uses configurations from other courses.
# By default it uses course 2 but can also use courses 4, 5 or 6, so that you can test cloud OAuth flows.
#########################################################################################################

cd ..
rm -rf ./config        2>/dev/null
rm -rf ./configshared  2>/dev/null
rm -rf ./vault         2>/dev/null
mkdir config
mkdir configshared
mkdir vault

if [ "$CONFIGURATION_FOLDER" == ''  ]; then
  CONFIGURATION_FOLDER='2-data-sources'
fi
if [ ! -d "../$CONFIGURATION_FOLDER" ]; then
  echo 'The CONFIGURATION_FOLDER is not a valid directory'
  exit 1
fi

cp ../$CONFIGURATION_FOLDER/config/parameters.env ./config/
cp ../$CONFIGURATION_FOLDER/configshared/*        ./configshared/
cp ../$CONFIGURATION_FOLDER/vault/secrets.env     ./vault/
