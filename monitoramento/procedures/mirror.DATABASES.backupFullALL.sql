USE [mirror]
GO

/****** Object:  StoredProcedure [DATABASES].[backupFullALL]    Script Date: 13/06/2023 12:47:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [DATABASES].[backupFullALL]
AS
BEGIN
	DECLARE @name VARCHAR(50) -- nome da base de dados
	DECLARE @path VARCHAR(256) -- caminho para os arquivos do backup
	DECLARE @fileName VARCHAR(256) -- nome do arquivo de backup
	DECLARE @bkpname VARCHAR(256) -- descrição do backup
	
	-- especifica os diretórios para o backup
	SET @path = 'B:\Backup\'
	
	DECLARE db_cursor CURSOR READ_ONLY FOR
		SELECT name
		FROM master.sys.databases
		WHERE name NOT IN ('master', 'model', 'tempdb', 'vsadmin')  -- exclui essas bases de dados
				AND state = 0 -- base de dados está online
				AND is_in_standby = 0 -- database is not read only for log shipping
		
		OPEN db_cursor 
				FETCH NEXT FROM db_cursor INTO @name 
				WHILE @@FETCH_STATUS = 0 
				BEGIN 
					SET @fileName = @path + @name + '.bak'
					SET @bkpname = @name + '-Full Database Backup'
					
					BACKUP DATABASE @name TO DISK = @fileName WITH NOFORMAT, INIT, NAME = @bkpname, SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10
				
					FETCH NEXT FROM db_cursor INTO @name 
				END 
		CLOSE db_cursor 
	DEALLOCATE db_cursor
	
	EXEC DATABASES.backupLogALL
END
GO


