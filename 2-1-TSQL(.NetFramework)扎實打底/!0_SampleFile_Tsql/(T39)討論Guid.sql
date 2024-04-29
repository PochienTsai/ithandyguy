-- T039_Guid ----------------------------------------------------------



--========================================================================
--T039_01
--Guid
DECLARE @Guid1 UNIQUEIDENTIFIER = NEWID();
PRINT @Guid1;

DECLARE @Guid2 UNIQUEIDENTIFIER;
PRINT @Guid2;
IF ( @Guid2 IS NULL )
    BEGIN
        PRINT '@Guid2 is NULL, now, set value';
        SET @Guid2 = NEWID();
    END;
PRINT @Guid2;

DECLARE @Guid3 UNIQUEIDENTIFIER;
SELECT  ISNULL(@Guid3, NEWID());
PRINT @Guid3;
GO -- Run the previous command and begins new batch

--========================================================================
--T039_02
--Empty Guid
DECLARE @Guid1 UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000';
PRINT @Guid1;
DECLARE @Guid2 UNIQUEIDENTIFIER = CAST(CAST(0 AS BINARY) AS UNIQUEIDENTIFIER);
PRINT @Guid2;
DECLARE @Guid3 UNIQUEIDENTIFIER = CAST(0x0 AS UNIQUEIDENTIFIER);
--0x0 is a literal of datatype varbinary(1) and value 0x00. (A single byte with all bits set to 0).
PRINT @Guid3;

--Check if Empty Guid
IF ( @Guid1 = '00000000-0000-0000-0000-000000000000' )
    BEGIN
        PRINT '@Guid1 is Empty Guid, now, set NEWID()';
        SET @Guid1 = NEWID();
    END;
PRINT @Guid1;

--Check if Empty Guid
DECLARE @Result1 NVARCHAR(30) = IIF(@Guid2 = CAST(0x0 AS UNIQUEIDENTIFIER), '@Guid2 is empty Guid', CAST(@Guid2 AS NVARCHAR));
PRINT @Result1;
GO -- Run the previous command and begins new batch

--========================================================================
--T039_03
--Guid In table

IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Person1' ) )
    BEGIN
        TRUNCATE TABLE dbo.Person1;
        DROP TABLE Person1;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Person2' ) )
    BEGIN
        TRUNCATE TABLE dbo.Person2;
        DROP TABLE Person2;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Person3' ) )
    BEGIN
        TRUNCATE TABLE dbo.Person3;
        DROP TABLE Person3;
    END;
GO -- Run the previous command and begins new batch

CREATE TABLE Person1
(
  Id UNIQUEIDENTIFIER PRIMARY KEY
                      DEFAULT NEWID() ,
  [Name] NVARCHAR(50)
);
INSERT  INTO Person1
VALUES  ( DEFAULT, 'P1Name01' );
INSERT  INTO Person1
VALUES  ( DEFAULT, 'P1Name02' );
GO -- Run the previous command and begins new batch

CREATE TABLE Person2
(
  Id UNIQUEIDENTIFIER PRIMARY KEY
                      DEFAULT NEWID() ,
  [Name] NVARCHAR(50)
);
INSERT  INTO Person2
VALUES  ( DEFAULT, 'P2Name01' );
INSERT  INTO Person2
VALUES  ( DEFAULT, 'P2Name02' );
GO -- Run the previous command and begins new batch

CREATE TABLE Person3
(
  Id UNIQUEIDENTIFIER PRIMARY KEY
                      DEFAULT NEWID() ,
  [Name] NVARCHAR(50)
);
INSERT  INTO Person3
        SELECT  *
        FROM    Person1
        UNION ALL
        SELECT  *
        FROM    Person2;
GO -- Run the previous command and begins new batch

SELECT  *
FROM    Person1;
SELECT  *
FROM    Person2;
SELECT  *
FROM    Person3;
GO -- Run the previous command and begins new batch

--========================================================================
--T039_04
--Clean up
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Person1' ) )
    BEGIN
        TRUNCATE TABLE dbo.Person1;
        DROP TABLE Person1;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Person2' ) )
    BEGIN
        TRUNCATE TABLE dbo.Person2;
        DROP TABLE Person2;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Person3' ) )
    BEGIN
        TRUNCATE TABLE dbo.Person3;
        DROP TABLE Person3;
    END;
GO -- Run the previous command and begins new batch





