# Deployment Tasks

## Account ID as Subject

Do this next.

## Scopes and Claims

Add an `orders` scope to the deployment.
You will need to configure it against the console client.
Extend user creation:

- user_id
- tenant_id
- country_code
- age

Add a tenant ID to the authentication profile.\
User must update the console client with the `orders` scope.\
Make activating user consent a task to show how that looks.

## Set Audience for Clients

Token should include an API identity in its audience claim.

## ID Token and User Info

Indicate that PII may be returned from userinfo endpoint.\
With ID tokens more chance of it being revealed in front channel requests.\
Use an ID token custom claim:

- has_mfa=true if using passkeys.
- A frontend might prompt the user to use more features with stronger authentication.

## Token Exchange

Use curl to run a token exchange flow and simulate an API client.\
Then explain procedures.

## Embedded Token

Refer back to user authentication, show its user attributes and say how to get an embedded token.\
Then show what it looks like.

## README Consolidation

Admin UI, /etc/hosts to add to all READMEs.
Broken image here to fix:
- https://dev.curityio.net/training/user-management/accounts/lesson/