#/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"
RESPONSE_FILE='response.txt'

#
# Get an access token with the 'accounts_migration' scope.
# In the example deployment this allows SCIM access.
#
HTTP_STATUS=$(curl -s -X POST https://login.demo.example/oauth/v2/oauth-token \
     -H 'Content-Type: application/x-www-form-urlencoded' \
     -d 'grant_type=client_credentials' \
     -d 'client_id=migration-client' \
     -d "client_secret=Password1" \
     -d 'scope=accounts_migration' \
     -o "$RESPONSE_FILE" -w '%{http_code}')
if [ "$HTTP_STATUS" != '200' ]; then \
  echo "Problem encountered getting a SCIM access token, HTTP status: $HTTP_STATUS"
  exit
fi

ACCESS_TOKEN=$(cat "$RESPONSE_FILE" | jq -r '.access_token')
if [ "$ACCESS_TOKEN" == '' ]; then \
  echo 'No access token found in the token response'
  exit
fi

#
# Use SCIM to insert the test user account from JSON data
#
HTTP_STATUS=$(curl -s -k -X POST 'https://login.demo.example/users/Users' \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H 'Accept: application/scim+json' \
    -H 'Content-Type: application/scim+json' \
    -d @insert.json \
    -o "$RESPONSE_FILE" -w '%{http_code}')
if [ "$HTTP_STATUS" != '201' ]; then \
  echo "Problem encountered using SCIM to insert the test user, status: $HTTP_STATUS"
  exit
fi
