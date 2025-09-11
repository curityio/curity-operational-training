#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Get the latest database scripts
#
./get-scripts.sh
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Make sure the MS SQL Server script is readable in a Docker init job
#
chmod 644 ./download/mssql-create_database.sql

#
# Fix newline issues on Windows with Git bash for bash scripts downloaded from GitHub
#
if [[ "$(uname -s)" == MINGW64* ]]; then
  sed -i 's/\r$//' ./entrypoint.sh
  sed -i 's/\r$//' ./initdb.sh
fi

#
# Create a custom Docker image that deploys a SQL Server instance
# For local setups this also automates the creation of the schema for the Curity Identity Server
#
docker build -t curity_mssql:1.0.0 .
if [ $? -ne 0 ]; then
  exit 1
fi
