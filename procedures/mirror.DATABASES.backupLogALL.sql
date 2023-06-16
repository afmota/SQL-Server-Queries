USE [mirror]
GO

/****** Object:  StoredProcedure [DATABASES].[backupLogALL]    Script Date: 13/06/2023 12:48:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [DATABASES].[backupLogALL]
AS
BEGIN
	DECLARE @name VARCHAR(50) -- nome da base de dados
	DECLARE @path VARCHAR(256) -- caminho para os arquivos dos logs de transação
	DECLARE @fileName VARCHAR(256) -- nome do arquivo de log de transação
	DECLARE @logname VARCHAR(256) -- descrição dOko backup
	DECLARE @horasistema AS TIME 
	SET @horasistema = CONVERT(TIME, GETDATE())
	
	-- specify database backup directory
	SET @path = 'B:\Backup\'
	
	DECLARE db_cursor CURSOR READ_ONLY FOR
		SELECT name
		FROM master.sys.databases
		WHERE name NOT IN ('master', 'model', 'tempdb', 'SaudeSJRPHist', 'vsadmin')  -- exclui essas bases de dados
				AND state = 0 -- base de dados está online
				AND is_in_standby = 0 -- database is not read only for log shipping
		
		OPEN db_cursor 
				FETCH NEXT FROM db_cursor INTO @name 
				WHILE @@FETCH_STATUS = 0 
				BEGIN 
					SET @fileName = @path + @name + '.trn'
					SET @logname = @name + '-Transaction Log  Backup'
					
					IF @horasistema > '00:00:00.000' AND @horasistema < '03:15:00.000'
					BEGIN
						BACKUP LOG @name TO DISK = @fileName WITH NOFORMAT, INIT, NAME = @logname, SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10
						DBCC SHRINKFILE (@filename , 1)
					END
					ELSE
						BACKUP LOG @name TO DISK = @fileName WITH NOFORMAT, NOINIT, NAME = @logname, SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10
					FETCH NEXT FROM db_cursor INTO @name
				END 
		CLOSE db_cursor 
	DEALLOCATE db_cursor
END
GO


