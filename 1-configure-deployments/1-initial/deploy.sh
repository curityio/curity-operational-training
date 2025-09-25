#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Prevent accidental checkins of license files
#
cp ../../hooks/pre-commit ../../.git/hooks

#
# You should generate your own encryption key and strong password for the Admin UI
#
openssl rand 32 | xxd -p -c 64 > ../initial-encryption.key
export CONFIG_ENCRYPTION_KEY=$(cat ../initial-encryption.key)

#
# Use this environment variable to generate a configuration database if required
# We use an easy to remember password - you should harden Admin UI access for real deployments
#
export PASSWORD='Password1'

#
# Make sure there is no leftover configuration database in the local Docker image
#
rm -rf cdb 2>/dev/null
mkdir cdb
chmod 777 cdb

#
# Run the deployment
#
docker pull curity.azurecr.io/curity/idsvr
docker compose up
if [ $? -ne 0 ]; then
  exit 1
fi
