# Deployment Tasks

## Re-Browse Authentication

In the light of newer changes, see how this feels in terms of using a client and other aspects.\
Update the screenshot with the embedded token.\
Explain Azure groups hack in order for the deployment to support any OIDC provider.

## Use Consent

Add a note to issuance on what consent would look like.\
Say that you can customize consent.

## Mention Refresh Token

Briefly mention, but not relevant to this tutorial.

## Claims Resolution

Implement this and make it work for customers and employees.

### Account ID as Subject

Say how to use PPIDs and read the spec.\
Say how to do that.\
Update the example to use the account ID.

### Embedded Token

Refer back to user authentication, show its user attributes screenshot and say how to get an embedded token.\
Show that as JSON.

## Scale

### Token Issuers

Use the working with claims technique to use client properties.

### Tokens End to End

Mention token sharing and the need for end to end.

### Token Exchange

Use curl to run a token exchange flow and simulate an API client.\
Then explain procedures and again use a client property.\
Also explain changing scopes dynamically in authorization endpoint, e.g. step up authentication.\
Link to tutorial.

### Manageability

Refer to scopes and claims best practices.

## README Consolidation

Admin UI, /etc/hosts to add to all READMEs.\
Make sure Docker is configured to use sufficient at least 8GB+ of RAM.
Add a common SETUP page, e.g. precreate certs.\
Use SSL from cluster onwards.\
That will make specific pages nicer to read.

## Logging and Monitoring

Add some forward references to HOWTOs and logs.

## Self-Servioce Portal

I think I already mention this when I cover the Applications profile - but double check.