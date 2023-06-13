USE [msdb]
GO

/****** Object:  Job [Locks.RegistraLocks]    Script Date: 13/06/2023 12:30:58 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 13/06/2023 12:30:59 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Locks.RegistraLocks', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'REDE-EMPRO\amota', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Locks]    Script Date: 13/06/2023 12:30:59 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Locks', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT INTO mirror.DATABASES.LocksSaude
	SELECT TL.resource_type AS ResType
	      ,TL.resource_description AS ResDescr
	      ,TL.request_mode AS ReqMode
	      ,TL.request_type AS ReqType
	      ,TL.request_status AS ReqStatus
	      ,TL.request_owner_type AS ReqOwnerType
	      ,TAT.[name] AS TransName
	      ,TAT.transaction_begin_time AS TransBegin
	      ,DATEDIFF(ss, TAT.transaction_begin_time, GETDATE()) AS TransDura
	      ,ES.session_id AS S_Id
	      ,ES.login_name AS LoginName
	      ,COALESCE(OBJ.name, PAROBJ.name) AS ObjectName
	      ,PARIDX.name AS IndexName
	      ,ES.host_name AS HostName
	      ,ES.program_name AS ProgramName
	      ,GETDATE()
	FROM sys.dm_tran_locks AS TL
	     INNER JOIN sys.dm_exec_sessions AS ES
	         ON TL.request_session_id = ES.session_id
	     LEFT JOIN sys.dm_tran_active_transactions AS TAT
	         ON TL.request_owner_id = TAT.transaction_id
	            AND TL.request_owner_type = ''TRANSACTION''
	     LEFT JOIN sys.objects AS OBJ
	         ON TL.resource_associated_entity_id = OBJ.object_id
	            AND TL.resource_type = ''OBJECT''
	     LEFT JOIN sys.partitions AS PAR
	         ON TL.resource_associated_entity_id = PAR.hobt_id
	            AND TL.resource_type IN (''PAGE'', ''KEY'', ''RID'', ''HOBT'')
	     LEFT JOIN sys.objects AS PAROBJ
	         ON PAR.object_id = PAROBJ.object_id
	     LEFT JOIN sys.indexes AS PARIDX
	         ON PAR.object_id = PARIDX.object_id
	            AND PAR.index_id = PARIDX.index_id
	WHERE TL.resource_database_id  = DB_ID()
	      AND ES.session_id <> @@Spid -- Exclude "my" session
	      -- optional filter 
	      AND TL.request_mode <> ''S'' -- Exclude simple shared locks
	ORDER BY TL.resource_type
	        ,TL.request_mode
	        ,TL.request_type
	        ,TL.request_status
	        ,ObjectName
	        ,ES.login_name;', 
		@database_name=N'SaudeSJRP', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Execução', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=2, 
		@freq_subday_interval=15, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20221118, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=180000, 
		@schedule_uid=N'7a925707-5c3f-44ab-89f3-081b3df5a1ef'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


