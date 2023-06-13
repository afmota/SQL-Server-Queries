USE [msdb]
GO

/****** Object:  Job [monit.top_cpu_consumidores_text]    Script Date: 07/06/2023 13:05:34 ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'f1db1a7b-81b6-42b9-8424-99cc1637f14b', @delete_unused_schedule=1
GO

/****** Object:  Job [monit.top_cpu_consumidores_text]    Script Date: 07/06/2023 13:05:34 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 07/06/2023 13:05:34 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'monit.top_cpu_consumidores_text', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Nenhuma descri��o dispon�vel.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'REDE-EMPRO\amotaadm', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [monit.top_cpu_consumidores_text]    Script Date: 07/06/2023 13:05:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'monit.top_cpu_consumidores_text', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'	INSERT INTO locksbd.dbo.top_cpu_consumidores_text
						SELECT TOP(50) GETDATE(),
						               DB_NAME(t.[dbid]) AS [Database Name],
						               REPLACE(REPLACE(LEFT(t.[text], 255), CHAR(10), ''''), CHAR(13), '''') AS [Short Query Text],
						               qs.execution_count AS [ExecutionCount],
						               qs.total_worker_time AS [Total Worker Time],
						               qs.min_worker_time AS [Min Worker Time],
						               qs.total_worker_time/qs.execution_count AS [Avg Worker Time],
						               qs.max_worker_time AS [Max Worker Time],
						               qs.min_elapsed_time AS [Min Elapsed Time],
						               qs.total_elapsed_time/qs.execution_count AS [Avg Elapsed Time],
						               qs.max_elapsed_time AS [Max Elapsed Time],
						               qs.min_logical_reads AS [Min Logical Reads],
						               qs.total_logical_reads/qs.execution_count AS [Avg Logical Reads],
						               qs.max_logical_reads AS [Max Logical Reads],
						               qs.creation_time AS [Creation Time],
						               t.[text] AS [Query Text],
						               qp.query_plan AS [Query Plan] -- uncomment out these columns if not copying results to Excel
						FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK) CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
						WHERE DB_NAME(t.[dbid])=''SaudeSJRP''
				', 
		@database_name=N'locksbd', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'locksbd.dbo.top_cpu_consumidores_text', 
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
		@schedule_uid=N'73de6fa6-4ecb-437a-8b27-2660b0f8801b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO
