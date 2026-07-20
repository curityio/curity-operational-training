#!/bin/bash

###################################################################################
# This script is run from a utility Docker image of the Curity Identity Server.
# It runs `idsvr -I` to trigger Liquibase to create or upgrade the database schema.
###################################################################################

idsvr -I
