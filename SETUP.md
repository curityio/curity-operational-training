# Local Computer Setup

Most examples use local Docker based deployments, to enable fast feedback.\
When required, roles should collaborate to enable local setups.

## 1. Local Administrator Privileges

You are likely to need local administrator privileges for certain operations.

## 2. Tools

Make sure you have the following tools installed:

- A Docker engine, configured with 8GB of RAM.
- The OpenSSL tool.
- The jq tool.

## 3. License

You also need a license file for the Curity Identity Server, such as a trial account.

## 4. Enable Local URLs

Examples use a backend cluster and domain-based URLs similar to real deployments.\
You then connect to that cluster from frontends, most commonly:

- Browsers run login screens at `https://login.demo.example`.
- Administrative user interfaces run at `https://login.demo.example`.

On Windows, Git bash provides a Linux environment with good frontend and backend performance.

### Enable DNS

To enable those URLs you must add the following entries to your hosts file:

```text
127.0.0.1 admin.demo.example login.demo.example
```

The hosts file is located at the following locations:

- `/etc/hosts` on macOS or Linux computers.
- `C:\windows\system32\drivers\etc\hosts` on Windows.

### Enable HTTPS Trust

Most deployments use HTTPS certificates and create a certificate at this location:

```text
utils/ssl-certs/
```

Trust the certificate by importing it into the local computer's trust store, for example:

- On macOS, open Keychain Access and import the file under `System / Certificates`.
- On Windows, use the Microsoft Management Console and import the file under `Local Computer / Trusted Root Certification Authorities`.

## 5. Run a Deployment

To run most deployments, open a Linux terminal it ita folder.\
Then, copy in a `license.json` file and run `./deploy.sh` to perform the deployment.

## 6. Run the Admin UI

To sign in to the Admin UI, use the following details.\
Some early courses use HTTP instead of HTTPS.

URL: `https://admin.demo/example/admin`
Username: `admin`

## 7. Use Passwords

For convenience, all courses that use passwords use password values of `Password1`.\
For real systems you should instead use strong passwords, or, preferably, avoid them altogether.

## 8. Test Logins with an OAuth Client

When you want to run OAuth flows for a deployed example you need an OAuth client.\
You can choose from one of the following options:

- Use the online OAuth Tools and an ngrok tunnel to reach local environments.
- USe the desktop OAuth Tools and point to the local environment.
- Use a [Minimal Console Client](utils/console-client/README.md), tailored to the course's content, that we provide.

## 9. Test Users

Courses use a customer user who signs in with an email of `test.user@customer.example`.\
Employee users instead authenticate with a corporate identity provider.
