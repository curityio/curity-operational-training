# Token Issuance

These resources accompany the lessons from the [Token Issuance](https://curity.io/training/token-issuance) course.\
The deployment shows how to implement the following tasks in the Curity Identity Server:

- Implement least privilege access tokens using scopes.
- Issue claims within scopes and resolve claim values in various ways.
- Control API user identities issued to access tokens.
- Control ID token claims and attributes returned from the OpenID Connect userinfo endpoint.
- Use token exchange to scale the use of access tokens.

## Prerequisites

First read the [Local Computer Setup](SETUP.md) document to learn about prerequisites and test behaviors.

## Create a Test Customer User

After deployment you can use the following script from the repository's root folder.\
This creates a test user account with email `test.user@demo.example` and password `Password1`.

```bash
./utils/testuser/create.sh
```

## Run Flows

Use OAuth Tools or the [Test Client](../utils/console-client/README.md) to run OAuth flows.\
The following commands show fully customized token data:

```bash
export SCOPE="openid profile sales"
npm run tokens
```

The following commands show how to use OAuth 2.0 token exchange to get new tokens:

```bash
export SCOPE="openid profile sales"
npm run exchange
```

## Query Identity Data

After running flows, see the [Data Sources README](../2-data-sources/README.md) to get connected to the local database and run queries.
