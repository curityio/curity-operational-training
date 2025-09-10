#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Create a login
#
/opt/mssql-tools/bin/sqlcmd -S "$DBSERVER.database.windows.net" -U superuser -P Password1 -d master -i /tmp/initscripts/create-login.sql
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Create a user within the database for the Curity Identity Server
#
/opt/mssql-tools/bin/sqlcmd -S "$DBSERVER.database.windows.net" -U superuser -P Password1 -d idsvr -i /tmp/initscripts/create-user.sql
if [ $? -ne 0 ]; then
  exit 1
fi

#
# See if tables already exist in the Curity Identity Server database
#
TABLE_COUNT=$(/opt/mssql-tools/bin/sqlcmd -S "$DBSERVER.database.windows.net" -U superuser -P Password1 -d idsvr -h -1 -t 1 -C -Q 'SET NOCOUNT ON; SELECT COUNT(1) FROM sys.tables')
if [ $? -ne 0 ]; then
  echo "$TABLE_COUNT"
  exit 1
fi

#
# Create the schema if required and use the -I option to prevent quoted identifier errors
#
if [ $TABLE_COUNT -eq 0 ]; then

  /opt/mssql-tools/bin/sqlcmd -S "$DBSERVER.database.windows.net" -U superuser -P Password1 -d idsvr -I -i /tmp/initscripts/mssql-create_database.sql
  if [ $? -ne 0 ]; then
    exit 1
  fi
fi
