# Use Data Sources

These resources accompany the lessons from the [Data Sources](https://curity.io/training/data-sources) course.\
You learn how to extend early deployments to use durable storage for identity data.

## Deployment Steps

Read the [Local Computer Setup](../SETUP.md) document to learn how to deploy and use the system.

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

Query information about user accounts:

```sql
select * from accounts;
GO
```

Or query information about operational data:

```sql
select * from delegations;
GO
```

## Redeployments and Existing Data

By default, redeployments clear all existing SQL data for the Curity Identity Server.\
The deployment shares a data volume locally and clears it.\
To maintain existing SQL data, comment out the following statements before running the redeployment.

```bash
rm -rf data
mkdir data
```

## Database Administration

You must also do some database administration work for your data sources.\
You then get confidence that the system runs reliably under load.\
The example deployment demonstrates some of the approaches.

## Maintenance Procedures

Part of the database administration work is to implement mainteance procedures.\
This example deployment includes some example scripts that you can use as a reference.

```sql
/opt/mssql-tools18/bin/sqlcmd -U idsvruser -P Password1 -d idsvr -C -Q 'EXEC sp_clear_nonces'
/opt/mssql-tools18/bin/sqlcmd -U idsvruser -P Password1 -d idsvr -C -Q 'EXEC sp_clear_tokens'
/opt/mssql-tools18/bin/sqlcmd -U idsvruser -P Password1 -d idsvr -C -Q 'EXEC sp_clear_sessions'
/opt/mssql-tools18/bin/sqlcmd -U idsvruser -P Password1 -d idsvr -C -Q 'EXEC sp_clear_delegations'
```

The maintenance procedures are run every 12 hours by the Microsoft SQL Server Agent process.\
The following command shows details of scheduled job executions:

```bash
cat /var/opt/mssql/log/sqlagent.out
```
