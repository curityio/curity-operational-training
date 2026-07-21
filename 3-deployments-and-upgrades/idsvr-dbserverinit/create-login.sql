IF SUSER_ID('idsvruser') IS NULL
    CREATE LOGIN idsvruser WITH PASSWORD = 'Password1';
GO
