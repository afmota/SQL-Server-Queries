USE mirror

DECLARE @data_filtro AS DATETIME
SET @data_filtro = '2023-07-13 07:00:00.000'

SELECT SPID
	, TextData
	, RIGHT('00' + CAST(((Duration / 1000000) / 60) / 60 AS VARCHAR(2)),2) + ':'
		+ RIGHT('00' + CAST(((Duration / 1000000) / 60) % 60 AS VARCHAR(2)),2) + ':'
		+ RIGHT('00' + CAST((Duration / 1000000) % 60 AS VARCHAR(2)),2) AS Duration
	, StartTime
	, EndTime
	, ApplicationName
	, CPU
	, Reads
	, Writes
FROM mirror.DATABASES.DailyTrace_RT
WHERE StartTime > @data_filtro
	--AND LoginName <> 'REDE-EMPRO\sqlserveradm'
	--AND LoginName <> 'etl_dw'
	--AND ApplicationName NOT LIKE 'SQLAgent%'
	--AND HostName LIKE 'EMPRO-%'
	--AND SPID = 587
	AND ApplicationName LIKE 'UBSf%'
	--AND TextData LIKE '%USUARIO_SAUDE int,%'
--ORDER BY Duration DESC
--ORDER BY CPU DESC
--ORDER BY Duration DESC
--ORDER BY StartTime
--ORDER BY EndTime DESC
