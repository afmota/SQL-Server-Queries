USE [mirror]
GO

/****** Object:  Table [DATABASES].[ConexoesCompletaText]    Script Date: 13/06/2023 09:52:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DATABASES].[ConexoesCompletaText](
	[dbname] [varchar](max) NULL,
	[collectionDate] [datetime] NULL,
	[sessionId] [int] NULL,
	[qtdPages] [bigint] NULL,
	[totalPagesMemKB] [bigint] NULL,
	[hostName] [varchar](max) NULL,
	[loginName] [varchar](max) NULL,
	[originalName] [varchar](max) NULL,
	[programName] [varchar](max) NULL,
	[hostProcessID] [bigint] NULL,
	[status] [varchar](20) NULL,
	[lastRequestStartTime] [datetime] NULL,
	[lastBach] [datetime] NULL,
	[text] [text] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


