/*
https://dba.stackexchange.com/questions/36522/maxdop-setting-algorithm-for-sql-server
*/

/*
RECOMENDACAO MAXDOP SQL 2016 OU VERSAO ACIMA
*/
/*
***********************************
*/

DECLARE @socket_count int;
DECLARE @cores_per_socket int;
DECLARE @numa_node_count int;
DECLARE @memory_model nvarchar(120);
DECLARE @hyperthread_ratio int;

SELECT @socket_count = dosi.socket_count
       , @cores_per_socket = dosi.cores_per_socket
       , @numa_node_count = dosi.numa_node_count
       , @memory_model = dosi.sql_memory_model_desc
       , @hyperthread_ratio = dosi.hyperthread_ratio
FROM sys.dm_os_sys_info dosi;

SELECT [Socket Count] = @socket_count
       , [Cores Per Socket] = @cores_per_socket
       , [Number of NUMA nodes] = @numa_node_count
       , [Hyperthreading Enabled] = CASE WHEN @hyperthread_ratio > @cores_per_socket THEN 1 ELSE 0 END
       , [Lock Pages in Memory granted?] = CASE WHEN @memory_model = N'CONVENTIONAL' THEN 0 ELSE 1 END;

DECLARE @MAXDOP int = @cores_per_socket;
SET @MAXDOP = @MAXDOP * 0.75;
IF @MAXDOP >= 8 SET @MAXDOP = 8;

SELECT [Recommended MAXDOP setting] = @MAXDOP
       , [Command] = 'EXEC sys.sp_configure N''max degree of parallelism'', ' + CONVERT(nvarchar(10), @MAXDOP) + ';RECONFIGURE;';

/*
***************************************************************************************************************************************
*/

--VERSAO ANTERIOR AO SQL 2016

/* 
   This will recommend a MAXDOP setting appropriate for your machine's NUMA memory
   configuration.  You will need to evaluate this setting in a non-production 
   environment before moving it to production.

   MAXDOP can be configured using:  
   EXEC sp_configure 'max degree of parallelism',X;
   RECONFIGURE

   If this instance is hosting a Sharepoint database, you MUST specify MAXDOP=1 
   (URL wrapped for readability)
   http://blogs.msdn.com/b/rcormier/archive/2012/10/25/
   you-shall-configure-your-maxdop-when-using-sharepoint-2013.aspx

   Biztalk (all versions, including 2010): 
   MAXDOP = 1 is only required on the BizTalk Message Box
   database server(s), and must not be changed; all other servers hosting other 
   BizTalk Server databases may return this value to 0 if set.
   http://support.microsoft.com/kb/899000
*/
SET NOCOUNT ON;

DECLARE @CoreCount int;
SET @CoreCount = 0;
DECLARE @NumaNodes int;

/*  see if xp_cmdshell is enabled, so we can try to use 
    PowerShell to determine the real core count
*/
DECLARE @T TABLE (
    name varchar(255)
    , minimum int
    , maximum int
    , config_value int
    , run_value int
);
INSERT INTO @T 
EXEC sp_configure 'xp_cmdshell';
DECLARE @cmdshellEnabled BIT;
SET @cmdshellEnabled = 0;
SELECT @cmdshellEnabled = 1 
FROM @T
WHERE run_value = 1;
IF @cmdshellEnabled = 1
BEGIN
    CREATE TABLE #cmdshell
    (
        txt VARCHAR(255)
    );
    INSERT INTO #cmdshell (txt)
    EXEC xp_cmdshell 'powershell -OutputFormat Text -NoLogo -Command "& {Get-WmiObject -namespace "root\CIMV2" -class Win32_Processor -Property NumberOfCores} | select NumberOfCores"';
    SELECT @CoreCount = CONVERT(INT, LTRIM(RTRIM(txt)))
    FROM #cmdshell
    WHERE ISNUMERIC(LTRIM(RTRIM(txt)))=1;
    DROP TABLE #cmdshell;
END
IF @CoreCount = 0 
BEGIN
    /* 
        Could not use PowerShell to get the corecount, use SQL Server's 
        unreliable number.  For machines with hyperthreading enabled
        this number is (typically) twice the physical core count.
    */
    SET @CoreCount = (SELECT i.cpu_count from sys.dm_os_sys_info i); 
END

SET @NumaNodes = (
    SELECT MAX(c.memory_node_id) + 1 
    FROM sys.dm_os_memory_clerks c 
    WHERE memory_node_id < 64
    );

DECLARE @MaxDOP int;

/* 3/4 of Total Cores in Machine */
SET @MaxDOP = @CoreCount * 0.75; 

/* if @MaxDOP is greater than the per NUMA node
    Core Count, set @MaxDOP = per NUMA node core count
*/
IF @MaxDOP > (@CoreCount / @NumaNodes) 
    SET @MaxDOP = (@CoreCount / @NumaNodes) * 0.75;

/*
    Reduce @MaxDOP to an even number 
*/
SET @MaxDOP = @MaxDOP - (@MaxDOP % 2);

/* Cap MAXDOP at 8, according to Microsoft */
IF @MaxDOP > 8 SET @MaxDOP = 8;

PRINT 'Suggested MAXDOP = ' + CAST(@MaxDOP as varchar(max));