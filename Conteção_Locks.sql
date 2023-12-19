DECLARE @data AS DATE
SET @data = GETDATE()

SELECT *
FROM   mirror.DATABASES.LockTablesContencao
WHERE  db_name = 'SaudeSJRP'
	  AND collection_date > @data
	  --AND host_name = 'EMPRO17025'
	  --AND program_name LIKE 'UBSF'
	  --AND (wait_info LIKE '%U' OR wait_info LIKE '%X')
	  --AND collection_date > '2023-10-06 11:45'
	  --AND session_id = 234
ORDER BY 1

--kill 486