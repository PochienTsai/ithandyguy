-- T036_PageNumber_OffsetN1RowsFetchNextN2RowsOnly -------------------------------------

/*
OFFSET n1 ROWS
FETCH NEXT n2 ROWS ONLY
1.
OffsetFetchNext Syntax:
--SELECT  *
--FROM    TableName
--ORDER BY C1,C2,...
--        OFFSET RowsToSkip ROWS
--FETCH NEXT RowsToFetch ROWS ONLY
ORDER BY clause is compulsory.
OffsetFetchNext is normally used in 
returning a page/sub-set of results.
----------------------
1.2.
E.g.
--SELECT  *
--FROM    Book
--ORDER BY BookID
--        OFFSET 20 ROWS
--FETCH NEXT 10 ROWS ONLY
The 1st BookID is 1.
Offset 20 rows from BookID=1  will be BookID=21.
Start from BookID=21, fetch next 10 rows.
Thus, this will return from from ID=21 to ID=30
----------------------
1.2.
spGetRowsByPageNumberAndSize receive 
the PAGE NUMBER and the PAGE SIZE to get a page of rows. 
E.g.
--IF ( EXISTS ( SELECT    *
--              FROM      INFORMATION_SCHEMA.ROUTINES
--              WHERE     ROUTINE_TYPE = 'PROCEDURE'
--                        AND LEFT(ROUTINE_NAME, 3) NOT IN ( 'sp_', 'xp_', 'ms_' )
--                        AND SPECIFIC_NAME = 'spGetRowsByPageNumberAndSize' ) )
--    BEGIN
--        DROP PROCEDURE spGetRowsByPageNumberAndSize;
--    END;
--GO -- Run the previous command and begins new batch
--CREATE PROCEDURE spGetRowsByPageNumberAndSize
--    (
--      @PageNumber INT ,
--      @PageSize INT
--    )
--AS
--    BEGIN
--        SELECT  *
--        FROM    Book
--        ORDER BY BookID
--                OFFSET ( @PageNumber - 1 ) * @PageSize ROWS
--    FETCH NEXT @PageSize ROWS ONLY;
--    END;
--GO -- Run the previous command and begins new batch
----Test it
--EXECUTE spGetRowsByPageNumberAndSize 4, 10; 
--GO -- Run the previous command and begins new batch
*/


--=====================================================================
--T036_01
--Create Sample Data
--Revise Ch61_PerformanceTesting - Create large amount of test data
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Book' ) )
    BEGIN
        DROP TABLE Book;
    END;
GO -- Run the previous command and begins new batch
CREATE TABLE Book
    (
      BookID INT PRIMARY KEY
                 IDENTITY(1, 1)
                 NOT NULL ,
      BookName NVARCHAR(100) NULL ,
      BookUnitPrice MONEY NULL ,
      [Description] NVARCHAR(1000) NULL,
    )
ON  [PRIMARY];

-------------------
--Insert sample data to Book table
--Book Counter
DECLARE @TotalBookRows INT = 100;
DECLARE @BookCount INT = 1;
-- random UnitPrice between 1 and 100
DECLARE @RandomUnitPrice MONEY;
DECLARE @BookUnitPrice_Max INT = 100;
DECLARE @BookUnitPrice_Min INT = 1;
--Loop
WHILE ( @BookCount <= @TotalBookRows )
    BEGIN
        SELECT  @RandomUnitPrice = FLOOR(RAND() * ( @BookUnitPrice_Max
                                                    - @BookUnitPrice_Min )
                                         + @BookUnitPrice_Min);
        INSERT  INTO Book
        VALUES  ( 'Book ' + CAST(@BookCount AS NVARCHAR(20)), @RandomUnitPrice,
                  'Book Description ' + CAST(@BookCount AS NVARCHAR(20)) );
        PRINT @BookCount;
        SET @BookCount += 1;
    END;
GO -- Run the previous command and begins new batch
--------------------
SELECT  *
FROM    Book;
GO -- Run the previous command and begins new batch

--=====================================================================
--T036_02
--OFFSET n1 ROWS
--FETCH NEXT n2 ROWS ONLY
--Return from ID=21 to ID=30
SELECT  *
FROM    Book
ORDER BY BookID
        OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;
GO -- Run the previous command and begins new batch
/*
1.
OffsetFetchNext Syntax:
--SELECT  *
--FROM    TableName
--ORDER BY C1,C2,...
--        OFFSET RowsToSkip ROWS
--FETCH NEXT RowsToFetch ROWS ONLY
ORDER BY clause is compulsory.
OffsetFetchNext is normally used in 
returning a page/sub-set of results.
1.2.
E.g.
--SELECT  *
--FROM    Book
--ORDER BY BookID
--        OFFSET 20 ROWS
--FETCH NEXT 10 ROWS ONLY
The 1st BookID is 1.
Offset 20 rows from BookID=1  will be BookID=21.
Start from BookID=21, fetch next 10 rows.
Thus, this will return from from ID=21 to ID=30
*/


--=====================================================================
--T036_03
--OFFSET n1 ROWS
--FETCH NEXT n2 ROWS ONLY

--Drop Store Procedure exists then DROP it
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.ROUTINES
              WHERE     ROUTINE_TYPE = 'PROCEDURE'
                        AND LEFT(ROUTINE_NAME, 3) NOT IN ( 'sp_', 'xp_', 'ms_' )
                        AND SPECIFIC_NAME = 'spGetRowsByPageNumberAndSize' ) )
    BEGIN
        DROP PROCEDURE spGetRowsByPageNumberAndSize;
    END;
GO -- Run the previous command and begins new batch
CREATE PROCEDURE spGetRowsByPageNumberAndSize
    (
      @PageNumber INT ,
      @PageSize INT
    )
AS
    BEGIN
        SELECT  *
        FROM    Book
        ORDER BY BookID
                OFFSET ( @PageNumber - 1 ) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    END;
GO -- Run the previous command and begins new batch

--Test it
EXECUTE spGetRowsByPageNumberAndSize 4, 10; 
GO -- Run the previous command and begins new batch

/*
1.
--ORDER BY BookID
--OFFSET ( @PageNumber - 1 ) * @PageSize ROWS
--FETCH NEXT @PageSize ROWS ONLY;
spGetRowsByPageNumberAndSize receive 
the PAGE NUMBER and the PAGE SIZE to get a page of rows. 
The table has 100 rows and Id is from 1 to 100.
1.1.
If @PageNumber=1, @PageSize=10,
then Page 1 will show the first top 10 rows, ID=1 to ID=10,
which means OFFSET 0 FETCH NEXT 10.
1.2.
If @PageNumber=2, @PageSize=10,
then Page 2 will show the second top 10 rows, ID=11 to ID=20
which means OFFSET 10 FETCH NEXT 10.
1.3.
If @PageNumber=3, @PageSize=10,
then Page 3 will show the third top 10 rows, ID=21 to ID=30
which means OFFSET 20 FETCH NEXT 10.
*/

--=====================================================================
--T036_04
--Clean up
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.ROUTINES
              WHERE     ROUTINE_TYPE = 'PROCEDURE'
                        AND LEFT(ROUTINE_NAME, 3) NOT IN ( 'sp_', 'xp_', 'ms_' )
                        AND SPECIFIC_NAME = 'spGetRowsByPageNumberAndSize' ) )
    BEGIN
        DROP PROCEDURE spGetRowsByPageNumberAndSize;
    END;
GO -- Run the previous command and begins new batch

IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Book' ) )
    BEGIN
        DROP TABLE Book;
    END;
GO -- Run the previous command and begins new batch
