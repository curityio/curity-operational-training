#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#################################################################################################################
# When you create a data source for the Curity Identity Server it is essential to use a resilient database setup.
# Therefore, involve DBAs and follow similar processes that you use for your business data.
#################################################################################################################

#
# Wait for system databases to come online and use sqlcmd options:
# - https://learn.microsoft.com/en-us/sql/tools/sqlcmd/sqlcmd-utility
#
DBSTATUS=''
while [[ $DBSTATUS -ne 1 ]]; do
	DBSTATUS=$(/opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -h -1 -t 1 -C -Q "SET NOCOUNT ON; SELECT 1 FROM sys.databases WHERE name='msdb' and state = 0")
  if [[ $DBSTATUS -ne 1 ]]; then
    sleep 1
  fi
done
sleep 10

#
# Create the database and user for the Curity Identity Server
#
/opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d master -C -i /tmp/initscripts/create-database-and-user.sql
if [ $? -ne 0 ]; then
  echo 'Problem encountered creating database and logins'
  exit 1
fi

#
# See if tables already exist in the Curity Identity Server database
#
TABLE_COUNT=$(/opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d idsvr -h -1 -t 1 -C -Q 'SET NOCOUNT ON; SELECT COUNT(1) FROM sys.tables')
if [ $? -ne 0 ]; then
  echo "$TABLE_COUNT"
  exit 1
fi

#
# Create the schema with the -I option to prevent quoted identifier errors
#
if [ $TABLE_COUNT -eq 0 ]; then
  /opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d idsvr -C -I -i /tmp/initscripts/mssql-create_database.sql
  if [ $? -ne 0 ]; then
    echo 'Problem encountered creating the database schema'
    exit 1
  fi
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
