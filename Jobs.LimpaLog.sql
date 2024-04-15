DECLARE @limit_date AS DATETIME
SET @limit_date = GETDATE() - 1

EXEC msdb.dbo.sp_purge_jobhistory
	@job_name = 'Infra.Locks.LockTablesContencao',
	@oldest_date = @limit_date;

EXEC msdb.dbo.sp_purge_jobhistory
	@job_name = 'Infra.Locks.RegistraLocks',
	@oldest_date = @limit_date;
