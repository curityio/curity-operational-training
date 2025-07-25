# Use Data Sources

These resources accompany the lessons from the [Data Sources](https://curity.io/training/data-sources) course.\
Extends the existing deployment to use durable storage for identity data.

## Deploy the System

The deployment uses a local Docker Compose environment and a Microsoft SQL Server database.\
Copy a `license.json` file to this folder and run `./go.sh` to perform the deployment.

## Connect to the Database

You can query identity data by first getting a shell to the deployed container for the database server:

```bash
CONTAINER_ID=$(docker ps | grep curity-data | awk '{print $1}')
docker exec -it "$CONTAINER_ID" bash
```

You can then get an interactive shell with which to run queries:

```bash
/opt/mssql-tools18/bin/sqlcmd -d idsvr -U idsvruser -P Password1 -d idsvr -C
```

## Run Queries

You can then get a list of tables in the schema:

```sql
select name from sysobjects where type='U';
GO
```

Or query user accounts:

```sql
select * from accounts;
GO
```

Or query operational data:

```sql
select * from delegations;
GO
```

## Redeployments and Existing Data

By default, redeployments clear all existing SQL data for the Curity Identity Server.\
The deployment shares a data volume locally and clears it.\
To maintain existing SQL data, comment out the above statements before running the redeployment.

```bash
rm -rf data
mkdir data
```
