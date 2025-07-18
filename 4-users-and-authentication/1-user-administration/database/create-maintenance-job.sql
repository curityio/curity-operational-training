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
    @command = "DELETE FROM idsvr.dbo.nonces WHERE status = 'used';",
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
    @command = "DELETE TOP (10000) FROM idsvr.dbo.sessions WHERE expires < DATEDIFF(s, '1970-01-01 00:00:00', CURRENT_TIMESTAMP);",
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
    @command = "DELETE TOP (10000) FROM idsvr.dbo.tokens WHERE expires < DATEDIFF(s, '1970-01-01 00:00:00', CURRENT_TIMESTAMP);",
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
    @command = "DELETE TOP (10000) FROM idsvr.dbo.delegations WHERE expires < DATEDIFF(s, '1970-01-01 00:00:00', CURRENT_TIMESTAMP);",
    @retry_attempts = 3,
    @retry_interval = 3;
GO

--
-- Add a daily schedule to run the job at midnight every day
--
EXEC sp_add_schedule
    @schedule_name = 'idsvr_maintenance',
    @freq_type = 4,
    @freq_interval = 1;
GO

--
-- Attach the schedule to the job
--
EXEC sp_attach_schedule
    @job_name = 'idsvr_maintenance',
    @schedule_name = 'idsvr_maintenance';
GO

--
-- Add the job to the SQL Server
--
EXEC sp_add_jobserver @job_name = 'idsvr_maintenance';
GO

--
-- To debug and ensure that the job runs, you can add these parameters to sp_add_schedule, to run the job every minute:
--   @freq_subday_type = 4,
--   @freq_subday_interval = 1;
--
-- Then run the following command to view details of recent job executions:
--   msdb.dbo.sp_help_job @Job_name = 'idsvr_maintenance'
