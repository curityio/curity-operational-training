#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#############################################################################################################
# When you create a data source for the Curity Identity Server it is essential to use a resilient data setup.
# Therefore, involve DBAs and follow similar processes that you use for your business data.
#############################################################################################################

#
# Use sqlcmd options to wait until the server is accepting connections
# - https://learn.microsoft.com/en-us/sql/tools/sqlcmd/sqlcmd-utility
#
until /opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -h -1 -t 1 -C -Q 'SELECT 1' > /dev/null 2>&1
do
  sleep 1
done

#
# Add a small delay to ensure the server reaches a ready state
#
sleep 10

#
# If required, create the database and user for the Curity Identity Server
#
/opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d master -C -i /tmp/initscripts/create-database-and-user.sql
if [ $? -ne 0 ]; then
  echo 'Problem encountered creating database and logins'
  exit 1
fi

#
# Create maintenance stored procedures
#
/opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d idsvr -C -I -i /tmp/initscripts/sp_clear_nonces.sql
if [ $? -ne 0 ]; then
  echo 'Problem encountered creating the sp_clear_nonces maintenance procedure'
  exit 1
fi

/opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d idsvr -C -I -i /tmp/initscripts/sp_clear_tokens.sql
if [ $? -ne 0 ]; then
  echo 'Problem encountered creating the sp_clear_tokens maintenance procedure'
  exit 1
fi

/opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d idsvr -C -I -i /tmp/initscripts/sp_clear_sessions.sql
if [ $? -ne 0 ]; then
  echo 'Problem encountered creating the sp_clear_sessions maintenance procedure'
  exit 1
fi

/opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d idsvr -C -I -i /tmp/initscripts/sp_clear_delegations.sql
if [ $? -ne 0 ]; then
  echo 'Problem encountered creating the sp_clear_delegations maintenance procedure'
  exit 1
fi

#
# See if the maintenance job already exists in the msdb database
#
JOB_COUNT=$(/opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d msdb -h -1 -t 1 -C -Q 'SET NOCOUNT ON; SELECT COUNT(1) FROM sysjobs WHERE name="idsvr_maintenance"')
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Set up the database maintenance job in the msdb database, to call the above stored procedures
#
if [ $JOB_COUNT -eq 0 ]; then
  /opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d msdb -C -I -i /tmp/initscripts/create-maintenance-job.sql
  if [ $? -ne 0 ]; then
    echo 'Problem encountered creating database maintenance jobs'
    exit 1
  fi
fi
