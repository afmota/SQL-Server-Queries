USE [mirror]
GO

/****** Object:  Table [DATABASES].[ConexoesSimples]    Script Date: 13/06/2023 09:54:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DATABASES].[ConexoesSimples](
	[collectionDate] [datetime] NULL,
	[dbname] [varchar](100) NULL,
	[conections] [int] NULL,
	[Login] [varchar](100) NULL,
	[program] [varchar](100) NULL,
	[host] [varchar](100) NULL
) ON [PRIMARY]
GO


