/****************************************************************************************
	EXIBE A ÚLTIMA SESSÃO/SESSÕES BLOQUEADORA/BLOQUEDAS REGISTRADO NO BANCO DE DADOS
****************************************************************************************/

use BlockLock

declare @lista varchar(50)
set @lista = (select top 1 Idprocess from ProcessosBloqueados order by IdProcess desc)

select * from ProcessosBloqueados where IdProcess = @lista
select * from ProcessosEmEspera where IdProcess = @lista





/******************************************************************
	EXIBE TODAS AS SESSÕES BLOQUEADOS EM UM INTERVALO DE TEMPO
******************************************************************/

use BlockLock

declare @datainicial as datetime
declare @datafinal as datetime

set @datainicial = '2024-03-20 10:30:00'
set @datafinal = '2024-03-20 10:40:00'

select * from ProcessosBloqueados where Last_Batch > @datainicial and Last_Batch < @datafinal





/********************************************************************
	EXIBE SESSÕES EM ESPERA EM UM DETERMINADO INTERVALO DE TEMPO
********************************************************************/

use BlockLock


declare @datainicial as datetime
declare @datafinal as datetime

set @datainicial = '2024-03-20 10:30:00'
set @datafinal = '2024-03-20 10:40:00'

select *
from ProcessosEmEspera
where
	Program_Name like '%sagrado%'			-- POOL
	and Last_Batch > @datainicial	-- INTERVALO DE TEMPO
	and Last_Batch < @datafinal