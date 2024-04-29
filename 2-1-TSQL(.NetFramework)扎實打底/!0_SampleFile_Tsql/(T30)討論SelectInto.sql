-- T030_SelectInto --------------------------------


--========================================================================
--T030_01_Create Sample Data
--========================================================================

--If Table exists then DROP it
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA;
        DROP TABLE PersonA;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'DepartmentA' ) )
    BEGIN
        TRUNCATE TABLE dbo.DepartmentA;
        DROP TABLE DepartmentA;
    END;
GO -- Run the previous command and begins new batch
CREATE TABLE DepartmentA
    (
      ID INT PRIMARY KEY ,
      [Name] NVARCHAR(50)
    );
GO -- Run the previous command and begins new batch
INSERT  INTO DepartmentA
VALUES  ( 1, 'DepartmentA01' );
INSERT  INTO DepartmentA
VALUES  ( 2, 'DepartmentA02' );
INSERT  INTO DepartmentA
VALUES  ( 3, 'DepartmentA03' );
GO -- Run the previous command and begins new batch
CREATE TABLE PersonA
    (
      ID INT PRIMARY KEY ,
      [Name] NVARCHAR(100) ,
      DepartmentID INT FOREIGN KEY REFERENCES DepartmentA ( ID )
    );
GO -- Run the previous command and begins new batch
INSERT  INTO PersonA
VALUES  ( 1, 'Name01', 1 );
INSERT  INTO PersonA
VALUES  ( 2, 'Name02', 3 );
INSERT  INTO PersonA
VALUES  ( 3, 'Name03', 2 );
INSERT  INTO PersonA
VALUES  ( 4, 'Name04', 2 );
INSERT  INTO PersonA
VALUES  ( 5, 'Name05', 1 );
GO -- Run the previous command and begins new batch

SELECT * FROM PersonA
SELECT * FROM DepartmentA
GO -- Run the previous command and begins new batch


--========================================================================
--T030_02_Select Into
--========================================================================

-------------------------------------------------------------------------
--T030_02_01
SELECT  *
INTO    PersonA2
FROM    PersonA;

SELECT  *
FROM    PersonA2;
/*
Copy all columns and rows
from existing table 
into a new table. 
*/

-------------------------------------------------------------------------
--T030_02_02
SELECT  *
INTO    [Sample].dbo.PersonA3
FROM    PersonA;

SELECT  *
FROM    PersonA3;
/*
Copy all columns and rows
from existing table 
into a new table of other database. 
*/

-------------------------------------------------------------------------
--T030_02_03
SELECT  ID ,
        [Name]
INTO    PersonA4
FROM    PersonA;

SELECT  *
FROM    PersonA4;
/*
Copy selected  columns
from existing table 
into a new table. 
*/

-------------------------------------------------------------------------
--T030_02_04
SELECT  *
INTO    PersonA5
FROM    PersonA
WHERE   DepartmentID = 1;

SELECT  *
FROM    PersonA5;
/*
Copy selected all columns and selected rows
from existing table 
into a new table. 
*/

-------------------------------------------------------------------------
--T030_02_05
SELECT  p.ID ,
        p.[Name] ,
        p.DepartmentID ,
        d.[Name] AS DepartmentName
INTO    PersonA6
FROM    PersonA p
        INNER JOIN DepartmentA d ON p.DepartmentID = d.ID;

SELECT  *
FROM    PersonA6;
/*
Join 2 tables 
and copy selected columns and all rows
from existing table 
into a new table. 
*/

-------------------------------------------------------------------------
--T030_02_06
SELECT  *
INTO    PersonA7
FROM    PersonA
WHERE   1 <> 1;

SELECT  *
FROM    PersonA7;
/*
Copy the Table Structure into new Table.  
The Table structure includes its columns and datatypes.  
Do not copy any records from old table into new table
*/

-------------------------------------------------------------------------
--T030_02_07
SELECT  *
INTO    PersonA8
FROM    [N550JKL\SQL2016].[Sample].[dbo].[PersonA];

SELECT  *
FROM    PersonA8;
/*
Copy all columns and all rows
from existing table 
into a new table of other database of other SQL server
*/

-------------------------------------------------------------------------
--T030_02_08
--INSERT INTO .... SELECT

IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA9' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA9;
        DROP TABLE PersonA9;
    END;
GO -- Run the previous command and begins new batch
CREATE TABLE PersonA9
    (
      ID INT PRIMARY KEY ,
      [Name] NVARCHAR(100) ,
      DepartmentID INT
    );
GO -- Run the previous command and begins new batch

INSERT  INTO PersonA9
        ( ID ,
          [Name] ,
          DepartmentID
        )
        SELECT  ID ,
                [Name] ,
                DepartmentID
        FROM    PersonA;
GO -- Run the previous command and begins new batch

SELECT  *
FROM    PersonA9;

/*
SELECT INTO can NOT select data into an existing table.
Need to use INSERT INTO .... SELECT.
Syntax
--INSERT INTO ExistingTable (ColumnList...)
--SELECT ColumnList... FROM SourceTable
*/

--========================================================================
--T030_03_Clean up
--========================================================================

--If Table exists then DROP it
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA;
        DROP TABLE PersonA;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'DepartmentA' ) )
    BEGIN
        TRUNCATE TABLE dbo.DepartmentA;
        DROP TABLE DepartmentA;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA2' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA2;
        DROP TABLE PersonA2;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA3' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA3;
        DROP TABLE PersonA3;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA4' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA4;
        DROP TABLE PersonA4;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA5' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA5;
        DROP TABLE PersonA5;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA6' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA6;
        DROP TABLE PersonA6;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA7' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA7;
        DROP TABLE PersonA7;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA8' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA8;
        DROP TABLE PersonA8;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'PersonA9' ) )
    BEGIN
        TRUNCATE TABLE dbo.PersonA9;
        DROP TABLE PersonA9;
    END;
GO -- Run the previous command and begins new batch


