DECLARE @data AS DATE
SET @data = GETDATE()

SELECT *
FROM mirror.DATABASES.LockTablesContencao
WHERE collection_date > @data
	AND db_name = 'SaudeSJRP'
	--AND host_name = 'EMPRO17025'
	--AND program_name LIKE 'UBSF%'
	--AND (wait_info LIKE '%U' OR wait_info LIKE '%X')
	--AND collection_date > '2023-07-04 07:00'
ORDER BY 1