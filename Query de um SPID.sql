DECLARE @handle VARBINARY(64)
SELECT @handle = sql_handle from sys.sysprocesses where spid = 333
SELECT text FROM sys.dm_exec_sql_text(@handle)
