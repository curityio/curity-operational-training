#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#####################################################################
# Set up the Curity Identity Server database with the sqlcmd tool
# - https://learn.microsoft.com/en-us/sql/tools/sqlcmd/sqlcmd-utility
#####################################################################

#
# Wait for system databases to come online
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
# Create base resources
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
# Wait for the Agent process to come up
#
AGENTSTATUS=''
while [[ $AGENTSTATUS -ne 1 ]]; do
	AGENTSTATUS=$(/opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -h -1 -t 1 -C -Q "SET NOCOUNT ON; SELECT 1 FROM sysprocesses WHERE program_name=''SQLAgent - Generic Refresher''")
  if [[ $AGENTSTATUS -ne 1 ]]; then
    sleep 1
  fi
done

#
# Set up the database maintenance job in the msdb database
#
if [ $JOB_COUNT -eq 0 ]; then
  /opt/mssql-tools18/bin/sqlcmd -U sa -P $MSSQL_SA_PASSWORD -d msdb -C -I -i /tmp/initscripts/create-maintenance-job.sql
  if [ $? -ne 0 ]; then
    echo 'Problem encountered creating database maintenance jobs'
    exit 1
  fi
fi
