#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

. ../infrastructure.env
echo "$DBSERVER.database.windows.net"
