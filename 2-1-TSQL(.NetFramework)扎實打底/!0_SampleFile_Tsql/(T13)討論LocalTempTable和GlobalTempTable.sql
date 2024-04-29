-- T013_(Local_Global)TemporaryTables -----------------------------------------------------

/*
In Summary
1.
Local Temp Table V.S. Global Temp Table
Databases --> System Databases --> tempdb --> 
Temporary Tables --> #LocalTempTable/##GlobalTempTable
1.1.
#LocalTempTable
1.1.1.
Prefix with One pound (#) symbol.  E.g. #LocalTempTable
1.1.2.
SQL server appends a long underscore and some random numbers.
E.g. 
#Person__________________________________________000000000195
1.1.3.
#LocalTempTable is available for current connection/session/query window/query file.
It is automatically dropped after closing the current connection/session/query window/query file.
1.1.4.
#LocalTempTable will be automatically dropped 
on the completion of stored procedure execution.

----------
1.2.
##GlobalTempTable
1.2.1.
Prefix with Double pound (##) symbol.  E.g. ##GlobalTempTable
1.2.2.
SQL server will give a Table Name without appending any random number.
E.g.
dbo.##Person3
1.2.3.
##GlobalTempTable is available for any connection/session/query window/query file.
It is automatically dropped after closing the ALL connection/session/query window/query file.
1.2..4.
##GlobalTempTable will NOT be automatically dropped 
on the completion of stored procedure execution.
*/

--=============================================================================
--T013_01_ReCreate Table V.S. Global/Local TempTable
--=============================================================================

--=============================================================================
--T013_01_01
--Create or Recreate table
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Person1' ) )
    BEGIN
        TRUNCATE TABLE Person1;
        DROP TABLE Person1;
    END;
GO -- Run the previous command and begins new batch
CREATE TABLE Person1
(
  Id INT IDENTITY(1, 1)
         PRIMARY KEY
         NOT NULL ,
  Name NVARCHAR(20) NULL
);

--=============================================================================
--T013_01_02
--Create or Recreate Local TempTable

--From SQL Server 2016 you can just use
DROP TABLE IF EXISTS #Person2
CREATE TABLE #Person2
(
  Id INT IDENTITY(1, 1)
         PRIMARY KEY
         NOT NULL ,
  Name NVARCHAR(20) NULL
);

--From Previous version of SQL server
IF OBJECT_ID('tempdb..#Person2') IS NOT NULL
    BEGIN
        TRUNCATE TABLE #Person2;
        DROP TABLE #Person2;
    END;
GO -- Run the previous command and begins new batch
CREATE TABLE #Person2
(
  Id INT IDENTITY(1, 1)
         PRIMARY KEY
         NOT NULL ,
  Name NVARCHAR(20) NULL
);

--Check temp table information
SELECT  *
FROM    tempdb..sysobjects
WHERE   name LIKE '#Person2%';
GO -- Run the previous command and begins new batch

--=============================================================================
--T013_01_03
--Create or Recreate Global TempTable

--From SQL Server 2016 you can just use
DROP TABLE IF EXISTS ##Person3
CREATE TABLE ##Person3
(
  Id INT IDENTITY(1, 1)
         PRIMARY KEY
         NOT NULL ,
  Name NVARCHAR(20) NULL
);

--From Previous version of SQL server
IF OBJECT_ID('tempdb..##Person3') IS NOT NULL
    BEGIN
        TRUNCATE TABLE ##Person3;
        DROP TABLE ##Person3;
    END;
GO -- Run the previous command and begins new batch
CREATE TABLE ##Person3
(
  Id INT IDENTITY(1, 1)
         PRIMARY KEY
         NOT NULL ,
  Name NVARCHAR(20) NULL
);

--Check temp table information
SELECT  *
FROM    tempdb..sysobjects
WHERE   name LIKE '##Person3%';
GO -- Run the previous command and begins new batch

--=============================================================================
--T013_02_Select/Insert Global/Local TempTable
--=============================================================================

--=============================================================================
--T013_02_01
--Local Temp Table
INSERT  INTO #Person2
VALUES  ( 'P2Name1' );
INSERT  INTO #Person2
VALUES  ( 'P2Name2' );
INSERT  INTO #Person2
VALUES  ( 'P2Name3' );

SELECT  *
FROM    #Person2;

SELECT  name
FROM    tempdb..sysobjects
WHERE   name LIKE '#Person2%';
GO -- Run the previous command and begins new batch

--=============================================================================
--T013_02_02
--Global Temp Table
INSERT  INTO ##Person3
VALUES  ( 'P3Name1' );
INSERT  INTO ##Person3
VALUES  ( 'P3Name2' );
INSERT  INTO ##Person3
VALUES  ( 'P3Name3' );

SELECT  *
FROM    ##Person3;

SELECT  name
FROM    tempdb..sysobjects
WHERE   name LIKE '##Person3%';
GO -- Run the previous command and begins new batch


--=============================================================================
--T013_03_Global/Local TempTable with Stored Procedure
--=============================================================================


--=============================================================================
--T013_03_01
--Local TempTable in Stored Procedure
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.ROUTINES
              WHERE     ROUTINE_TYPE = 'PROCEDURE'
                        AND LEFT(ROUTINE_NAME, 3) NOT IN ( 'sp_', 'xp_', 'ms_' )
                        AND SPECIFIC_NAME = 'spLocalTempTable' ) )
    BEGIN
        DROP PROCEDURE spLocalTempTable;
    END;
GO -- Run the previous command and begins new batch
CREATE PROCEDURE spLocalTempTable
AS
    BEGIN

        IF OBJECT_ID('tempdb..#Person4') IS NOT NULL
            BEGIN
                TRUNCATE TABLE #Person4;
                DROP TABLE #Person4;
            END;
        CREATE TABLE #Person4
        (
          Id INT IDENTITY(1, 1)
                 PRIMARY KEY
                 NOT NULL ,
          Name NVARCHAR(20) NULL
        );
        INSERT  INTO #Person4
        VALUES  ( 'spP4Name1' );
        INSERT  INTO #Person4
        VALUES  ( 'spP4Name2' );
        INSERT  INTO #Person4
        VALUES  ( 'spP4Name3' );

        SELECT  *
        FROM    #Person4;
    END;
GO -- Run the prvious command and begins new batch

EXECUTE spLocalTempTable;
GO -- Run the prvious command and begins new batch
/*
1.
#LocalTempTable will NOT be automatically dropped 
on the completion of stored procedure execution.
2.
--Execute spLocalTempTable
returns something
*/

--=============================================================================
--T013_03_02
--Global TempTable in Stored Procedure
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.ROUTINES
              WHERE     ROUTINE_TYPE = 'PROCEDURE'
                        AND LEFT(ROUTINE_NAME, 3) NOT IN ( 'sp_', 'xp_', 'ms_' )
                        AND SPECIFIC_NAME = 'spGlobalTempTable' ) )
    BEGIN
        DROP PROCEDURE spGlobalTempTable;
    END;
GO -- Run the previous command and begins new batch
CREATE PROCEDURE spGlobalTempTable
AS
    BEGIN

        IF OBJECT_ID('tempdb..##Person5') IS NOT NULL
            BEGIN
                TRUNCATE TABLE ##Person5;
                DROP TABLE ##Person5;
            END;
        CREATE TABLE ##Person5
        (
          Id INT IDENTITY(1, 1)
                 PRIMARY KEY
                 NOT NULL ,
          Name NVARCHAR(20) NULL
        );
        INSERT  INTO ##Person5
        VALUES  ( 'spP3Name1' );
        INSERT  INTO ##Person5
        VALUES  ( 'spP3Name2' );
        INSERT  INTO ##Person5
        VALUES  ( 'spP3Name3' );

        SELECT  *
        FROM    ##Person5;
    END;
GO -- Run the prvious command and begins new batch

EXECUTE spGlobalTempTable;
GO -- Run the prvious command and begins new batch
/*
1.
##GlobalTempTable will NOT be automatically dropped 
on the completion of stored procedure execution.
2.
--Execute spGlobalTempTable
returns something.
*/

--=============================================================================
--T013_04_Clean up
--=============================================================================
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Person1' ) )
    BEGIN
        TRUNCATE TABLE Person1;
        DROP TABLE Person1;
    END;
GO -- Run the previous command and begins new batch
--------------------------------------------------------------------
--From Previous version of SQL server
IF OBJECT_ID('tempdb..#Person2') IS NOT NULL
    BEGIN
        TRUNCATE TABLE #Person2;
        DROP TABLE #Person2;
    END;
GO -- Run the previous command and begins new batch
--From Previous version of SQL server
IF OBJECT_ID('tempdb..##Person3') IS NOT NULL
    BEGIN
        TRUNCATE TABLE ##Person3;
        DROP TABLE ##Person3;
    END;
GO -- Run the previous command and begins new batch
--From Previous version of SQL server
IF OBJECT_ID('tempdb..#Person4') IS NOT NULL
    BEGIN
        TRUNCATE TABLE #Person4;
        DROP TABLE #Person4;
    END;
GO -- Run the previous command and begins new batch
--From Previous version of SQL server
IF OBJECT_ID('tempdb..##Person5') IS NOT NULL
    BEGIN
        TRUNCATE TABLE ##Person5;
        DROP TABLE ##Person5;
    END;
GO -- Run the previous command and begins new batch
--------------------------------------------------------------------
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.ROUTINES
              WHERE     ROUTINE_TYPE = 'PROCEDURE'
                        AND LEFT(ROUTINE_NAME, 3) NOT IN ( 'sp_', 'xp_', 'ms_' )
                        AND SPECIFIC_NAME = 'spLocalTempTable' ) )
    BEGIN
        DROP PROCEDURE spLocalTempTable;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.ROUTINES
              WHERE     ROUTINE_TYPE = 'PROCEDURE'
                        AND LEFT(ROUTINE_NAME, 3) NOT IN ( 'sp_', 'xp_', 'ms_' )
                        AND SPECIFIC_NAME = 'spGlobalTempTable' ) )
    BEGIN
        DROP PROCEDURE spGlobalTempTable;
    END;
GO -- Run the previous command and begins new batch


