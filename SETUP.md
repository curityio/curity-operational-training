# Local Computer Setup

Most examples use local Docker based deployments, to enable fast feedback.\
You can deploy examples from a host computer that runs macOS, Linux or Windows.\
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
- Administrative user interfaces run at `https://admin.demo.example`.

### Enable DNS

To enable those URLs you must add the following entries to your hosts file:

```text
127.0.0.1 admin.demo.example login.demo.example mail.demo.example
```

The hosts file is located at the following locations:

- `/etc/hosts` on macOS or Linux computers.
- `C:\windows\system32\drivers\etc\hosts` on Windows.

### Enable HTTPS Trust

Most deployments use HTTPS certificates and create a root certificate authority at this location:

```text
utils/ssl-certs/example.ca.crt
```

Trust the certificate by importing it into the local computer's trust store, for example:

- On macOS, open Keychain Access and import the file under `System / Certificates`.
- On Windows, use the Microsoft Management Console and import the file under `Local Computer / Trusted Root Certification Authorities`.

## 5. Run a Deployment

To run most deployments, open a Linux terminal it ita folder.\
Then, copy in a `license.json` file and run `./deploy.sh` to perform the deployment.

## 6. Use Exposed URLs

To sign in to the Admin UI, most deployments use the following details:

- URL: `https://admin.demo/example/admin`
- Username: `admin`

Most deployments expose metadata that includes OAuth endpoints at the following URL:

```bash
curl -s -k https://login.demo.example/~/.well-known/openid-configuration | jq
```

For deployments that use email authentication, receive emails for test users at `https://mail.demo.example`.

## 7. Use Passwords

For convenience, all courses that use passwords or client secrets use values of `Password1`.\
For real systems you should instead use strong passwords, or, preferably, avoid them altogether.

## 8. Test Logins with an OAuth Client

When you want to run OAuth flows for a deployed example you need an OAuth client.\
You can choose from one of the following options:

- Use the online OAuth Tools and an ngrok tunnel to reach local environments.
- USe the desktop OAuth Tools and point to the local environment.
- Use a [Minimal Console Client](utils/console-client/README.md), tailored to the course's content, that we provide.

## 9. Use Test User Accounts

Administrator courses can use a test customer user account created by the following script.\
The user has an email of `test.user@customer.example`.

```bash
./utils/testuser/create.sh
```

## 10. Query Identity Data

As you generate identity data you can connect to a database and query it.\
See the [Data Sources README](./2-data-sources/README.md) to get connected to a local database and run queries.
