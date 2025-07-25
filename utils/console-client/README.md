# Minimal Console Client

When possible, use [OAuth Tools](https://curity.io/oauth-tools/) as a client to test OAuth flows:

- Run a code flow to test user authentication.
- Receive an opaque access token.
- Introspect the access token to view its claims.

## OAuth Tools and Local Deployments

If you run a local deployment of the Curity Identity Server, you may run into some issues with the [Web OAuth Tools Client](https://oauth.tools/):

- You need to expose the local deployment to the internet with a tool like ngrok.
- ngrok may be blocked by IT restrictions in some corporate environments.
- ngrok uses generated URLs which can make the meaning of URLs in OAuth flows less clear.
- When a local deployment uses SSL, you may run into trust issues.

You can solve some of these problems with Desktop OAuth Tools, but that still has some issues:

- It uses the Chromium browser and logins with passkeys are not supported.

## Console Client

You can use this simple Node.js console client as an alternative to OAuth Tools.\
You must first have a deployment with working users, clients and authenticators.\
To prepare the console client, first run `npm install`.

### Test Logins

Use the `npm run login` command to focus on logins and the user experience.\
On success, the console client outputs an authorization code:

```text
Starting login ...
Completed login and received authorization code: CRZ8st9cccPGtQZrP0cBJigmOkNcrLJg
```

### View Access Tokens

Use the `npm run login` command to trigger a login and then get an access token.\
The flow outputs token details, which enables you to quickly verify the claims issued to access tokens.

```text
Logging in and getting access token ...
Received opaque access token: _0XBPWQQ_82b0301e-2c4f-44ac-b7c2-d7fec79c9b14
Received JWT access token:
{
  "sub": "testuser@demo.example",
  "purpose": "access_token",
  "iss": "https://login.demo.example/~",
  "active": true,
  "groups": [
    "admin"
  ],
  "token_type": "bearer",
  "client_id": "console-client",
  "aud": "console-client",
  "nbf": 1753280007,
  "scope": "openid",
  "exp": 1753280307,
  "delegationId": "1b6f0ac7-c234-45d3-a1d5-1007e6bd9449",
  "iat": 1753280007
}
```

### OAuth Configuration Settings

The console client uses two OAuth clients and you can import the following file to configure them.

```xml
<config xmlns="http://tail-f.com/ns/config/1.0">
  <profiles xmlns="https://curity.se/ns/conf/base">
    <profile>
      <id>token-service</id>
      <type xmlns:as="https://curity.se/ns/conf/profile/oauth">as:oauth-service</type>
      <expose-detailed-error-messages />
      <settings>
        <authorization-server xmlns="https://curity.se/ns/conf/profile/oauth">
          <client-store>
            <config-backed>
              <client>
                <id>console-client</id>
                <no-authentication>true</no-authentication>
                <redirect-uris>http://127.0.0.1/callback</redirect-uris>
                <proof-key>
                  <require-proof-key>true</require-proof-key>
                </proof-key>
                <scope>openid</scope>
                <user-authentication>
                  <allowed-authenticators>passwords</allowed-authenticators>
                  <allowed-authenticators>passkeys</allowed-authenticators>
                  <allowed-authenticators>employees</allowed-authenticators>
                </user-authentication>
                <capabilities>
                  <code>
                  </code>
                </capabilities>
                <validate-port-on-loopback-interfaces>false</validate-port-on-loopback-interfaces>
              </client>
              <client>
                <id>introspect-client</id>
                <secret>Password1</secret>
                <capabilities>
                  <introspection />
                </capabilities>
              </client>
            </config-backed>
          </client-store>
        </authorization-server>
      </settings>
    </profile>
  </profiles>
</config>
```

By default, the console client points to OAuth endpoints for this repository's local deployments.\
You can edit the following files to point to a remote system instead.

```text
src/oauthClient.ts
src/introspectClient.ts
```
