USE [mirror]
GO

/****** Object:  Table [DATABASES].[LockTablesContencao]    Script Date: 13/06/2023 09:58:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DATABASES].[LockTablesContencao](
	[collection_date] [datetime] NULL,
	[db_name] [nvarchar](max) NULL,
	[nested_level] [int] NULL,
	[session_id] [smallint] NULL,
	[wait_info] [nvarchar](4000) NULL,
	[wait_time_ms] [bigint] NULL,
	[blocking_session_id] [smallint] NULL,
	[blocked_session_count] [int] NULL,
	[open_transaction_count] [int] NULL,
	[sql_text] [xml] NULL,
	[sql_command] [xml] NULL,
	[total_elapsed_time] [int] NULL,
	[deadlock_priority] [int] NULL,
	[transaction_isolation_level] [varchar](50) NULL,
	[last_request_start_time] [datetime] NULL,
	[login_name] [nvarchar](128) NULL,
	[nt_user_name] [nvarchar](128) NULL,
	[original_login_name] [nvarchar](128) NULL,
	[host_name] [nvarchar](128) NULL,
	[program_name] [nvarchar](128) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


