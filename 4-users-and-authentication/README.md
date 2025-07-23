# Users and Authentication

These resources accompany the lessons from the [Users and Authentication](https://curity.io/training/users-and-authentication) course.\
The course explains how to manage and authenticate both customer and employee users.\
These resources complement the theory with working deployments to compare against.

## User Administration

The [user administration deployment](1-user-administration/README.md) shows how to implement the following tasks:

- Expose User Management APIs and restrict allowed clients with an Attribute Authorization Manager.
- Run the DevOps Dashboard as a client of the Curity Identity Server's GraphQL APIs.
- Act as an employee then creates customer user accounts and sets built-in or custom user attributes.

## User Authentication

The [user authentication deployment](2-user-authentication/README.md) has more advanced settings to highlight the following behaviors:

- Customer users can sign in with either passwords or passkeys, with email-based account recovery.
- Employees can sign in with an external identity provider like Microsoft Entra ID.
- The DevOps Dashboard and Admin UI can integrate with the IDP to meet your corporate employee login policy.
- In your applications, you can present tailored authentication options to both customer users and employees.
