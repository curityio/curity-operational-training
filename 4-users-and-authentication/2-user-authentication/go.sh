#/bin/bash

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
# Build a SQL database Docker image
#
../../utils/sqldatabase/build.sh
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create a custom Docker images for the Curity Identity Server and its shared configuration
#
docker build --no-cache -t custom_idsvr:1.0.0 .
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Set variables that activate the use of additional secrets
#
export USER_MANAGEMENT='true'
export USER_AUTHENTICATION='true'

#
# If required, create HTTPS certificates that the API gateway uses for external URLs
#
../../utils/ssl-certs/create.sh "$(pwd)"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create crypto keys once per stage of your deployment pipeline
#
../../utils/crypto/create-crypto-keys.sh "$(pwd)"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Run crypto tools to create protected secrets
#
../../utils/crypto/run-crypto-tools.sh "$(pwd)"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Store SQL Server data on a local volume as opposed to the external volumes that real deployments use
# To redeploy and keep existing data, delete the 'rm -rf' line from the below commands
#
rm -rf data
mkdir data
chmod 777 data

#
# Run the Curity Identity Server with durable storage in a local SQL Server
#
docker compose up
if [ $? -ne 0 ]; then
  exit 1
fi
