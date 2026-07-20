#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Initialize the database server if required
#
/tmp/initscripts/initdbserver.sh

#
# For debug purposes, also keep the utility running as a utility container
#
/bin/sleep infinity
