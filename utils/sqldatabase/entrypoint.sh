#!/bin/bash

/tmp/initscripts/initdb.sh &
/opt/mssql/bin/sqlservr
