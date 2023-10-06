DECLARE @data AS DATE
SET @data = GETDATE()

SELECT *
FROM   mirror.DATABASES.LockTablesContencao
WHERE  db_name = 'SaudeSJRP'
	  --collection_date > @data
	  --AND host_name = 'EMPRO17025'
	  --AND program_name LIKE 'UBSF'
	  --AND (wait_info LIKE '%U' OR wait_info LIKE '%X')
	  AND collection_date > '2023-10-03 16:30'
ORDER BY 1