# Course Tasks



## Finish Lesson 2

- Finish doc
- Mention that claims can be objects and arrays when I use transformation and show roles
- Return null to not issue claim

## Refine Lesson 1

- Show how user consent looks and say you can customize consent 
- Mention the refresh token
- Larger setups and multiple user records
- Default scope
- Use customer.example for customer users and demo.example for employee users

## Lesson 3: Scaling Tokens

TODO

- Currently the user_id claim is issued under openid.
- Add the user_id to the default scope - and test it.
- Make sure it works for employees and explain missing source values.

### Token Issuers

- Use the working with claims technique to use client properties.

### Tokens End to End

Mention token sharing and the need for end to end.

### Resource indicators

Token procedure that does it and what the client does

### Token Exchange

Use curl to run a token exchange flow and simulate an API client.\
Then explain procedures and again use a client property.\
Also explain changing scopes dynamically in authorization endpoint, e.g. step up authentication.\
Link to tutorial.

### Manageability

End with scopes and claims best practices.
Dependencies at a technical and people level.

Scenrio with 'experience' audience and scopes:
/orders
/reservations
/benefits
/payments

## General

### Scripting

- Point to scripting tutorial in bvoth authentication and token issuance courses.

### User Authentication Course

- Better explain Azure groups hack in order for the deployment to support any OIDC provider.
- Different types of action attributes.
- Linked to JavaScript customizations and ghow we say more in the customizations course.
- subject_claims_provider -> subeject-claims-provider?

- Test user must be test.user@customer.example - update user creation script
  Mention the script in the user authentication course.

### User Management Course

- Mention multiple user records are possible.
- Survive database migrations, e.g. a unique index.

### Console Client

Better improve its README to explain its role.

### HTTPS

Use SSL from cluster onwards.
Explain in READMEs how to trust it, in a common setup page, on macOS and Windows.
Make sure Windows support is clear.

## SQL Server

Do wait on startup properly according to MSSQL.
Maybe a brief wait if needed.

### README Consolidation

Admin UI, /etc/hosts to add to all READMEs.\
Make sure Docker is configured to use sufficient at least 8GB+ of RAM.
Add a common SETUP page, e.g. precreate certs.\

### Logging and Monitoring

- Add some forward references to deployment tutorials
- Mention health / readiness / logs

### Self-Service Portal

I think I already mention this when I cover the Applications profile - but double check.

### Introductory Course

Introduce roles and explain:

- Company / people stuff
- Technical level expected of students
  Use of curl tool etc
  Supported environments
