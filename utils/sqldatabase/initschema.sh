#!/bin/bash

###################################################################################################
# This script is run from a utility Docker image that is an instance of the Curity Identity Server.
# It runs `idsvr -I` to trigger Liquibase to create or upgrade the database schema.
###################################################################################################

echo '*** initschema.sh: Waiting until the database server is ready ...'
sleep 60

echo '*** initschema.sh: Creating or upgrading the schema for the Curity Identity Server ...'
idsvr -I
