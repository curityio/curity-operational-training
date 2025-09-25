# Minimal Console Client

The minimal console client enables you to quickly run a code flow and view tokens.

## Usage

To run the console client, first install Node.js 22 or later and clone this repository.\
Then open a command shell in this folder and run `npm install`.

### Run a Login

You can test logins with the following command:

```bash
npm run login
```

### View Access Token Claims

You can run a login and then view access token claims with the following command.\
The client acts as an API gateway and introspects access tokens to visualize their claims.

```bash
npm run token
```

### View All Tokens

You can run a login and then view all tokens with the following command.\
This visualizes access token claims, ID token claims and the client's OAuth userinfo.

```bash
npm run tokens
```

### Exchange an Access Token

If you use the configuration from the token issuance course you can run a token exchange flow.\
You can run a login and then exchange the original access token with the following command.\
The client then acts as an API and uses token exchange to downscope the access token.\
The exchanged access token maintains the user identity but no longer contains custom claims.

```bash
npm run exchange
```

### Configuration

By default, the console client points to OAuth endpoints for this repository's local deployments.\
You can set the following environment variable to point it to a different base URL before running npm commands:

```bash
export RUNTIME_BASE_URL='http://localhost:8443'
```

Each course has XML configuration for the console client that you can import into your system.\
To run a code flow with the console client, save the following XML to a `client.xml` file and upload it in the Admin UI.\
Choose the merge option and commit changes, after which you can run the client and view all tokens.

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
                <scope>profile</scope>
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

## Advantages

The minimal client has some advantages over OAuth Tools:

- It is tailored to the teaching material.
- It does not require an ngrok tunnel, which may not be possible in some environments.
- It maintains the course's preferred local URLs.
- It supports logins with passkeys, which Desktop OAuth Tools does not currently support.
