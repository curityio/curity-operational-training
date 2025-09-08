# Course Tasks

## Lesson 2

Mention database recreations and new account records.

## Lesson 3: Scaling Tokens

- Mention the default scope - and test it.
- Use the working with claims technique to use client properties and get different token formats.
- Mention token sharing and the need for end to end.
- Token procedure that does it and what the client does

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

### User Management Course

- Mention multiple user records are possible.
- Survive database migrations, e.g. a unique index.

### User Authentication Course

- Better explain Azure groups hack in order for the deployment to support any OIDC provider.
- Different types of action attributes.
- Linked to JavaScript customizations and ghow we say more in the customizations course.
- subject_claims_provider -> subeject-claims-provider?

- Test user must be test.user@customer.example - update user creation script
  Mention the script in the user authentication course.

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

### SSL for Early Deployments

Take a look and optionally update screenshots, since I now use HTTPS since cluster deployment.
