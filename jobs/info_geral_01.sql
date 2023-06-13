USE [msdb]
GO

/****** Object:  Job [vs_info_geral_01]    Script Date: 06/07/2023 12:26:22 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 06/07/2023 12:26:22 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'vs_info_geral_01', 
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
/****** Object:  Step [vs_info_geral_01]    Script Date: 06/07/2023 12:26:22 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'vs_info_geral_01', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'INSERT INTO mirror.dbo.vs_info_geral_01
SELECT
	GETDATE(),
	COALESCE(DB_NAME(CAST(B.database_id AS VARCHAR)), ''master'') AS [database_name],	
	A.session_id AS session_id,  
    A.[program_name],
    A.[host_name],
    C.client_net_address,
    C.client_tcp_port,
    C.local_net_address,
    C.local_tcp_port, 
    C.net_packet_size, 
    RIGHT(''00'' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 86400 AS VARCHAR), 2) + '' '' + 
    RIGHT(''00'' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 3600) % 24 AS VARCHAR), 2) + '':'' + 
    RIGHT(''00'' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 60) % 60 AS VARCHAR), 2) + '':'' + 
    RIGHT(''00'' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) % 60 AS VARCHAR), 2) + ''.'' + 
    RIGHT(''000'' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) AS VARCHAR), 3) 
    AS Duration,    
    B.command,
    A.[status],    
    A.login_name,
    ''('' + CAST(COALESCE(E.wait_duration_ms, B.wait_time) AS VARCHAR(20)) + ''ms)'' + COALESCE(E.wait_type, B.wait_type) + COALESCE((CASE 
        WHEN COALESCE(E.wait_type, B.wait_type) LIKE ''PAGEIOLATCH%'' THEN '':'' + DB_NAME(LEFT(E.resource_description, CHARINDEX('':'', E.resource_description) - 1)) + '':'' + SUBSTRING(E.resource_description, CHARINDEX('':'', E.resource_description) + 1, 999)
        WHEN COALESCE(E.wait_type, B.wait_type) = ''OLEDB'' THEN ''['' + REPLACE(REPLACE(E.resource_description, '' (SPID='', '':''), '')'', '''') + '']''
        ELSE ''''
    END), '''') AS wait_info,
    COALESCE(B.cpu_time, 0) AS CPU,
    COALESCE(F.tempdb_allocations, 0) AS tempdb_allocations,
    COALESCE((CASE WHEN F.tempdb_allocations > F.tempdb_current THEN F.tempdb_allocations - F.tempdb_current ELSE 0 END), 0) AS tempdb_current,
    COALESCE(B.logical_reads, 0) AS reads,
    COALESCE(B.writes, 0) AS writes,
    COALESCE(B.reads, 0) AS physical_reads,
    COALESCE(B.granted_query_memory, 0) AS used_memory,
    NULLIF(B.blocking_session_id, 0) AS blocking_session_id,
    COALESCE(G.blocked_session_count, 0) AS blocked_session_count,    
    (CASE 
        WHEN B.[deadlock_priority] <= -5 THEN ''Low''
        WHEN B.[deadlock_priority] > -5 AND B.[deadlock_priority] < 5 AND B.[deadlock_priority] < 5 THEN ''Normal''
        WHEN B.[deadlock_priority] >= 5 THEN ''High''
    END) + '' ('' + CAST(B.[deadlock_priority] AS VARCHAR(3)) + '')'' AS [deadlock_priority],
    B.row_count,
    B.open_transaction_count,
    B.transaction_isolation_level,
    (CASE B.transaction_isolation_level
        WHEN 0 THEN ''Unspecified'' 
        WHEN 1 THEN ''ReadUncommitted'' 
        WHEN 2 THEN ''ReadCommitted'' 
        WHEN 3 THEN ''Repeatable'' 
        WHEN 4 THEN ''Serializable'' 
        WHEN 5 THEN ''Snapshot''
    END) AS transaction_isolation_level_DESC,    
    --NULLIF(B.percent_complete, 0) AS percent_complete,    
    --H.[name] AS resource_governor_group,
    COALESCE(B.start_time, A.last_request_end_time) AS start_time,
    A.login_time,
    COALESCE(B.request_id, 0) AS request_id,
    CAST(''<?query --'' + CHAR(10) + (
        SELECT TOP 1 SUBSTRING(X.[text], B.statement_start_offset / 2 + 1, ((CASE
                                                                          WHEN B.statement_end_offset = -1 THEN (LEN(CONVERT(NVARCHAR(MAX), X.[text])) * 2)
                                                                          ELSE B.statement_end_offset
                                                                      END
                                                                     ) - B.statement_start_offset
                                                                    ) / 2 + 1
                     )
    ) + CHAR(10) + ''--?>'' AS XML) AS sql_text,
    CAST(''<?query --'' + CHAR(10) + X.[text] + CHAR(10) + ''--?>'' AS XML) AS sql_command,
    W.query_plan
FROM
    master.sys.dm_exec_sessions AS A WITH (NOLOCK)
    LEFT JOIN sys.dm_exec_requests AS B WITH (NOLOCK) ON A.session_id = B.session_id
    JOIN sys.dm_exec_connections AS C WITH (NOLOCK) ON A.session_id = C.session_id AND A.endpoint_id = C.endpoint_id
    LEFT JOIN (
        SELECT
            session_id, 
            wait_type,
            wait_duration_ms,
            resource_description,
            ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY (CASE WHEN wait_type LIKE ''PAGEIO%'' THEN 0 ELSE 1 END), wait_duration_ms) AS Ranking
        FROM 
            sys.dm_os_waiting_tasks
    ) E ON A.session_id = E.session_id AND E.Ranking = 1
    LEFT JOIN (
        SELECT
            session_id,
            request_id,
            SUM(internal_objects_alloc_page_count + user_objects_alloc_page_count) AS tempdb_allocations,
            SUM(internal_objects_dealloc_page_count + user_objects_dealloc_page_count) AS tempdb_current
        FROM
            sys.dm_db_task_space_usage
        GROUP BY
            session_id,
            request_id
    ) F ON B.session_id = F.session_id AND B.request_id = F.request_id
    LEFT JOIN (
        SELECT 
            blocking_session_id,
            COUNT(*) AS blocked_session_count
        FROM 
            sys.dm_exec_requests
        WHERE 
            blocking_session_id != 0
        GROUP BY
            blocking_session_id
    ) G ON A.session_id = G.blocking_session_id
    OUTER APPLY sys.dm_exec_sql_text(COALESCE(B.[sql_handle], C.most_recent_sql_handle)) AS X
    OUTER APPLY sys.dm_exec_query_plan(B.[plan_handle]) AS W
    LEFT JOIN sys.dm_resource_governor_workload_groups H ON A.group_id = H.group_id
WHERE
    A.session_id > 50
    AND A.session_id <> @@SPID
    AND command IS NOT NULL
    AND login_name NOT IN (''REDE-EMPRO\amotaadm'',''REDE-EMPRO\amota'')
    

', 
		@database_name=N'mirror', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'vs_info_geral_01', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=2, 
		@freq_subday_interval=30, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20221110, 
		@active_end_date=99991231, 
		@active_start_time=100, 
		@active_end_time=235800, 
		@schedule_uid=N'56b88767-c6fe-479e-a8a4-e97c4809059c'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


