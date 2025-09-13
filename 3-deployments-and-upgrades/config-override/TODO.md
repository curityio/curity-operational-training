# Azure Container Apps Deployment

- Should have no config of its own
- Keep Docker Compose use of two .env files, which is expressive
- Extra Azure complexity is confined to a deployment 3 add-on script

## 2. Use Course 2 Config

- Do a replace on the config/parameters.env file using sed (different for macOS)
- Update DB_CONNECTION, ADMIN_BASE_URL, RUNTIME_BASE_URL
- Simplify non Azure deployments and remove DBSERVER_HOSTNAME

## 3. Use Course 4 Config

- Minor adjustment to copy logic
- Test user creation

## 4. Use Course 5 Config

- Minor adjustment to copy logic
- Different trust XML
- Extra parameter to run-crypto-tools to avoid SSL_TRUST_STORE
- Test user creation and user authentication flows

## 5. Use Course 6 Config

- Minor adjustment to copy logic
- Test user creation, user authentication and token issuance flows

## Cluster Behavior

- See if this is working
