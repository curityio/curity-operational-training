#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#########################################################################################################
# The example Azure Container Apps deployment uses configurations from other courses.
# By default it uses course 2 but can also use courses 4, 5 or 6, so that you can test cloud OAuth flows.
# This script manages minor configuration manipulations to enable working Azure solutions.
#########################################################################################################

#
# Work around sed differences for macOS
#
function replaceStringInFile() {

  local FROM=$1
  local TO=$2
  local FILE=$3

  if [ "$(uname -s)" == 'Darwin' ]; then
    sed -i '' "s/$FROM/$TO/" $FILE
  else
    sed -i "s/$FROM/$TO/" $FILE
  fi
}

#
# Set the Azure specific database hostname
#
replaceStringInFile 'dbserver:1433' "$DBSERVER.database.windows.net" './vault/secrets.env'

#
# Set the Azure specific admin and runtime base URLs
#
ADMIN_FQDN="${ADMIN_BASE_URL#'https://'}"
RUNTIME_FQDN="${RUNTIME_BASE_URL#'https://'}"
replaceStringInFile 'admin.demo.example' "$ADMIN_FQDN"   './config/parameters.env'
replaceStringInFile 'login.demo.example' "$RUNTIME_FQDN" './config/parameters.env'

#
# Finally, set variables used by the run-crypto-tools.sh script
#
export GENERATE_CLUSTER_KEY='true'
if [ "$CONFIGURATION_FOLDER" == '4-user-management'  ]; then

  export USER_MANAGEMENT='true'

elif [ "$CONFIGURATION_FOLDER" == '5-user-authentication'  ]; then

  export USER_MANAGEMENT='true'
  export USER_AUTHENTICATION='true'
  
  cp config-override/trust.xml configshared
  export USE_TRUST_STORE='false'

elif [ "$CONFIGURATION_FOLDER" == '6-token-issuance'  ]; then

  export USER_MANAGEMENT='true'
  export USER_AUTHENTICATION='true'
  export TOKEN_ISSUANCE='true'
  
  cp config-override/trust.xml configshared
  export USE_TRUST_STORE='false'
fi
