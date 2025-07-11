#/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Get the output location to save the script to
#
OUTPUT_FOLDER="$1"
if [ "$OUTPUT_FOLDER" == '' ]; then
  echo 'Please provide an output folder to the create-crypto-keys script'
  exit 1
fi

#
# Copy the MS SQL Server initialization script to the output location
#
docker pull curity.azurecr.io/curity/idsvr
docker run --name curity -d -e PASSWORD=Password1 curity.azurecr.io/curity/idsvr
docker cp curity:/opt/idsvr/etc/mssql-create_database.sql "$OUTPUT_FOLDER"/
docker rm --force curity 1>/dev/null
chmod 644 "$OUTPUT_FOLDER/mssql-create_database.sql"