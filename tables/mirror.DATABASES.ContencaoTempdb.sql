USE [mirror]
GO

/****** Object:  Table [DATABASES].[ContencaoTempdb]    Script Date: 13/06/2023 09:55:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DATABASES].[ContencaoTempdb](
	[collectionDate] [datetime] NULL,
	[waitResouce] [varchar](max) NULL,
	[waitType] [varchar](max) NULL,
	[lastWaitType] [varchar](30) NULL,
	[status] [varchar](20) NULL,
	[quantity] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


