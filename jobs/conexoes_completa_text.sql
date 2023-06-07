USE [msdb]
GO

/****** Object:  Job [vs_conexoes_completa_text]    Script Date: 06/07/2023 12:26:05 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 06/07/2023 12:26:05 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'vs_conexoes_completa_text', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Nenhuma descri��o dispon�vel.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'REDE-EMPRO\ext_luilima', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [vs_conexoes_completa_text]    Script Date: 06/07/2023 12:26:05 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'vs_conexoes_completa_text', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT INTO vsadmin.dbo.vs_conexoes_completa_text
SELECT DB_NAME(b.dbid) AS [Banco],
		GETDATE(),
       session_id,
       memory_usage AS [qtd p�ginas],
       (memory_usage)*8 AS [total KB],
       host_name,
       login_name,
       original_login_name,
       a.program_name,
       host_process_id,
       b.status,
	   last_request_start_time,
	   last_batch,
       [TEXT]
FROM sys.dm_exec_sessions a
JOIN sys.sysprocesses b ON a.session_id = b.spid CROSS APPLY SYS.DM_EXEC_SQL_TEXT(b.[SQL_HANDLE])AS DEST
WHERE DB_NAME(b.dbid)=''SaudeSJRP''
', 
		@database_name=N'vsadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'vsadmin.dbo.vs_conexoes_completa_text', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20221109, 
		@active_end_date=99991231, 
		@active_start_time=100, 
		@active_end_time=235800, 
		@schedule_uid=N'1259f333-d3d8-4d06-ac46-f6bbeadcd806'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


