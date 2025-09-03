# Token Issuance

These resources accompany the lessons from the [Token Issuance](https://curity.io/training/token-issuance) course.\
The deployment shows how to implement the following tasks in the Curity Identity Server:

- Implement least privilege access tokens using scopes.
- Issue claims within scopes and resolve claim values in various ways.
- Control API user identities issued to access tokens.
- Control ID token claims and attributes returned from the OpenID Connect userinfo endpoint.
- Use token exchange to scale the use of access tokens.

## Deployment Instructions

First, update your `/etc/hosts` file to include the domains for the local Curity Identity Server:

```text
127.0.0.1 admin.demo.example login.demo.example
```

Then, trust the root certificate at the following location.\
For example, on macOS, import it into Keychain Access under System / Certificates.

```text
utils/ssl-certs/example.ca.crt
```

Copy a `license.json` file to this folder and run `./go.sh` to perform the deployment.\
Then sign in to the Admin UI as user `admin` with an initial credential of `Password1`.

## Create a Test Customer User

After deployment you can use the following script to create a test user account:

```bash
./testuser/create.sh
```

The user has an email of `test.user@demo.example` that you can use for authentication purposes.\
The user can sign in with either passwords or passkeys.\
The user has a password of `Password1` that you can use for password logins.

## Query Token Data

As you run OAuth flows you can also get to see how the Curity Identity Server stores token related data.\
See the [Data Sources README](../2-data-sources/README.md) to get connected to the local database and run queries.
