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
# Create crypto keys once per stage of your deployment pipeline
#
export GENERATE_CLUSTER_KEY='true'
../../utils/crypto/create-crypto-keys.sh "$(pwd)"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# On every deployment, run crypto tools to create protected secrets
#
../../utils/crypto/run-crypto-tools.sh "$(pwd)"
if [ $? -ne 0 ]; then
  exit 1
fi

#
# Run the deployment
#
docker compose up
if [ $? -ne 0 ]; then
  exit 1
fi
