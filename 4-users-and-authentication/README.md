# Users and Authentication

These resources accompany the lessons from the [Users and Authentication](https://curity.io/training/users-and-authentication) course.\
Extends the local deployment to enable the management of customer and employee users.

## User Administration

This deployment gets these areas up and running:

- Get User Management APIs
- Attribute Authorization Manager
- DevOps Dashboard

## User Authentication

This deployment gets these areas up and running:

- Create customer user accounts and use email as the identifier users type.
- Customer users use email authentication for account recovery.
- Customer users sign in with passwords or passkeys.
- Employee users sign in with an external identity provider that provides a corporate login policy.
- Enable sole roles of employees, like helpdesk staff, to sign in to customer applications.

## Deployments

These deployments use HTTPS so that login methods like passkeys work.\
They revert to a single instance of the Curity Identity Server, which is sufficient for this course.

After deployment, trust the root certificate at the following location.\
For example, on maccOS import it into Keychain Access under System / Certificates.

```text
utils/ssl-certs/example.ca.crt
```

Also update your `/etc/hosts` file with a line that resolves the test domains:

```text
127.0.0.1 admin.demo.example login.demo.example mail.demo.example
```
