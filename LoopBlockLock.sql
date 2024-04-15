DECLARE @TEMPO int
SET @TEMPO = 1

WHILE @TEMPO = 1
BEGIN
    -- Verifica se o horário atual está entre 07h00 e 18h00
    IF (DATEPART(HOUR, GETDATE()) >= 8 AND DATEPART(HOUR, GETDATE()) < 18)
    BEGIN
        -- Verifica se há locks ativos e se não houve registro recente
        IF EXISTS (
            SELECT 1
            FROM sys.dm_tran_locks
            WHERE request_session_id > 50
        ) AND NOT EXISTS (
            SELECT 1
            FROM RegistraLocks
            WHERE LockTime > DATEADD(SECOND, -5, GETDATE())
        )
        BEGIN
            EXEC spGravarRegistro;
            INSERT INTO RegistraLocks (ObjectName, LockTime)
            VALUES ('spGravarRegistro', GETDATE());
        END
    END
    ELSE
    BEGIN
        -- Se não estiver dentro do horário permitido, espera 1 minuto antes de verificar novamente
        WAITFOR DELAY '00:01:00';
    END
END
