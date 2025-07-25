
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
