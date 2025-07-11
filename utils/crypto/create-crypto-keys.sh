#/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

########################################################################
# Create crypto keys for each stage of the deployment pipeline only once
########################################################################

#
# Get the output location to save keys to
#
OUTPUT_FOLDER="$1"
if [ "$OUTPUT_FOLDER" == '' ]; then
  echo 'Please provide an output folder to the create-crypto-keys script'
  exit 1
fi

#
# Simulate saving crypto keys to a secure vault
#
cd "$OUTPUT_FOLDER/vault"

#
# Get the token signing private key password
#
. "$OUTPUT_FOLDER/vault/secrets.env"

#
# Create crypto keys, like those to sign tokens, once per stage of the deployment pipeline
# On subsequent redeployments, reuse the existing keys
#
if [ -f ./signing.p12 ]; then
  exit 0
fi

#
# You can optionally create a new config encryption key on every full redeployment of admin and runtime nodes
#
openssl rand 32 | xxd -p -c 64 > encryption.key

#
# Create a symmetric key that encrypts SSO cookies
#
openssl rand 32 | xxd -p -c 64 > symmetric.key

#
# Create a token signing private key used to sign access tokens delivered to APIs
# Use your preferred algorithm to generate the key
#
openssl genpkey -algorithm EC  -pkeyopt ec_paramgen_curve:prime256v1 -out signing.key

#
# Save the token signing key and a certificate to a password protected PKCS#12 file
#
openssl req -new -key signing.key -out signing.csr -subj "/CN=curity.signing"
openssl x509 -req -in signing.csr -signkey signing.key -out signing.crt -days 365
openssl pkcs12 -export -inkey signing.key -in signing.crt -name curity.signing -out signing.p12 -passout pass:"$SIGNING_KEY_PASSWORD"

#
# Remove unused crypto files
#
rm signing.csr
rm signing.crt
rm signing.key
