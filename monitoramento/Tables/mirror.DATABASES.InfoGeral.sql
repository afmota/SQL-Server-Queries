USE [mirror]
GO

/****** Object:  Table [DATABASES].[InfoGeral]    Script Date: 13/06/2023 09:57:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DATABASES].[InfoGeral](
	[collectionDate] [datetime] NULL,
	[dbname] [varchar](max) NULL,
	[sessionId] [int] NULL,
	[programName] [varchar](max) NULL,
	[hostname] [varchar](max) NULL,
	[clientNetAddress] [varchar](15) NULL,
	[clientTcpPort] [bigint] NULL,
	[localNetAddress] [varchar](15) NULL,
	[localTcpPort] [bigint] NULL,
	[netPacketSize] [bigint] NULL,
	[duration] [varchar](max) NULL,
	[command] [varchar](20) NULL,
	[status] [varchar](20) NULL,
	[loginName] [varchar](max) NULL,
	[waitInfo] [varchar](max) NULL,
	[cpu] [bigint] NULL,
	[tempdbAllocations] [bigint] NULL,
	[tempdbCurrent] [bigint] NULL,
	[reads] [bigint] NULL,
	[writes] [bigint] NULL,
	[physicalReads] [bigint] NULL,
	[usedMemory] [bigint] NULL,
	[blockingSessionId] [int] NULL,
	[blockedSessionCount] [int] NULL,
	[deadlockPriority] [varchar](10) NULL,
	[row_Count] [bigint] NULL,
	[openTransactionCount] [int] NULL,
	[transactionIsolationLevel] [int] NULL,
	[transactionIsolationLevelDesc] [varchar](max) NULL,
	[startTime] [datetime] NULL,
	[loginTime] [datetime] NULL,
	[requesTd] [int] NULL,
	[sqlText] [xml] NULL,
	[sqlCommand] [xml] NULL,
	[queryPlan] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


