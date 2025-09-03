
## User Authentication

These resources accompany the lessons from the [User Authentication](https://curity.io/training/user-authentication) course.\
The deployment highlights the following example behaviors:

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
Once the system is up and running, sign in to the DevOps Dashboard and the Admin UI with the IDP.

## IDP Configuration

After deploying, use the Admin UI to edit the settings in the OIDC (employees) authenticator.\
Set your preferred values for these fields, like those for a trial version of Entra ID:

- Client ID
- Client Secret
- Configuration URL

Alternatively you can edit the `config/parameters.env` file and the `vault/secrets.env` files before deploying:

- EMPLOYEE_IDP_CLIENT_ID
- EMPLOYEE_IDP_OIDC_METADATA
- EMPLOYEE_IDP_CLIENT_SECRET_RAW

To get your IDP working with the DevOps Dashboard you may need to change the following settings:

- For some providers you may need to activate the `Fetch User Info` setting to get values like the user's email.
- Edit the `user_type_set_procedure` authentication action to set your preferred employee email suffix.
- Edit the `employee_set_subject_procedure` authentication action to set the groups claim and user display name.

## Create a Test Customer User

After deployment you can use the following script to create a test user account:

```bash
./testuser/create.sh
```

The user has an email of `test.user@demo.example` that you can use for authentication purposes.\
The user can sign in with either passwords or passkeys.\
The user has a password of `Password1` that you can use for password logins.

## Query Data

As you run OAuth flows you can also get to see how the Curity Identity Server uses data.\
See the [Data Sources README](../2-data-sources/README.md) to get connected to the local database and run queries.
