#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#################################################################################################################
# When you create a data source for the Curity Identity Server it is essential to use a resilient database setup.
# Therefore, involve DBAs and follow similar processes that you use for your business data.
#################################################################################################################

#
# You must disable intra-query parallelism for the Curity Identity Server's database
# - https://learn.microsoft.com/en-us/azure/azure-sql/database/configure-max-degree-of-parallelism
#
/opt/mssql-tools/bin/sqlcmd -S "$DBSERVER.database.windows.net" -U superuser -P Password1 -d idsvr -i /tmp/initscripts/initialize-database.sql
if [ $? -ne 0 ]; then
  exit 1
fi

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
