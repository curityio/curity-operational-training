#/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

##################################################################
# Use crypto tools to create protected secrets on every deployment
##################################################################

OUTPUT_FOLDER="$1"
if [ "$OUTPUT_FOLDER" == '' ]; then
  echo 'Please provide an output folder to the create-parameters script'
  exit 1
fi

#
# Fix newline issues on Windows with Git bash, including for bash scripts downloaded from GitHub
#
LINE_SEPARATOR='\n';
if [[ "$(uname -s)" == MINGW64* ]]; then
 
  LINE_SEPARATOR='\r\n';
  sed -i 's/\r$//' ./encrypt-secret.sh
  sed -i 's/\r$//' ./encrypt-keystore.sh
fi

#
# Running a utility Docker container provides one way to invoke Curity crypto tools
#
echo 'Deploying temporary Docker container ...'
docker rm -f curity 2>/dev/null
docker run -d -p 6749:6749 -e PASSWORD=Password1 --user root --name curity curity.azurecr.io/curity/idsvr:latest
if [ $? -ne 0 ]; then
  exit 1
fi

echo 'Waiting for the temporary Docker container ...'
trap 'docker rm -f curity 1>/dev/null 2>&1' EXIT
while [ "$(curl -k -s -o /dev/null -w ''%{http_code}'' "https://localhost:6749/admin/login/login.html")" != '200' ]; do
  sleep 2
done

docker cp ./encrypt-secret.sh   curity:/tmp/
docker cp ./encrypt-keystore.sh curity:/tmp/
docker exec -i curity bash -c 'chmod +x /tmp/encrypt-secret.sh'
docker exec -i curity bash -c 'chmod +x /tmp/encrypt-keystore.sh'
echo 'Temporary Docker container running ...'

#
# Demonstrates how to generate a new cluster key during deployments
# You must do this when upgrading the Curity Identity Server to a new version
# You can optionally do it whenever you trigger a redeployment of all admin and runtime nodes
#
if [ "$GENERATE_CLUSTER_KEY" == 'true' ]; then

  cd "$OUTPUT_FOLDER/config"
  CLUSTER_CONFIG=$(docker exec -i curity bash -c "genclust -c idsvr-admin")
  if [ $? -ne 0 ]; then
    exit 1
  fi
  echo "$CLUSTER_CONFIG" > cluster.xml
fi

#
# Simulate a CI/CD system downloading secrets from a secure vault
#
cd "$OUTPUT_FOLDER/vault"
. ./secrets.env
CONFIG_ENCRYPTION_KEY="$(cat ./encryption.key)"
SYMMETRIC_KEY_RAW="$(cat ./symmetric.key)"
SIGNING_KEY_PATH=./signing.p12

#
# Use crypto tools to protect the secrets
#
echo 'Protecting secrets ...'
ADMIN_PASSWORD=$(openssl passwd -5 "$ADMIN_PASSWORD_RAW")

DB_CONNECTION=$(docker exec -i curity bash -c "PLAINTEXT='$DB_CONNECTION_RAW' CONFIG_ENCRYPTION_KEY='$CONFIG_ENCRYPTION_KEY' /tmp/encrypt-secret.sh")
if [ $? -ne 0 ]; then
  echo "$DB_CONNECTION"
  exit 1
fi

DB_PASSWORD=$(docker exec -i curity bash -c "PLAINTEXT='$DB_PASSWORD_RAW' CONFIG_ENCRYPTION_KEY='$CONFIG_ENCRYPTION_KEY' /tmp/encrypt-secret.sh")
if [ $? -ne 0 ]; then
  echo "$DB_PASSWORD"
  exit 1
fi

SYMMETRIC_KEY=$(docker exec -i curity bash -c "PLAINTEXT='$SYMMETRIC_KEY_RAW' CONFIG_ENCRYPTION_KEY='$CONFIG_ENCRYPTION_KEY' /tmp/encrypt-secret.sh")
if [ $? -ne 0 ]; then
  echo "$SYMMETRIC_KEY"
  exit 1
fi

SIGNING_KEY_BASE64=$(openssl base64 -in "$SIGNING_KEY_PATH" | tr -d "$LINE_SEPARATOR")
SIGNING_KEY_RAW=$(docker exec -i curity bash -c "convertks --in-password '$SIGNING_KEY_PASSWORD' --in-alias curity.signing --in-entry-password '$SIGNING_KEY_PASSWORD' --in-keystore '$SIGNING_KEY_BASE64'")
if [ $? -ne 0 ]; then
  echo "$SIGNING_KEY_RAW"
  exit 1
fi

SIGNING_KEY=$(docker exec -i curity bash -c "PLAINTEXT='$SIGNING_KEY_RAW' CONFIG_ENCRYPTION_KEY='$CONFIG_ENCRYPTION_KEY' /tmp/encrypt-keystore.sh")
if [ $? -ne 0 ]; then
  echo "$SIGNING_KEY"
  exit 1
fi

#
# Save protected secrets to environment variables
#
echo "export ADMIN_PASSWORD='$ADMIN_PASSWORD'"                  > ./protected-secrets.env
echo "export DB_CONNECTION='$DB_CONNECTION'"                   >> ./protected-secrets.env
echo "export DB_PASSWORD='$DB_PASSWORD'"                       >> ./protected-secrets.env
echo "export CONFIG_ENCRYPTION_KEY='$CONFIG_ENCRYPTION_KEY'"   >> ./protected-secrets.env
echo "export SYMMETRIC_KEY='$SYMMETRIC_KEY'"                   >> ./protected-secrets.env
echo "export SIGNING_KEY='$SIGNING_KEY'"                       >> ./protected-secrets.env

#
# The first Users and Authentication deployment uses extra secrets for basic user management
#
if [ "$USER_MANAGEMENT" == 'true' ]; then

  MIGRATION_CLIENT_SECRET=$(openssl passwd -5 "$MIGRATION_CLIENT_SECRET_RAW")
  echo "export MIGRATION_CLIENT_SECRET='$MIGRATION_CLIENT_SECRET'" >> ./protected-secrets.env

  INTROSPECT_CLIENT_SECRET=$(openssl passwd -5 "$INTROSPECT_CLIENT_SECRET_RAW")
  echo "export INTROSPECT_CLIENT_SECRET='$INTROSPECT_CLIENT_SECRET'" >> ./protected-secrets.env
fi

#
# The second Users and Authentication deployment uses extra secrets related to external IDPs and user authentication
#
if [ "$USER_AUTHENTICATION" == 'true' ]; then

  EMPLOYEE_IDP_CLIENT_SECRET=$(docker exec -i curity bash -c "PLAINTEXT='$EMPLOYEE_IDP_CLIENT_SECRET_RAW' CONFIG_ENCRYPTION_KEY='$CONFIG_ENCRYPTION_KEY' /tmp/encrypt-secret.sh")
  if [ $? -ne 0 ]; then
    exit 1
  fi
  echo "export EMPLOYEE_IDP_CLIENT_SECRET='$EMPLOYEE_IDP_CLIENT_SECRET'" >> ./protected-secrets.env

  ADMIN_CLIENT_SYMMETRIC_KEY_RAW="$(cat ./admin-client-symmetric.key)"
  ADMIN_CLIENT_SYMMETRIC_KEY=$(docker exec -i curity bash -c "PLAINTEXT='$ADMIN_CLIENT_SYMMETRIC_KEY_RAW' CONFIG_ENCRYPTION_KEY='$CONFIG_ENCRYPTION_KEY' /tmp/encrypt-secret.sh")
  if [ $? -ne 0 ]; then
    exit 1
  fi
  echo "export ADMIN_CLIENT_SYMMETRIC_KEY='$ADMIN_CLIENT_SYMMETRIC_KEY'" >> ./protected-secrets.env

  SSL_TRUST_STORE_RAW=$(openssl base64 -in ../../../utils/ssl-certs/example.ca.crt | tr -d "$LINE_SEPARATOR")
  SSL_TRUST_STORE=$(docker exec -i curity bash -c "PLAINTEXT='$SSL_TRUST_STORE_RAW' CONFIG_ENCRYPTION_KEY='$CONFIG_ENCRYPTION_KEY' /tmp/encrypt-keystore.sh")
  if [ $? -ne 0 ]; then
    exit 1
  fi
  echo "export SSL_TRUST_STORE='$SSL_TRUST_STORE'" >> ./protected-secrets.env
fi
