# Token Issuance

These resources accompany the lessons from the [Token Issuance](https://curity.io/training/token-issuance) course.\
The deployment shows how to implement the following tasks in the Curity Identity Server:

- Take full control over built-in and custom attributes.
- Issue values to access tokens, ID tokens or return them from the userinfo endpoint.
- Resolve claims from user accounts or user authentication and apply dynamic logic.
- Use token procedures and token exchange as part of a strategy to issue tokens at scale.

## Deployment Steps

Read the [Local Computer Setup](../SETUP.md) document to learn how to deploy and use the system.

## Run Flows

Use OAuth Tools or the [Test Client](../utils/console-client/README.md) to run OAuth flows.\
The following commands show fully customized token data:

```bash
npm run tokens
```

The following commands show how to use OAuth 2.0 token exchange to get new tokens:

```bash
npm run exchange
```
