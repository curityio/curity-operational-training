# Users and Authentication

These resources accompany the lessons from the [Users and Authentication](https://curity.io/training/users-and-authentication) course.\
Extends the local deployment to enable the management of customer and employee users.

## User Administration

This deployment gets these areas up and running:

- User Management APIs with an Attribute Authorization Manager
- DevOps Dashboard

## User Authentication

This deployment gets these areas up and running:

- Create customer user accounts with control over user attributes.
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

## Testing

You can run a test client from the `utils/console-client` folder to test all types of logins.\
To do so, ensure that Node.js is installed and run the following commands from that folder:

```bash
npm install
npm start
```
