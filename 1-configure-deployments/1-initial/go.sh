#/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Prevent accidental checkins of license files
#
cp ../../hooks/pre-commit ../../.git/hooks

#
# You should generate your own encryption key and strong password for the Admin UI
# This key was produced by running the following command:
# - openssl rand 32 | xxd -p -c 64 > encryption.key
#
export CONFIG_ENCRYPTION_KEY='e3b860830de04cc47214d3363d00ed4b1d8d9fb8c9ec7c9877046c35665ac68c'

#
# Use this environment variable to generate a configuration database if required
# We use an easy to remember password - you should harden Admin UI access for real deployments
#
export PASSWORD='Password1'

#
# Ensure that there is no leftover data from an existing Docker image
# Share the configuration database and remove it to force the installer to run
#
rm -rf cdb 
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
