#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Fix newline issues on Windows with Git bash for bash scripts downloaded from GitHub
#
if [[ "$(uname -s)" == MINGW64* ]]; then
  sed -i 's/\r$//' ./entrypoint.sh
  sed -i 's/\r$//' ./initdbserver.sh
fi

#
# Create a custom Docker image that deploys a SQL Server instance
# For local setups this automates server level setup for the Curity Identity Server
#
docker build -t curity_mssql:1.0.0 .
if [ $? -ne 0 ]; then
  exit 1
fi
