USE master;
GO

IF SUSER_ID('idsvruser') IS NULL
CREATE LOGIN idsvruser WITH PASSWORD = 'Password1';
GO

IF DB_ID('idsvr') IS NULL
CREATE DATABASE idsvr;
GO

USE idsvr;
GO

IF DATABASE_PRINCIPAL_ID('idsvruser') IS NULL
CREATE USER idsvruser FOR LOGIN idsvruser;
GO

EXEC sp_addrolemember 'db_datareader', 'idsvruser';
GO

EXEC sp_addrolemember 'db_datawriter', 'idsvruser';
GO
