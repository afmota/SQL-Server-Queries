DECLARE @data AS DATE
SET @data = GETDATE()

SELECT *
FROM mirror.DATABASES.LockTablesContencao
WHERE collection_date > @data
	AND db_name = 'SaudeSJRP'
