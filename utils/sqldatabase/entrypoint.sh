#!/bin/bash

####################################################################
# Start server level setup in the background and then run SQL Server
####################################################################

/tmp/initscripts/initdbserver.sh &
/opt/mssql/bin/sqlservr
