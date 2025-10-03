IF DATABASE_PRINCIPAL_ID('idsvruser') IS NULL
    CREATE USER idsvruser FOR LOGIN idsvruser;
GO

EXEC sp_addrolemember 'db_datareader', 'idsvruser';
GO

EXEC sp_addrolemember 'db_datawriter', 'idsvruser';
GO
