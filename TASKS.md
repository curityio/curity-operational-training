# Course Tasks

### Token Exchange

Token exchange client to add to console client to show claims disappearing from source token.

### Manageability

Scenrio with `https://exerience.api.demo.example` audience and two scopes:
  /orders
  /reservations
  /benefits
  /payments

## General

### Scripting

- Point to scripting tutorial in both authentication and token issuance courses.

### User Management Course

- Mention multiple user records are possible.
- User accounts and identities should survive database migrations, e.g. a unique index.

### User Authentication Course

- Better explain Azure groups hack in order for the deployment to support any OIDC provider.
- Different types of action attributes.
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
