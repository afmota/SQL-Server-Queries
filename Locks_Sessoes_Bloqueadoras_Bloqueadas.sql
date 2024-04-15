select 'Block' Tipo, sp.Spid, sp.Blocked, sp.Open_Tran, sp.Status, sp.waittime/1000 [waittime/seg],
        sp.Last_Batch, sp.HostName, sp.NT_UserName, sp.[Program_Name],    
       (SELECT [text] FROM sys.dm_exec_sql_text(sp.sql_handle)) Command,
        db_name(dbid) DBName, sp.Loginame, sp.WaitResource, 
        sp.hostprocess, sysjobs.name as Job_Name
FROM    sys.sysprocesses sp
LEFT JOIN msdb..sysjobs WITH (NOLOCK)
ON  job_id LIKE '%' + SUBSTRING(PROGRAM_NAME, 55, 7) + '%'
AND  PROGRAM_NAME LIKE  'SQLAgent%'
AND  PROGRAM_NAME NOT LIKE 'SQLAgent - Job Manager%'
AND  PROGRAM_NAME NOT LIKE 'SQLAgent - Alert Engine%'
AND  PROGRAM_NAME NOT LIKE 'SQLAgent - Generic Refresher%'
AND  PROGRAM_NAME NOT LIKE 'SQLAgent - Job invocation engine%'
where spid in (select blocked from sys.sysprocesses where blocked > 0) and blocked = 0


select 'Wait' Tipo, sp.Spid, sp.Blocked, sp.Open_Tran, sp.Status, sp.waittime/1000 [waittime/seg],
        sp.Last_Batch, sp.HostName, sp.NT_UserName, sp.[Program_Name],    
       (SELECT [text] FROM sys.dm_exec_sql_text(sp.sql_handle)) Command,
        db_name(dbid) DBName, sp.Loginame, sp.WaitResource, 
        sp.hostprocess, sysjobs.name as Job_Name
FROM    sys.sysprocesses sp
LEFT JOIN msdb..sysjobs WITH (NOLOCK)
ON  job_id LIKE '%' + SUBSTRING(PROGRAM_NAME, 55, 7) + '%'
AND   PROGRAM_NAME LIKE  'SQLAgent%'
AND  PROGRAM_NAME NOT LIKE 'SQLAgent - Job Manager%'
AND  PROGRAM_NAME NOT LIKE 'SQLAgent - Alert Engine%'
AND  PROGRAM_NAME NOT LIKE 'SQLAgent - Generic Refresher%'
AND  PROGRAM_NAME NOT LIKE 'SQLAgent - Job invocation engine%'
where spid in (select spid from sys.sysprocesses where blocked > 0)