USE [mirror]
GO

/****** Object:  Table [DATABASES].[TamanhoBancos]    Script Date: 13/06/2023 10:04:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DATABASES].[TamanhoBancos](
	[data] [datetime] NULL,
	[nome] [varchar](max) NULL,
	[tamanho] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


