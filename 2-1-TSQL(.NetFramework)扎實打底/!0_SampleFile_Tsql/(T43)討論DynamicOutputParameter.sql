-- T043_DynamicOutputParameter -----------------------------------------


/*
1.
parameterised dynamic sql with dynamic Output Parameter 
--DECLARE @gamerCount INT;
--DECLARE @gender NVARCHAR(10)  = 'Male';
--DECLARE @sql NVARCHAR(MAX) = 'SELECT @gamerCount = Count(*) FROM Gamer where Gender=@gender';
--EXECUTE sp_executesql @sql, N'@gender NVARCHAR(10), @gamerCount INT OUTPUT',
--    @gender, @gamerCount OUTPUT;
--PRINT @gamerCount;
*/


--========================================================================
--T043_01_Create Sample Data
--========================================================================

IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Gamer' ) )
    BEGIN
        TRUNCATE TABLE dbo.[Gamer];
        DROP TABLE [Gamer];
    END;
GO -- Run the previous command and begins new batch
CREATE TABLE [Gamer]
(
  Id INT IDENTITY(1, 1)
         PRIMARY KEY ,
  FirstName NVARCHAR(50) ,
  LastName NVARCHAR(50) ,
  Gender NVARCHAR(50) ,
  GameScore INT
);
GO -- Run the previous command and begins new batch
INSERT  INTO Gamer
VALUES  ( 'AFirst01', 'XLast01', 'Female', 3500 );
INSERT  INTO Gamer
VALUES  ( 'AFirst02', 'YLast02', 'Female', 4000 );
INSERT  INTO Gamer
VALUES  ( 'BFirst03', 'YLast03', 'Male', 4600 );
INSERT  INTO Gamer
VALUES  ( 'BFirst04', 'YLast04', 'Male', 5400 );
INSERT  INTO Gamer
VALUES  ( 'BFirst05', 'ZLast05', 'Female', 2000 );
INSERT  INTO Gamer
VALUES  ( 'CFirst06', 'YLast06', 'Male', 4320 );
INSERT  INTO Gamer
VALUES  ( 'CFirst07', 'YLast07', 'Male', 4400 );
GO -- Run the previous command and begins new batch

SELECT  *
FROM    Gamer;
GO -- Run the previous command and begins new batch

--========================================================================
--T043_02_parameterised dynamic sql with dynamic Output Parameter  
--========================================================================

--========================================================================
--T043_02_01
--parameterised dynamic sql
DECLARE @gender NVARCHAR(10) = 'Male';
DECLARE @sql NVARCHAR(MAX) = 'SELECT Count(*) FROM Gamer WHERE Gender=@gender';
EXECUTE sp_executesql @sql, N'@gender NVARCHAR(10)', @gender;
GO -- Run the previous command and begins new batch
--4

--========================================================================
--T043_02_02
--parameterised dynamic sql with dynamic Output Parameter 
DECLARE @gamerCount INT;
DECLARE @gender NVARCHAR(10)  = 'Male';
DECLARE @sql NVARCHAR(MAX) = 'SELECT @gamerCount = Count(*) FROM Gamer where Gender=@gender';
EXECUTE sp_executesql @sql, N'@gender NVARCHAR(10), @gamerCount INT OUTPUT',
    @gender, @gamerCount OUTPUT;
PRINT @gamerCount;
GO -- Run the previous command and begins new batch
--4

--========================================================================
--T043_02_03
--parameterised dynamic sql with dynamic Output Parameter 
--Without OUTPUT, it will return NULL
DECLARE @gamerCount INT;
DECLARE @gender NVARCHAR(10)  = 'Male';
DECLARE @sql NVARCHAR(MAX) = 'SELECT @gamerCount = Count(*) FROM Gamer where Gender=@gender';
EXECUTE sp_executesql @sql, N'@gender NVARCHAR(10), @gamerCount INT OUTPUT',
    @gender, @gamerCount;
--**Without OUTPUT, it will return NULL
SELECT @gamerCount;
GO -- Run the previous command and begins new batch
--NULL


--========================================================================
--T043_03_Clean up
--========================================================================

IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Gamer' ) )
    BEGIN
        TRUNCATE TABLE dbo.[Gamer];
        DROP TABLE [Gamer];
    END;
GO -- Run the previous command and begins new batch

