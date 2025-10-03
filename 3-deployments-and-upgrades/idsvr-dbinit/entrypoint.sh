#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Create the database schema if required
#
/tmp/initscripts/initdb.sh

#
# For debug purposes, also keep the utility running as a utility container
#
/bin/sleep infinity
