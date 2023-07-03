DECLARE @data AS DATE
SET @data = GETDATE()

SELECT *
FROM mirror.DATABASES.LockTablesContencao
WHERE collection_date > @data
	AND db_name = 'SaudeSJRP'
	--AND host_name = 'EMPRO17025'
	AND program_name LIKE 'UBS%'
ORDER BY 1