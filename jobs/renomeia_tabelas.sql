USE [msdb]
GO

/****** Object:  Job [vs_renomea_tabelas]    Script Date: 06/07/2023 12:26:41 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 06/07/2023 12:26:41 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'vs_renomea_tabelas', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Nenhuma descrição disponível.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'REDE-EMPRO\ext_luilima', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [vs_renomeia_tabelas]    Script Date: 06/07/2023 12:26:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'vs_renomeia_tabelas', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'------vs_conexoes_completa_text
DECLARE @DATA VARCHAR(MAX)=(SELECT CONVERT (VARCHAR (10),create_date, 112) FROM sys.tables WHERE name=''vs_conexoes_completa_text'')
IF ((@DATA)<(SELECT CONVERT (VARCHAR (10),GETDATE(), 112)))
BEGIN
SET @DATA=''vs_conexoes_completa_text_''+@DATA;
EXEC sp_rename ''vs_conexoes_completa_text'', @DATA;

CREATE TABLE [dbo].[vs_conexoes_completa_text](
	[dbname] [varchar](max) NULL,
	[collectionDate] [datetime] NULL,
	[sessionId] [int] NULL,
	[qtdPages] [bigint] NULL,
	[totalPagesMemKB] [bigint] NULL,
	[hostName] [varchar](max) NULL,
	[loginName] [varchar](max) NULL,
	[originalName] [varchar](max) NULL,
	[programName] [varchar](max) NULL,
	[hostProcessID] [bigint] NULL,
	[status] [varchar](20) NULL,
	[lastRequestStartTime] [datetime] NULL,
	[lastBach] [datetime] NULL,
	[text] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END;
------vs_conexoes_simples
SET @DATA =(SELECT CONVERT (VARCHAR (10),create_date, 112) FROM sys.tables WHERE name=''vs_conexoes_simples'')
IF ((@DATA)<(SELECT CONVERT (VARCHAR (10),GETDATE(), 112)))
BEGIN
SET @DATA=''vs_conexoes_simples_''+@DATA;
EXEC sp_rename ''vs_conexoes_simples'', @DATA;

CREATE TABLE [dbo].[vs_conexoes_simples](
	[collectionDate] [datetime] NULL,
	[dbname] [varchar](100) NULL,
	[conections] [int] NULL,
	[Login] [varchar](100) NULL,
	[program] [varchar](100) NULL,
	[host] [varchar](100) NULL
) ON [PRIMARY]
END;
------vs_contencao_tempdb
SET @DATA =(SELECT CONVERT (VARCHAR (10),create_date, 112) FROM sys.tables WHERE name=''vs_contencao_tempdb'')
IF ((@DATA)<(SELECT CONVERT (VARCHAR (10),GETDATE(), 112)))
BEGIN
SET @DATA=''vs_contencao_tempdb_''+@DATA;
EXEC sp_rename ''vs_contencao_tempdb'', @DATA;

CREATE TABLE [dbo].[vs_contencao_tempdb](
	[collectionDate] [datetime] NULL,
	[waitResouce] [varchar](max) NULL,
	[waitType] [varchar](max) NULL,
	[lastWaitType] [varchar](30) NULL,
	[status] [varchar](20) NULL,
	[quantity] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END;
------vs_top_cpu_consumidores_text
SET @DATA =(SELECT CONVERT (VARCHAR (10),create_date, 112) FROM sys.tables WHERE name=''vs_top_cpu_consumidores_text'')
IF ((@DATA)<(SELECT CONVERT (VARCHAR (10),GETDATE(), 112)))
BEGIN
SET @DATA=''vs_top_cpu_consumidores_text_''+@DATA;
EXEC sp_rename ''vs_top_cpu_consumidores_text'', @DATA;

CREATE TABLE [dbo].[vs_top_cpu_consumidores_text](
	[collectionDate] [datetime] NULL,
	[dbname] [varchar](max) NULL,
	[shortQueryText] [text] NULL,
	[executionCount] [bigint] NULL,
	[totalWorkerTime] [bigint] NULL,
	[minWorkerTime] [bigint] NULL,
	[avgWorkerTime] [bigint] NULL,
	[maxWorkerTime] [bigint] NULL,
	[minElapsedTime] [bigint] NULL,
	[avgElapsedTime] [bigint] NULL,
	[maxElapsedTime] [bigint] NULL,
	[minLogicalTime] [bigint] NULL,
	[avgLogicalTime] [bigint] NULL,
	[maxLogicalTime] [bigint] NULL,
	[creationTime] [datetime] NULL,
	[queryText] [text] NULL,
	[queryPan] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END;
------vs_info_geral_01
SET @DATA =(SELECT CONVERT (VARCHAR (10),create_date, 112) FROM sys.tables WHERE name=''vs_info_geral_01'')
IF ((@DATA)<(SELECT CONVERT (VARCHAR (10),GETDATE(), 112)))
BEGIN
SET @DATA=''vs_info_geral_01_''+@DATA;
EXEC sp_rename ''vs_info_geral_01'', @DATA;

CREATE TABLE [dbo].[vs_info_geral_01](
	[collectionDate] [datetime] NULL,
	[dbname] [varchar](max) NULL,
	[sessionId] [int] NULL,
	[programName] [varchar](max) NULL,
	[hostname] [varchar](max) NULL,
	[clientNetAddress] [varchar](15) NULL,
	[clientTcpPort] [bigint] NULL,
	[localNetAddress] [varchar](15) NULL,
	[localTcpPort] [bigint] NULL,
	[netPacketSize] [bigint] NULL,
	[duration] [varchar](max) NULL,
	[command] [varchar](20) NULL,
	[status] [varchar](20) NULL,
	[loginName] [varchar](max) NULL,
	[waitInfo] [varchar](max) NULL,
	[cpu] [bigint] NULL,
	[tempdbAllocations] [bigint] NULL,
	[tempdbCurrent] [bigint] NULL,
	[reads] [bigint] NULL,
	[writes] [bigint] NULL,
	[physicalReads] [bigint] NULL,
	[usedMemory] [bigint] NULL,
	[blockingSessionId] [int] NULL,
	[blockedSessionCount] [int] NULL,
	[deadlockPriority] [varchar](10) NULL,
	[row_Count] [bigint] NULL,
	[openTransactionCount] [int] NULL,
	[transactionIsolationLevel] [int] NULL,
	[transactionIsolationLevelDesc] [varchar](max) NULL,
	[startTime] [datetime] NULL,
	[loginTime] [datetime] NULL,
	[requesTd] [int] NULL,
	[sqlText] [xml] NULL,
	[sqlCommand] [xml] NULL,
	[queryPlan] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END;
------vs_lock_tables
SET @DATA =(SELECT CONVERT (VARCHAR (10),create_date, 112) FROM sys.tables WHERE name=''vs_lock_tables'')
IF ((@DATA)<(SELECT CONVERT (VARCHAR (10),GETDATE(), 112)))
BEGIN
SET @DATA=''vs_lock_tables_''+@DATA;
EXEC sp_rename ''vs_lock_tables'', @DATA;

CREATE TABLE [dbo].[vs_lock_tables](
	[lockObjectName] [varchar](max) NULL,
	[lockObjectId] [bigint] NULL,
	[spid] int,
	[dbname] [varchar](9) NULL,
	[collectionDate] [datetime] NULL,
	[lockResource] [varchar](10) NULL,
	[lockType] [varchar](20) NULL,
	[count] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END;
', 
		@database_name=N'vsadmin', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'vs_renomeia_tabelas', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20221118, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'312d9b04-fe23-460d-a0a9-28840f918a30'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO
