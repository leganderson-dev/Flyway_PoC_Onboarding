/*
This script will:

Create empty Widget_Build DB
Create empty Widget_Shadow DB
Create and populate Widget_Dev
Create and populate Widget_Staging

*/

/*
Create empty Widget_Build DB
*/
 
IF  EXISTS (SELECT name FROM sys.databases 
		WHERE name = N'Widget_Build'
)
 
 
DROP DATABASE Widget_Build
GO
 
CREATE DATABASE Widget_Build


/*
Create empty Widget Shadow DB
*/
 
IF  EXISTS (SELECT name FROM sys.databases 
		WHERE name = N'Widget_Shadow'
)
 
 
DROP DATABASE Widget_Shadow
GO
 
CREATE DATABASE Widget_Shadow

/*
Create Widget_Dev
*/
 
IF  EXISTS (SELECT name FROM sys.databases 
		WHERE name = N'Widget_Dev'
)
 
 
DROP DATABASE Widget_Dev
GO
 
CREATE DATABASE Widget_Dev
GO
USE Widget_Dev
GO
 
CREATE TABLE [dbo].[WidgetPrices] (
	[RecordID] [int] IDENTITY (1, 1) NOT NULL ,
	[WidgetID] [int] NULL ,
	[Price] [money] NULL ,
	[DateValidFrom] [datetime] NULL ,
	[DateValidTo] [datetime] NULL ,
	[Active] [char] (1) NULL 
) ON [PRIMARY]
GO
 
CREATE TABLE [dbo].[WidgetDescriptions] (
	[WidgetID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (500) NULL ,
	[WidgetName] [varchar] (50) NULL
	)ON [PRIMARY]
	GO
 
CREATE TABLE [dbo].[Widgets] (
	[RecordID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) NULL ,
	[SKU] [varchar] (20) NULL 
) ON [PRIMARY]
GO
 
CREATE TABLE [dbo].[WidgetReferences] (
	[WidgetID] [int] NOT NULL ,
	[Reference] [varchar] (50) NULL 
) ON [PRIMARY]
GO
 
ALTER TABLE [dbo].[WidgetReferences] WITH NOCHECK ADD 
	CONSTRAINT [PK_WidgetReferences] PRIMARY KEY  NONCLUSTERED 
	(
		[WidgetID]
	)  ON [PRIMARY] 
GO
 
ALTER TABLE [dbo].[WidgetPrices] WITH NOCHECK ADD 
	CONSTRAINT [DF_WidgetPrices_DateValidFrom] DEFAULT (getdate()) FOR [DateValidFrom],
	CONSTRAINT [DF_WidgetPrices_Active] DEFAULT ('N') FOR [Active],
	CONSTRAINT [PK_WidgetPrices] PRIMARY KEY  NONCLUSTERED 
	(
		[RecordID]
	)  ON [PRIMARY] 
GO
 
ALTER TABLE [dbo].[Widgets] WITH NOCHECK ADD 
	CONSTRAINT [PK_Widgets] PRIMARY KEY  NONCLUSTERED 
	(
		[RecordID]
	)  ON [PRIMARY] 
GO
 
 CREATE  INDEX [IX_WidgetPrices] ON [dbo].[WidgetPrices]([WidgetID]) ON [PRIMARY]
GO
 
 CREATE  INDEX [IX_WidgetPrices_1] ON [dbo].[WidgetPrices]([DateValidFrom]) ON [PRIMARY]
GO
 
 CREATE  INDEX [IX_WidgetPrices_2] ON [dbo].[WidgetPrices]([DateValidTo]) ON [PRIMARY]
GO
 
GRANT  SELECT  ON [dbo].[WidgetPrices]  TO [public]
GO
 
DENY  REFERENCES ,  INSERT ,  DELETE ,  UPDATE  ON [dbo].[WidgetPrices]  TO [public] CASCADE 
GO
 
GRANT  SELECT  ON [dbo].[Widgets]  TO [public]
GO
 
DENY  REFERENCES ,  INSERT ,  DELETE ,  UPDATE  ON [dbo].[Widgets]  TO [public] CASCADE 
GO
 
ALTER TABLE [dbo].[WidgetPrices] ADD 
	CONSTRAINT [FK_WidgetPrices_Widgets] FOREIGN KEY 
	(
		[WidgetID]
	) REFERENCES [dbo].[Widgets] (
		[RecordID]
	)
GO
 
SET QUOTED_IDENTIFIER  ON    SET ANSI_NULLS  ON 
GO
 
CREATE VIEW dbo.CurrentPrices
AS
SELECT WidgetPrices.WidgetID, WidgetPrices.Price, 
    Widgets.Description
FROM dbo.Widgets INNER JOIN
    dbo.WidgetPrices ON 
    dbo.Widgets.RecordID = dbo.WidgetPrices.WidgetID
WHERE dbo.WidgetPrices.Active = 'Y'
 
GO
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO
 
GRANT  SELECT  ON [dbo].[CurrentPrices]  TO [public]
GO
 
DENY  INSERT ,  DELETE ,  UPDATE  ON [dbo].[CurrentPrices]  TO [public] CASCADE 
GO
 
SET QUOTED_IDENTIFIER  ON    SET ANSI_NULLS  ON 
GO
 
CREATE PROCEDURE prcActivatePrices  AS
 
UPDATE WidgetPrices SET Active='N' WHERE GetDate()<DateValidTo OR GetDate()>DateValidFrom
UPDATE WidgetPrices SET Active='Y' WHERE GetDate()>=DateValidFrom OR GetDate()<=DateValidFrom
 
 
GO
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO
 
DENY  EXECUTE  ON [dbo].[prcActivatePrices]  TO [public] CASCADE 
GO
 
/*
Populate Widget_Dev with data
*/
USE Widget_Dev
GO
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
-- Pointer used for text / image updates. This might not be needed, but is declared here just in case
DECLARE @pv binary(16)
 
-- Drop constraints from [dbo].[WidgetPrices]
ALTER TABLE [dbo].[WidgetPrices] DROP CONSTRAINT [FK_WidgetPrices_Widgets]
 
-- Add 10 rows to [dbo].[WidgetDescriptions]
SET IDENTITY_INSERT [dbo].[WidgetDescriptions] ON
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (1, 'vantis. fecundio, quad eggredior. nomen nomen quad dolorum gravum ut et quantare vobis quartu bono quad funem.', '89541')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (2, 'apparens Id novum Sed estis si gravum apparens gravum dolorum fecundio, quis et glavans cognitio, quoque', '19614')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (3, 'Et Pro plorum trepicandor pladior e fecundio, vobis novum bono pars Quad regit, travissimantor e cognitio, nomen', '21711')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (4, 'volcans Longam, estis non non estis et Id vantis. esset transit. Sed et fecit, vobis fecit. plurissimum quorum rarendum trepicandor quantare cognitio, si', '51534')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (5, 'essit. volcans quad novum in brevens, si manifestum cognitio, non eudis glavans e delerium. eggredior.', '40493')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (6, 'glavans eggredior. eudis delerium. cognitio, pars fecit. funem. essit. si pladior eggredior. glavans', '78782')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (7, 'quo, plorum quo vobis manifestum Et imaginator eggredior. rarendum et quad fecit. linguens delerium. linguens', '50517')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (8, 'Longam, quorum glavans ut Longam, e e venit. brevens, parte dolorum Longam, Quad et esset novum Sed Tam', NULL)
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (9, 'bono Sed plorum quad quad si plurissimum et Quad gravis homo, bono sed quo egreddior imaginator plorum Sed', '38345')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (10, 'pladior cognitio, quartu volcans vobis pladior nomen Id transit. quorum plurissimum sed vantis. in quis', '86125')
SET IDENTITY_INSERT [dbo].[WidgetDescriptions] OFF
 
-- Add 10 rows to [dbo].[WidgetReferences]
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (1, 'HRGM1S45G9L67Z6M9V74RCKV0ZQCYOW01OXJMLTMGB0')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (2, '0ULCDFPYJID56LL11R7RDK5J1MZN1KNFBGV6EDYIYYHJA')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (3, 'D10RLP49QF')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (4, '1AQF2WZUXTPQENN')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (5, 'OTE3L899YN')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (6, 'YYB2QGHC283V2IODYNAL3XWFFCB3S1GGFL0V')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (7, 'RZAWBKKLYCLXVAMN1612')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (8, 'NE4EJ')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (9, 'RMGGHTR7N0ORCCUHZQ6XQUSDFZTP4L5ISJTYHW3443YNCEOQ1')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (10, 'ED8LAXU20IZ122V6ZTIVZ3M1SMV500B3NY6R968W4E')
 
-- Add 10 rows to [dbo].[Widgets]
SET IDENTITY_INSERT [dbo].[Widgets] ON
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (1, 'quad trepicandor rarendum quo non Pro quis')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (2, 'non linguens cognitio, imaginator estis')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (3, 'estum. travissimantor fecit. homo, et')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (4, 'non transit. venit. nomen quad esset pladior Sed')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (5, 'esset quantare Versus et quantare Sed novum Multum')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (6, 'trepicandor ut egreddior trepicandor apparens')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (7, 'transit. Multum Sed esset venit. sed pladior quad')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (8, 'quad habitatio estis quoque Sed et et rarendum')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (9, 'in vantis. Longam, linguens novum Tam quartu bono')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (10, 'quis fecit, Longam, linguens Sed gravum funem.')
SET IDENTITY_INSERT [dbo].[Widgets] OFF
 
-- Add 10 rows to [dbo].[WidgetPrices]
SET IDENTITY_INSERT [dbo].[WidgetPrices] ON
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (1, 9, 698.1374)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (2, 6, 325.4914)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (3, 6, 693.4032)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (4, 5, 116.1689)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (5, 3, 751.7997)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (6, 5, 49.3884)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (7, 5, 422.2571)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (8, 1, 895.2037)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (9, 10, 596.7856)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (10, 4, 213.4546)
SET IDENTITY_INSERT [dbo].[WidgetPrices] OFF
 
-- Add constraints to [dbo].[WidgetPrices]
ALTER TABLE [dbo].[WidgetPrices] ADD CONSTRAINT [FK_WidgetPrices_Widgets] FOREIGN KEY ([WidgetID]) REFERENCES [dbo].[Widgets] ([RecordID])
COMMIT TRANSACTION
GO














/*
Create Widget_Staging
*/
USE tempdb
GO
IF  EXISTS (SELECT name FROM sys.databases 
		WHERE name = N'Widget_Staging'
)
DROP DATABASE Widget_Staging
GO
 
CREATE DATABASE Widget_Staging
GO
USE Widget_Staging
GO
 
CREATE TABLE [dbo].[WidgetPrices] (
	[RecordID] [int] IDENTITY (1, 1) NOT NULL ,
	[WidgetID] [int] NULL ,
	[Price] [money] NULL ,
	[DateValidFrom] [datetime] NULL ,
	[DateValidTo] [datetime] NULL ,
	[Active] [char] (1) NULL 
) ON [PRIMARY]
GO
 
CREATE TABLE [dbo].[WidgetDescriptions] (
	[WidgetID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (500) NULL ,
	[WidgetName] [varchar] (50) NULL
	)ON [PRIMARY]
	GO
 
CREATE TABLE [dbo].[Widgets] (
	[RecordID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) NULL ,
	[SKU] [varchar] (20) NULL 
) ON [PRIMARY]
GO
 
CREATE TABLE [dbo].[WidgetReferences] (
	[WidgetID] [int] NOT NULL ,
	[Reference] [varchar] (50) NULL 
) ON [PRIMARY]
GO
 
ALTER TABLE [dbo].[WidgetReferences] WITH NOCHECK ADD 
	CONSTRAINT [PK_WidgetReferences] PRIMARY KEY  NONCLUSTERED 
	(
		[WidgetID]
	)  ON [PRIMARY] 
GO
 
ALTER TABLE [dbo].[WidgetPrices] WITH NOCHECK ADD 
	CONSTRAINT [DF_WidgetPrices_DateValidFrom] DEFAULT (getdate()) FOR [DateValidFrom],
	CONSTRAINT [DF_WidgetPrices_Active] DEFAULT ('N') FOR [Active],
	CONSTRAINT [PK_WidgetPrices] PRIMARY KEY  NONCLUSTERED 
	(
		[RecordID]
	)  ON [PRIMARY] 
GO
 
ALTER TABLE [dbo].[Widgets] WITH NOCHECK ADD 
	CONSTRAINT [PK_Widgets] PRIMARY KEY  NONCLUSTERED 
	(
		[RecordID]
	)  ON [PRIMARY] 
GO
 
 CREATE  INDEX [IX_WidgetPrices] ON [dbo].[WidgetPrices]([WidgetID]) ON [PRIMARY]
GO
 
 CREATE  INDEX [IX_WidgetPrices_1] ON [dbo].[WidgetPrices]([DateValidFrom]) ON [PRIMARY]
GO
 
 CREATE  INDEX [IX_WidgetPrices_2] ON [dbo].[WidgetPrices]([DateValidTo]) ON [PRIMARY]
GO
 
GRANT  SELECT  ON [dbo].[WidgetPrices]  TO [public]
GO
 
DENY  REFERENCES ,  INSERT ,  DELETE ,  UPDATE  ON [dbo].[WidgetPrices]  TO [public] CASCADE 
GO
 
GRANT  SELECT  ON [dbo].[Widgets]  TO [public]
GO
 
DENY  REFERENCES ,  INSERT ,  DELETE ,  UPDATE  ON [dbo].[Widgets]  TO [public] CASCADE 
GO
 
ALTER TABLE [dbo].[WidgetPrices] ADD 
	CONSTRAINT [FK_WidgetPrices_Widgets] FOREIGN KEY 
	(
		[WidgetID]
	) REFERENCES [dbo].[Widgets] (
		[RecordID]
	)
GO
 
SET QUOTED_IDENTIFIER  ON    SET ANSI_NULLS  ON 
GO
 
CREATE VIEW dbo.CurrentPrices
AS
SELECT WidgetPrices.WidgetID, WidgetPrices.Price, 
    Widgets.Description
FROM dbo.Widgets INNER JOIN
    dbo.WidgetPrices ON 
    dbo.Widgets.RecordID = dbo.WidgetPrices.WidgetID
WHERE dbo.WidgetPrices.Active = 'Y'
 
GO
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO
 
GRANT  SELECT  ON [dbo].[CurrentPrices]  TO [public]
GO
 
DENY  INSERT ,  DELETE ,  UPDATE  ON [dbo].[CurrentPrices]  TO [public] CASCADE 
GO
 
SET QUOTED_IDENTIFIER  ON    SET ANSI_NULLS  ON 
GO
 
CREATE PROCEDURE prcActivatePrices  AS
 
UPDATE WidgetPrices SET Active='N' WHERE GetDate()<DateValidTo OR GetDate()>DateValidFrom
UPDATE WidgetPrices SET Active='Y' WHERE GetDate()>=DateValidFrom OR GetDate()<=DateValidFrom
 
 
GO
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO
 
DENY  EXECUTE  ON [dbo].[prcActivatePrices]  TO [public] CASCADE 
GO
 
/*
Populate Widget_Staging with data
*/
USE Widget_Staging
GO
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
-- Pointer used for text / image updates. This might not be needed, but is declared here just in case
DECLARE @pv binary(16)
 
-- Drop constraints from [dbo].[WidgetPrices]
ALTER TABLE [dbo].[WidgetPrices] DROP CONSTRAINT [FK_WidgetPrices_Widgets]
 
-- Add 10 rows to [dbo].[WidgetDescriptions]
SET IDENTITY_INSERT [dbo].[WidgetDescriptions] ON
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (1, 'vantis. fecundio, quad eggredior. nomen nomen quad dolorum gravum ut et quantare vobis quartu bono quad funem.', '89541')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (2, 'apparens Id novum Sed estis si gravum apparens gravum dolorum fecundio, quis et glavans cognitio, quoque', '19614')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (3, 'Et Pro plorum trepicandor pladior e fecundio, vobis novum bono pars Quad regit, travissimantor e cognitio, nomen', '21711')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (4, 'volcans Longam, estis non non estis et Id vantis. esset transit. Sed et fecit, vobis fecit. plurissimum quorum rarendum trepicandor quantare cognitio, si', '51534')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (5, 'essit. volcans quad novum in brevens, si manifestum cognitio, non eudis glavans e delerium. eggredior.', '40493')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (6, 'glavans eggredior. eudis delerium. cognitio, pars fecit. funem. essit. si pladior eggredior. glavans', '78782')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (7, 'quo, plorum quo vobis manifestum Et imaginator eggredior. rarendum et quad fecit. linguens delerium. linguens', '50517')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (8, 'Longam, quorum glavans ut Longam, e e venit. brevens, parte dolorum Longam, Quad et esset novum Sed Tam', NULL)
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (9, 'bono Sed plorum quad quad si plurissimum et Quad gravis homo, bono sed quo egreddior imaginator plorum Sed', '38345')
INSERT INTO [dbo].[WidgetDescriptions] ([WidgetID], [Description], [WidgetName]) VALUES (10, 'pladior cognitio, quartu volcans vobis pladior nomen Id transit. quorum plurissimum sed vantis. in quis', '86125')
SET IDENTITY_INSERT [dbo].[WidgetDescriptions] OFF
 
-- Add 10 rows to [dbo].[WidgetReferences]
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (1, 'HRGM1S45G9L67Z6M9V74RCKV0ZQCYOW01OXJMLTMGB0')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (2, '0ULCDFPYJID56LL11R7RDK5J1MZN1KNFBGV6EDYIYYHJA')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (3, 'D10RLP49QF')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (4, '1AQF2WZUXTPQENN')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (5, 'OTE3L899YN')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (6, 'YYB2QGHC283V2IODYNAL3XWFFCB3S1GGFL0V')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (7, 'RZAWBKKLYCLXVAMN1612')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (8, 'NE4EJ')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (9, 'RMGGHTR7N0ORCCUHZQ6XQUSDFZTP4L5ISJTYHW3443YNCEOQ1')
INSERT INTO [dbo].[WidgetReferences] ([WidgetID], [Reference]) VALUES (10, 'ED8LAXU20IZ122V6ZTIVZ3M1SMV500B3NY6R968W4E')
 
-- Add 10 rows to [dbo].[Widgets]
SET IDENTITY_INSERT [dbo].[Widgets] ON
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (1, 'quad trepicandor rarendum quo non Pro quis')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (2, 'non linguens cognitio, imaginator estis')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (3, 'estum. travissimantor fecit. homo, et')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (4, 'non transit. venit. nomen quad esset pladior Sed')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (5, 'esset quantare Versus et quantare Sed novum Multum')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (6, 'trepicandor ut egreddior trepicandor apparens')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (7, 'transit. Multum Sed esset venit. sed pladior quad')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (8, 'quad habitatio estis quoque Sed et et rarendum')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (9, 'in vantis. Longam, linguens novum Tam quartu bono')
INSERT INTO [dbo].[Widgets] ([RecordID], [Description]) VALUES (10, 'quis fecit, Longam, linguens Sed gravum funem.')
SET IDENTITY_INSERT [dbo].[Widgets] OFF
 
-- Add 10 rows to [dbo].[WidgetPrices]
SET IDENTITY_INSERT [dbo].[WidgetPrices] ON
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (1, 9, 698.1374)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (2, 6, 325.4914)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (3, 6, 693.4032)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (4, 5, 116.1689)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (5, 3, 751.7997)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (6, 5, 49.3884)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (7, 5, 422.2571)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (8, 1, 895.2037)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (9, 10, 596.7856)
INSERT INTO [dbo].[WidgetPrices] ([RecordID], [WidgetID], [Price]) VALUES (10, 4, 213.4546)
SET IDENTITY_INSERT [dbo].[WidgetPrices] OFF
 
-- Add constraints to [dbo].[WidgetPrices]
ALTER TABLE [dbo].[WidgetPrices] ADD CONSTRAINT [FK_WidgetPrices_Widgets] FOREIGN KEY ([WidgetID]) REFERENCES [dbo].[Widgets] ([RecordID])
COMMIT TRANSACTION
GO