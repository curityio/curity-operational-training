----------------------------------------------------------------------------------------
-- Create a SQL Server maintenace job to clear old identity data from operational tables
-- - https://learn.microsoft.com/en-us/ssms/agent/create-a-job
----------------------------------------------------------------------------------------

--
-- Create the job
--
EXEC sp_add_job @job_name = 'idsvr_maintenance';
GO

--
-- Use the job steps from the System Admin Guide
-- https://curity.io/docs/idsvr/latest/system-admin-guide/data-sources/jdbc.html#table-maintenance-examples-1
--

--
-- Clear expired nonces
--
EXEC sp_add_jobstep
    @job_name = 'idsvr_maintenance',
    @step_name = 'idsvr_clear_nonces',
    @subsystem = 'TSQL',
    @command = 'EXEC idsvr.dbo.sp_clear_nonces;',
    @retry_attempts = 3,
    @retry_interval = 3;
GO

--
-- Clear expired tokens
--
EXEC sp_add_jobstep
    @job_name = 'idsvr_maintenance',
    @step_name = 'idsvr_clear_tokens',
    @subsystem = 'TSQL',
    @command = 'EXEC idsvr.dbo.sp_clear_tokens;',
    @retry_attempts = 3,
    @retry_interval = 3;
GO

--
-- Clear expired sessions
--
EXEC sp_add_jobstep
    @job_name = 'idsvr_maintenance',
    @step_name = 'idsvr_clear_sessions',
    @subsystem = 'TSQL',
    @command = 'EXEC idsvr.dbo.sp_clear_sessions;',
    @retry_attempts = 3,
    @retry_interval = 3;
GO

--
-- Clear expired delegations
--
EXEC sp_add_jobstep
    @job_name = 'idsvr_maintenance',
    @step_name = 'idsvr_clear_delegations',
    @subsystem = 'TSQL',
    @command = 'EXEC idsvr.dbo.sp_clear_delegations;',
    @retry_attempts = 3,
    @retry_interval = 3;
GO

--
-- Add the job to SQL Server
--
EXEC sp_add_jobserver @job_name = 'idsvr_maintenance';
GO

--
-- This example adds a schedule to run maintenance procedures once every 12 hours
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-add-jobschedule-transact-sql
--
EXEC sp_add_jobschedule 
    @job_name = 'idsvr_maintenance',
    @name = 'idsvr_maintenance', 
    @enabled = 1,
    @freq_type = 4,             -- Run on a faily basis
    @freq_interval = 1,         -- This means not used
    @freq_subday_type = 8,      -- Use units of hours - reduce this to minutes for testing
    @freq_subday_interval = 12; -- The number of units before the next execution
GO
