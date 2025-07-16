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

## TODO

1. For early deployments, rename cluster.xml to cluster-configuration.xml
   Then avoid checking in cluster.xml
