
## Deployment Instructions

First, update your `/etc/hosts` file to include the domain for the test email inbox:

```text
127.0.0.1 admin.demo.example login.demo.example mail.demo.example
```

If you haven't already done so, trust the root certificate at the following location.\
For example, on macOS, import it into Keychain Access under System / Certificates.

```text
utils/ssl-certs/example.ca.crt
```

Edit the `config/parameters.env` file and the `vault/secrets.env` files and update the following parameters.\
Set values that match your external identity provider for employee logins (like a trial version of Entra ID):

- EMPLOYEE_IDP_CLIENT_ID
- EMPLOYEE_IDP_OIDC_METADATA
- EMPLOYEE_IDP_CLIENT_SECRET_RAW

Copy a `license.json` file to this folder and run `./go.sh` to perform the deployment.\
Once the system is up and running, sign in to the DevOps Dashboard and the Admin UI with the IDP.\
To understand and troubleshoot the deployment, see content for the [Users and Administration](https://curity.io/training/users-and-authentication) training course.

## Query Data

As you run OAuth flows you can also get to see how the Curity Identity Server uses data.\
See the [Data Sources README](../../2-data-sources/README.md) to get connected to the local database and run queries.