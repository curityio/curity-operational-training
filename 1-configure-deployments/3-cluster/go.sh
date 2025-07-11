#/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Validate and prevent accidental checkins of license files
#
if [ ! -f ./license.json ]; then
  echo 'Please provide a license.json file in this folder before deploying'
  exit 1
fi
cp ../../hooks/pre-commit ../../.git/hooks

#
# Use the config encryption key generated on the first deployment
#
export CONFIG_ENCRYPTION_KEY='e3b860830de04cc47214d3363d00ed4b1d8d9fb8c9ec7c9877046c35665ac68c'

#
# Supply parameters to control URLs
#
export RUNTIME_BASE_URL='http://login.demo.example'
export ADMIN_BASE_URL='http://admin.demo.example'

#
# Run the deployment
#
docker pull kong/kong:latest
docker compose up
if [ $? -ne 0 ]; then
  exit 1
fi