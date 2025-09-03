# User Management

These resources accompany the lessons from the [User Management](https://curity.io/training/user-management) course.\
The deployment shows how to implement the following tasks:

- Expose User Management APIs and restrict allowed clients with an Attribute Authorization Manager.
- Run the DevOps Dashboard as a client of the Curity Identity Server's GraphQL APIs.
- Act as an employee then creates customer user accounts and sets built-in or custom user attributes.

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
Once the system is up and running, perform these actions:

- Sign in to the DevOps Dashboard as user `admin`.
- Sign in to the Admin UI as user `admin` with an initial credential of `Password1`.

## Query Data

As you create user accounts you can also see how the Curity Identity Server stores them.\
See the [Data Sources README](../2-data-sources/README.md) to get connected to the local database and run queries.
