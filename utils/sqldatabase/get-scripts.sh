#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Get the latest database scripts
#
docker pull curity.azurecr.io/curity/idsvr
docker run --name curity -d -e PASSWORD=Password1 curity.azurecr.io/curity/idsvr
docker cp curity:/opt/idsvr/etc/ ./download/
docker rm --force curity 1>/dev/null
if [ ! -f ./download/mssql-create_database.sql ]; then
  exit 1
fi
