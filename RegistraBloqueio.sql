USE BlockLock

DECLARE @IdProcess VARCHAR(50);

-- Obter os componentes da data e hora, incluindo milissegundos
DECLARE @year VARCHAR(4) = CONVERT(VARCHAR(4), YEAR(GETDATE()));
DECLARE @month VARCHAR(2) = RIGHT('00' + CONVERT(VARCHAR(2), MONTH(GETDATE())), 2);
DECLARE @day VARCHAR(2) = RIGHT('00' + CONVERT(VARCHAR(2), DAY(GETDATE())), 2);
DECLARE @hour VARCHAR(2) = RIGHT('00' + CONVERT(VARCHAR(2), DATEPART(HOUR, GETDATE())), 2);
DECLARE @minute VARCHAR(2) = RIGHT('00' + CONVERT(VARCHAR(2), DATEPART(MINUTE, GETDATE())), 2);
DECLARE @second VARCHAR(2) = RIGHT('00' + CONVERT(VARCHAR(2), DATEPART(SECOND, GETDATE())), 2);
DECLARE @millisecond VARCHAR(3) = RIGHT('000' + CONVERT(VARCHAR(3), DATEPART(MILLISECOND, GETDATE())), 3);

-- Concatenar os componentes em um único valor
SET @IdProcess = @year + @month + @day + @hour + @minute + @second + @millisecond;

INSERT INTO mirror.DATABASES.ProcessosBloqueados (IdProcess
	, Tipo
	, Spid
	, Blocked
	, Open_Tran
	, Status
	, WaitTimeSeg
	, Last_Batch
	, HostName
	, NT_UserName
	, Program_Name
	, Command
	, DBName
	, Loginame
	, WaitResource
	, HostProcess
	, Job_Name)
select @IdProcess, 'Block' Tipo, sp.Spid, sp.Blocked, sp.Open_Tran, sp.Status, sp.waittime/1000 [waittime/seg],
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

INSERT INTO mirror.DATABASES.ProcessosEmEspera (IdProcess
	, Tipo
	, Spid
	, Blocked
	, Open_Tran
	, Status
	, WaitTimeSeg
	, Last_Batch
	, HostName
	, NT_UserName
	, Program_Name
	, Command
	, DBName
	, Loginame
	, WaitResource
	, HostProcess
	, Job_Name)
select @IdProcess, 'Wait' Tipo, sp.Spid, sp.Blocked, sp.Open_Tran, sp.Status, sp.waittime/1000 [waittime/seg],
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

SELECT *
FROM mirror.DATABASES.ProcessosBloqueados AS pb
WHERE pb.IdProcess = @IdProcess

SELECT IdProcess, Tipo, Spid, Blocked, Open_Tran, Status, WaitTimeSeg, Last_Batch, HostName, NT_UserName, Program_Name, Command, DBName, Loginame, WaitResource, HostProcess, Job_Name
FROM mirror.DATABASES.ProcessosEmEspera AS pe
WHERE pe.IdProcess = @IdProcess