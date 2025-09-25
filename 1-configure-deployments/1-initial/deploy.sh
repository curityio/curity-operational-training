#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Prevent accidental checkins of license files
#
cp ../../hooks/pre-commit ../../.git/hooks

#
# This fixed key was used to create the early curity-config.xml files for this course.
# It is only used for the first 4 lessons, after which we create a new key for each deployment.
#
export CONFIG_ENCRYPTION_KEY='e3b860830de04cc47214d3363d00ed4b1d8d9fb8c9ec7c9877046c35665ac68c'

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
