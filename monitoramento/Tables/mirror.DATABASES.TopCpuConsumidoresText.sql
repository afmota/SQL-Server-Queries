USE [mirror]
GO

/****** Object:  Table [DATABASES].[TopCpuConsumidoresText]    Script Date: 13/06/2023 09:48:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DATABASES].[TopCpuConsumidoresText](
	[collectionDate] [datetime] NULL,
	[dbname] [varchar](max) NULL,
	[shortQueryText] [text] NULL,
	[executionCount] [bigint] NULL,
	[totalWorkerTime] [bigint] NULL,
	[minWorkerTime] [bigint] NULL,
	[avgWorkerTime] [bigint] NULL,
	[maxWorkerTime] [bigint] NULL,
	[minElapsedTime] [bigint] NULL,
	[avgElapsedTime] [bigint] NULL,
	[maxElapsedTime] [bigint] NULL,
	[minLogicalTime] [bigint] NULL,
	[avgLogicalTime] [bigint] NULL,
	[maxLogicalTime] [bigint] NULL,
	[creationTime] [datetime] NULL,
	[queryText] [text] NULL,
	[queryPan] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


