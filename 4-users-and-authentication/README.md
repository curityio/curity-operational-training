# Users and Authentication

These resources accompany the lessons from the [Users and Authentication](https://curity.io/training/users-and-authentication) course.\
Extends the local deployment to enable the management of customer and employee users.

## User Administration

The first deployment gets these areas up and running:

- User Management APIs with an Attribute Authorization Manager
- DevOps Dashboard
- Employees can then create customer user accounts with control over user attributes.

## User Authentication

The second deployment gets these areas up and running:

- Customer users use email authentication for account recovery.
- Customer users sign in with passwords or passkeys.
- Employee users sign in with an external identity provider that provides a corporate login policy.
- Enable both customer users and employee users to sign in to customer applications with their preferred login methods.

## Deployments

This course includes example local deployments with HTTPS external URLs so that passkey logins work.\
Deployments revert to a single instance of the Curity Identity Server, which is sufficient for this course.

When you first run the deployment, trust the root certificate at the following location.\
For example, on maccOS import it into Keychain Access under System / Certificates.

```text
utils/ssl-certs/example.ca.crt
```

Also update your `/etc/hosts` file to include the domain for the test email inbox:

```text
127.0.0.1 admin.demo.example login.demo.example mail.demo.example
```

## Test Logins

You can run a test client from the `utils/console-client` folder to test various authenticators.\
To do so, ensure that Node.js is installed and run the following commands from that folder:

```bash
npm run login
npm start
```

## Test Tokens

You can run a test client from the `utils/console-client` folder to test logins and token issuance.\
To do so, run the following commands from the `utils/console-client` folder:

```bash
npm run token
npm start
```

## TODO - Integrate External IDPs

- Add Persisted SSO cookies for Entra ID
- More about troubleshooting and `npm run login` in console-client
- Follow its README instructions

## TODO - Manage Employee Authorization with Groups

- More about example deployment and its script transformer action
- More about troubleshooting and `npm run token` in console-client

## TODO - Apply Authentication Policies Write Up

- Second factor check disabled in MFA condition action

- Username authenticator script action to choose user's authenticator(s)
  Use @yourcompany.com to identify employees
  Offer a selector with passkeys or passwords to customer users

# TODO - Multi-Tenancy

Say a few points for user attributes and reference existing HOWTOs.
Mention Service Roles and Authentication Service settings for tenant ID.
