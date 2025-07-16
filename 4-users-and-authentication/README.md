# Users and Authentication

These resources accompany the lessons from the [Data Sources](https://curity.io/training/users-and-authentication) course.\
Extends the local deployment to enable the management of customer and employee users.

## User Management

This deployment gets these areas up and running, to back up the course theory:

- Get user management, an attribute authorization manager and the DevOps dashboard working.
- Support user migrations via SCIM.
- Support employee level user access via GraphQL.

## User Authentication

- Provide a setup that allows customer users to sign in with passwords or passkeys, with email account recovery.
- Then use a corporate login policy (Entra ID) for employees (Admin UI and DevOps Dashboard).
- Then use a username authenticator in applications to handle both customer users and employees.

## Initial API Access

The work in progress state of this PME deployment is to call SCIM endpoints like these:

```bash
ACCESS_TOKEN=$(curl -s -X POST http://login.demo.example/oauth/v2/oauth-token \
     -H 'Content-Type: application/x-www-form-urlencoded' \
     -d 'grant_type=client_credentials' \
     -d 'client_id=migration-client' \
     -d "client_secret=Password1" \
     -d 'scope=migrations' | jq -r '.access_token')

curl http://login.demo.example/users/Users \
    -H "Accept: application/scim+json" \
    -H "Authorization: Bearer $ACCESS_TOKEN"
```
