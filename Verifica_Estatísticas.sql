-- VERIFICAR ESTATISTICAS QUE PRECISAM ATUALIZAR (DIAS SEM ATUALIZAR)

USE SaudeSJRP
go
SELECT DISTINCT
       TB.object_id
       ,TB.NAME
       ,ST.NAME
         ,(DATEDIFF(d,STATS_DATE(IX.OBJECT_ID, index_id) ,getdate()) ) AS 'DiasDesatualizados'
       ,'UPDATE STATISTICS '+TB.NAME+' '+ST.NAME+' WITH FULLSCAN;' AS 'ComandoParaAtualizarStats'
  FROM sys.tables TB
 INNER JOIN sys.stats ST ON TB.object_id = ST.object_id
 INNER JOIN sys.indexes IX ON TB.object_id = IX.object_id
-- ORDER BY TB.name, st.name
ORDER BY 4 DESC