USE master;
GO

-- 
-- Create the login
--
IF SUSER_ID('idsvruser') IS NULL
    CREATE LOGIN idsvruser WITH PASSWORD = 'Password1';
GO

-- 
-- Create the database
-- A real database deployment should set sufficient data and log sizes
-- You should also configure backup related settings
-- https://curity.io/docs/idsvr/latest/system-admin-guide/system-requirements.html#database
--
IF DB_ID('idsvr') IS NULL
    CREATE DATABASE idsvr;
GO

USE idsvr;
GO

--
-- You must disable intra-query parallelism for the Curity Identity Server's database
-- SELECT value FROM sys.database_scoped_configurations WHERE name = 'MAXDOP';
--
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 1;
GO

--
-- Create a low privilege daabase user
--
IF DATABASE_PRINCIPAL_ID('idsvruser') IS NULL
    CREATE USER idsvruser FOR LOGIN idsvruser;
GO

--
-- The database user must have read and write permissions to the identity data tables
--
EXEC sp_addrolemember 'db_datareader', 'idsvruser';
GO

EXEC sp_addrolemember 'db_datawriter', 'idsvruser';
GO
