USE [mirror]
GO

/****** Object:  Table [DATABASES].[LockTablesFull]    Script Date: 13/06/2023 10:00:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DATABASES].[LockTablesFull](
	[lockObjectName] [varchar](max) NULL,
	[lockObjectId] [bigint] NULL,
	[spid] [int] NULL,
	[dbname] [varchar](9) NULL,
	[collectionDate] [datetime] NULL,
	[lockResource] [varchar](10) NULL,
	[lockType] [varchar](20) NULL,
	[count] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


