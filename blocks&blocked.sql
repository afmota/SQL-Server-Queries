SELECT  spid ,
        status ,
        blocked ,
        open_tran ,
        waitresource ,
        waittype ,
        waittime ,
        cmd ,
        lastwaittype
FROM    master.dbo.sysprocesses
WHERE   blocked <> 0