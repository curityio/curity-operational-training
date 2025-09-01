
## User Authentication

The deployment uses some advanced settings to highlight the following behaviors:

- Customer users can sign in with either passwords or passkeys, with email-based account recovery.
- Employees can sign in with an external identity provider like Microsoft Entra ID.
- The DevOps Dashboard and Admin UI can integrate with the IDP to meet your corporate employee login policy.
- In your applications, you can present tailored authentication options to both customer users and employees.

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

Copy a `license.json` file to this folder and run `./go.sh` to perform the deployment.\
Once the system is up and running, sign in to the DevOps Dashboard and the Admin UI with the IDP.\
To understand and troubleshoot the deployment, see content for the [Users and Administration](https://curity.io/training/users-and-authentication) training course.

## IDP Configuration

Before deploying you can edit the `config/parameters.env` file and the `vault/secrets.env` files.\
Set values that match your external identity provider for employee logins (like a trial version of Entra ID):

- EMPLOYEE_IDP_CLIENT_ID
- EMPLOYEE_IDP_OIDC_METADATA
- EMPLOYEE_IDP_CLIENT_SECRET_RAW

Alternatively, use the Admin UI to edit the settings in the OIDC (employees) authenticator after deployment.\
To get your IDP working with the DevOps Dashboard you may need to change the following settings:

- For some providers you may need to activate the `Fetch User Info` setting to get values like the user's email.
- Edit the `user_type_set_procedure` authentication action to set your preferred employee email suffix.
- Edit the `employee_set_subject_procedure` authentication action to set the groups claim and user display name.

## Query Data

As you run OAuth flows you can also get to see how the Curity Identity Server uses data.\
See the [Data Sources README](../../2-data-sources/README.md) to get connected to the local database and run queries.
