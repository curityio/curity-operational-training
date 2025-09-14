# Test OAuth Flows in a Deployed Environment

Once you understand the deployment you can deploy more complete configurations.\
You can then test OAuth flows using an internet Curity Identity Server cluster.

## Deploy Advanced Configurations

Re-run the following commands to redeploy with configuration from the administrator courses.\
Run scripts one at a time and wait for each to complete successfully.

```bash
export CONFIGURATION_FOLDER='6-token-issuance'
./3-build-images.sh
./6-deploy-idsvr.sh
```

## Create a Test User Account

Run the following commands to create the test user:

```bash
export RUNTIME_BASE_URL=$(./postdeployment/runtime-base-url.sh)
../utils/testuser/create.sh
```

## Run OAuth Flows

You can then run OAuth flows with a test client, like OAuth Tools.\
To use the [Minimal Console Client](../utils/console-client/README.md), use commands like the following:

```bash
export RUNTIME_BASE_URL=$(./postdeployment/runtime-base-url.sh)
cd ../utils/console-client

npm install
npm run login
```

## Query Azure SQL Identity Data

Get the database server full name, like `curity12345.database.windows.net`:

```bash
./postdeployment/dbserver.sh
```

Get a shell to a utility pod that contains database client tools:

```bash
az containerapp exec --name idsvr-dbinit --resource-group curity-rg --command bash
```

Then run database queries to understand identity data:

```bash
/opt/mssql-tools/bin/sqlcmd -S curity12345.database.windows.net -U idsvruser -P Password1 -d idsvr \
    -Q "SELECT * FROM accounts;"
```
