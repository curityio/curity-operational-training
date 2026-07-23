#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

##################################################################################################################
# A script that indicxates when the Curity Identity Server's schema exists, after which other containers can start
##################################################################################################################

/opt/mssql-tools18/bin/sqlcmd -U idsvruser -P Password1 -d idsvr -h -1 -t 1 -C -Q 'SELECT 1' 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo '*** The Curity Identity Server database and user are not yet ready'
  exit 1
fi
