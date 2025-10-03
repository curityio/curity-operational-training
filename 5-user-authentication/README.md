
## User Authentication

These resources accompany the lessons from the [User Authentication](https://curity.io/training/user-authentication) course.\
The deployment highlights the following example behaviors:

- Customer users can sign in with either passwords or passkeys, with email-based account recovery.
- Employees can sign in with an external identity provider like Microsoft Entra ID.
- The DevOps Dashboard and Admin UI can integrate with the IDP to meet your corporate employee login policy.
- In your applications, you can present tailored login user experiences for both customer users and employees.

## Deployment Steps

Read the [Local Computer Setup](../SETUP.md) document to learn how to deploy and use the system.

## IDP Configuration

After deploying, use the Admin UI to edit the settings in the OIDC (employees) authenticator.\
Set your preferred values for these fields, like those for a trial version of Entra ID:

- Client ID
- Client Secret
- Configuration URL

Alternatively, set values in the `config/parameters.env` file and the `vault/secrets.env` files before deploying:

- EMPLOYEE_IDP_CLIENT_ID
- EMPLOYEE_IDP_CLIENT_SECRET_RAW
- EMPLOYEE_IDP_OIDC_METADATA

To get your IDP working with the DevOps Dashboard you may need to change the following settings:

- Activate the `Fetch User Info` OIDC authenticator setting to get values like the user's email.
- Edit the `user_type_set_procedure` authentication action to set your preferred employee email suffix.
- Edit the `employee_set_subject_procedure` authentication action to customize the logic fopr the groups claim.

## Run Flows

Use OAuth Tools or the [Test Client](../utils/console-client/README.md) to run OAuth flows.\
The following command performs only a login:

```bash
npm run login
```

The following command enables you to view access tokens and check for a `groups` claim:

```bash
npm run tokens
```
