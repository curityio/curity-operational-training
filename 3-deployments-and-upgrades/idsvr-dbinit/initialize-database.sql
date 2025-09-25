--
-- You must disable intra-query parallelism for the Curity Identity Server's database
-- - https://learn.microsoft.com/en-us/azure/azure-sql/database/configure-max-degree-of-parallelism
--
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 1;
GO
