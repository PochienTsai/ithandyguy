-- T020_CreateLargeData_SubQuery_Join_Performance -----------------------------------------

/*
1.
CHECKPOINT; 
GO 
-- Clears query cache
DBCC DROPCLEANBUFFERS;
GO
-- Clears execution plan cache
DBCC FREEPROCCACHE; 
GO

2.
Random Number
2.1.
RAND([seed])
Reference:
https://docs.microsoft.com/en-us/sql/t-sql/functions/rand-transact-sql
https://www.w3schools.com/sql/func_mysql_rand.asp
Returns a pseudo-random float value from 0 through 1, exclusive.
0 <= ReturnNumber < 1
Same seed always returns the same RAND([seed]) value.
2.2.
FLOOR(RAND()*(b-a)+a);
Where a is the smallest number and b is the largest number that you want to generate a random number for.
Reference:
https://www.techonthenet.com/sql_server/functions/rand.php
PRINT FLOOR(RAND()*(25-10)+10);
10 <= IntNumber < 25

3.
Random DateTime
--Ch25_08
--Get Random DateTime
--Reference: http://crodrigues.com/sql-server-generate-random-datetime-within-a-range/
DECLARE @RandomDateTime DATETIME;
DECLARE @DateFrom DATETime = '2012-01-01'
DECLARE @DateTo DATeTime = '2017-06-30'
DECLARE @DaysRandom Int= 0
DECLARE @MillisRandom Int=0
--get random number of days
select @DaysRandom= DATEDIFF(day,@DateFrom,@DateTo)
SELECT @DaysRandom = ROUND(((@DaysRandom -1) * RAND()), 0)
--get random millis
SELECT @MillisRandom = ROUND(((99999999) * RAND()), 0)
SELECT @RandomDateTime = DATEADD(day, @DaysRandom, @DateFrom)
SELECT @RandomDateTime = DATEADD(MILLISECOND, @MillisRandom, @RandomDateTime)
SELECT @RandomDateTime

4.
Theoretically, joins is faster than sub-queries.
In reality, SQL Server always transforms query on an execution plan. 
If sql server generates the same execution plan from both queries, 
then it will return the same result.
It is alwys better to do real testing and make a decision. 
*/

--========================================================================
--T020_01_Create Sample Data
--========================================================================

IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'BookShoppingCart' ) )
    BEGIN
        TRUNCATE TABLE BookShoppingCart;
        DROP TABLE BookShoppingCart;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Book' ) )
    BEGIN
        TRUNCATE TABLE Book;
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
 );
GO -- Run the previous command and begins new batch
INSERT  INTO Book
VALUES  ( 'Book1', 10, 'BookDesc1' );
INSERT  INTO Book
VALUES  ( 'Book2', 20, 'BookDesc2' );
INSERT  INTO Book
VALUES  ( 'Book3', 30, 'BookDesc3' );
GO -- Run the previous command and begins new batch
CREATE TABLE BookShoppingCart
    (
      BookShoppingCartID INT PRIMARY KEY
                                 IDENTITY(1, 1)
                                 NOT NULL ,
      BookID INT FOREIGN KEY REFERENCES Book ( [BookID] )
                     NOT NULL ,
      CreatedDateTime DATETIME NULL ,
      Quantity INT NULL,
    )
GO -- Run the previous command and begins new batch
INSERT  INTO BookShoppingCart
VALUES  ( 1, '2012-08-31 20:15:04.123', 2 );
INSERT  INTO BookShoppingCart
VALUES  ( 2, '2013-04-25 07:17:05.543', 5 );
INSERT  INTO BookShoppingCart
VALUES  ( 2, '2015-07-01 12:15:04.667', 4 );
INSERT  INTO BookShoppingCart
VALUES  ( 2, '2015-09-19 20:19:04.588', 7 );
GO -- Run the previous command and begins new batch
SELECT  *
FROM    Book;
SELECT  *
FROM    BookShoppingCart;
GO -- Run the previous command and begins new batch

--========================================================================
--T020_02_Get the book that has never been sold
--========================================================================

--========================================================================
--T020_02_01
--GET the book that has never been sold - SubQuery
SELECT  b.BookID ,
        b.BookName ,
        b.BookUnitPrice ,
        b.[Description]
FROM    Book b
WHERE   b.BookID NOT IN ( SELECT DISTINCT
                                    bsc.BookID
                          FROM      BookShoppingCart bsc );
GO -- Run the previous command and begins new batch

--========================================================================
--T020_02_02
--Get the book that has never been sold - JOIN
SELECT  b.BookID ,
        b.BookName ,
        b.BookUnitPrice ,
        b.[Description]
FROM    Book b
        LEFT JOIN BookShoppingCart bsc ON b.BookID = bsc.BookID
WHERE   bsc.BookID IS NULL;
GO -- Run the previous command and begins new batch
/*
Reference:
https://technet.microsoft.com/en-us/library/ms189575(v=sql.105).aspx
subqueries can be nested upto 32 levels.
*/

--========================================================================
--T020_03_CorrelatedSubquery V.S. NonCorrelatedSubquery
--========================================================================

--========================================================================
--T020_03_01
--non-corelated sub-query
SELECT  b.BookID ,
        b.BookName ,
        b.BookUnitPrice ,
        b.[Description]
FROM    Book b
WHERE   b.BookID NOT IN ( SELECT DISTINCT
                                    bsc.BookID
                          FROM      BookShoppingCart bsc ); 
GO -- Run the previous command and begins new batch
/*
A non-corelated sub-query can be executed independently.
E.g.
--SELECT DISTINCT bsc.BookID
--FROM   BookShoppingCart bsc
*/


--========================================================================
--T020_03_02
--corelated sub-query
SELECT  b.BookID ,
        b.BookName ,
        ( SELECT    SUM(bsc.Quantity)
          FROM      BookShoppingCart bsc
          WHERE     b.BookID = bsc.BookID
        ) AS TotalOrderQuantity
FROM    Book b
ORDER BY b.BookName; 
GO -- Run the previous command and begins new batch
/*
A corelated sub-query can NOT be executed independently, 
because sub-query depends on the value of outer query.
E.g.
--SELECT    SUM(bsc.Quantity)
--FROM      BookShoppingCart bsc
--WHERE     b.BookID = bsc.BookID
*/


--========================================================================
--T020_04_PerformanceTesting
--========================================================================

--========================================================================
--T020_04_01
--Create large amount of data


--T020_04_01_01
--Create Table
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'BookShoppingCart' ) )
    BEGIN
        DROP TABLE BookShoppingCart;
    END;
GO -- Run the previous command and begins new batch
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
 );
GO -- Run the previous command and begins new batch
CREATE TABLE BookShoppingCart
(
  BookShoppingCartID INT PRIMARY KEY
                         IDENTITY(1, 1)
                         NOT NULL ,
  BookID INT FOREIGN KEY REFERENCES Book ( [BookID] )
             NOT NULL ,
  CreatedDateTime DATETIME NULL ,
  Quantity INT NULL,
 );
GO -- Run the previous command and begins new batch

--------------------------------------------
--T020_04_01_02
--Insert to Book
--Whole T020_04_01 part need to execute together.

--Book Counter
DECLARE @TotalBookRows INT = 300000;
DECLARE @BookCount INT = 1;
-- random UnitPrice between 1 and 100
DECLARE @RandomUnitPrice MONEY;
DECLARE @BookUnitPrice_Max INT;
DECLARE @BookUnitPrice_Min INT;
SET @BookUnitPrice_Min = 1;
SET @BookUnitPrice_Max = 100;

WHILE ( @BookCount <= @TotalBookRows )
    BEGIN
        SELECT  @RandomUnitPrice = FLOOR(RAND() * ( @BookUnitPrice_Max
                                                    - @BookUnitPrice_Min )
                                         + @BookUnitPrice_Min);
        INSERT  INTO Book
        VALUES  ( 'Book ' + CAST(@BookCount AS NVARCHAR(20)),
                  @RandomUnitPrice,
                  'Book Description ' + CAST(@BookCount AS NVARCHAR(20)) );
        PRINT @BookCount;
        SET @BookCount += 1;
    END;
/*
1.
Random Number
1.1.
RAND([seed])
Reference:
https://docs.microsoft.com/en-us/sql/t-sql/functions/rand-transact-sql
https://www.w3schools.com/sql/func_mysql_rand.asp
Returns a pseudo-random float value from 0 through 1, exclusive.
0 <= ReturnNumber < 1
Same seed always returns the same RAND([seed]) value.
1.2.
FLOOR(RAND()*(b-a)+a);
Where a is the smallest number and b is the largest number that you want to generate a random number for.
Reference:
https://www.techonthenet.com/sql_server/functions/rand.php
PRINT FLOOR(RAND()*(25-10)+10);
10 <= IntNumber < 25

2.
Random DateTime
--Ch25_08
--Get Random DateTime
--Reference: http://crodrigues.com/sql-server-generate-random-datetime-within-a-range/
DECLARE @RandomDateTime DATETIME;
DECLARE @DateFrom DATETime = '2012-01-01'
DECLARE @DateTo DATeTime = '2017-06-30'
DECLARE @DaysRandom Int= 0
DECLARE @MillisRandom Int=0
--get random number of days
select @DaysRandom= DATEDIFF(day,@DateFrom,@DateTo)
SELECT @DaysRandom = ROUND(((@DaysRandom -1) * RAND()), 0)
--get random millis
SELECT @MillisRandom = ROUND(((99999999) * RAND()), 0)
SELECT @RandomDateTime = DATEADD(day, @DaysRandom, @DateFrom)
SELECT @RandomDateTime = DATEADD(MILLISECOND, @MillisRandom, @RandomDateTime)
SELECT @RandomDateTime
*/


--------------------------------------------
--T020_04_01_02
--Insert sample data to [BookShoppingCart] table
--Whole T020_04_01 part need to execute together.

--BookShoppingCart Counter
DECLARE @TotalBookShoppingCartRows INT;
DECLARE @BookShoppingCartCount INT;
SET @BookShoppingCartCount = 1;
SET @TotalBookShoppingCartRows = 400000;

-- @RandomBookID
DECLARE @RandomBookID INT;
DECLARE @RandomBookID_Max INT;
DECLARE @RandomBookID_Min INT;
SET @RandomBookID_Min = 1;
SET @RandomBookID_Max = @TotalBookRows - 100;
--Should be @RandomBookID_Max = @TotalBookRows, 
--but I purposely set  @RandomBookID_Max = @TotalBookRows-100
--I want some book data that was never sold.

--@RandomCreatedDateTime
--Reference: http://crodrigues.com/sql-server-generate-random-datetime-within-a-range/
DECLARE @RandomCreatedDateTime DATETIME;
DECLARE @DateFrom DATETIME = '2012-01-01';
DECLARE @DateTo DATETIME = '2017-06-30';
DECLARE @DaysRandom INT= 0;
DECLARE @MillisRandom INT= 0;

-- @RandomQuantity is between 1 to 10
DECLARE @RandomQuantity INT;
DECLARE @RandomQuantity_Max INT;
DECLARE @RandomQuantity_Min INT;
SET @RandomQuantity_Min = 1;
SET @RandomQuantity_Max = 10;

WHILE ( @BookShoppingCartCount <= @TotalBookShoppingCartRows )
    BEGIN
		--1. @RandomBookID
        SELECT  @RandomBookID = FLOOR(RAND() * ( @RandomBookID_Max
                                                 - @RandomBookID_Min )
                                      + @RandomBookID_Min);
		--2. @RandomQuantity
        SELECT  @RandomQuantity = FLOOR(RAND() * ( @RandomQuantity_Max
                                                   - @RandomQuantity_Min )
                                        + @RandomQuantity_Min);
		--3. @RandomCreatedDateTime
		--get random number of days 
        SELECT  @DaysRandom = DATEDIFF(DAY, @DateFrom, @DateTo);
        SELECT  @DaysRandom = ROUND(( ( @DaysRandom - 1 ) * RAND() ), 0);
		--get random millis
        SELECT  @MillisRandom = ROUND(( ( 99999999 ) * RAND() ), 0);
        SELECT  @RandomCreatedDateTime = DATEADD(DAY, @DaysRandom, @DateFrom);
        SELECT  @RandomCreatedDateTime = DATEADD(MILLISECOND, @MillisRandom,
                                                 @RandomCreatedDateTime);

        INSERT  INTO BookShoppingCart
        VALUES  ( @RandomBookID, @RandomCreatedDateTime, @RandomQuantity );

        PRINT @BookShoppingCartCount;
        SET @BookShoppingCartCount += 1;
    END;
GO -- Run the previous command and begins new batch

--========================================================================
--T020_04_02
SELECT  *
FROM    Book;
SELECT  *
FROM    BookShoppingCart;
GO -- Run the previous command and begins new batch

--========================================================================
--T020_05_SubQuery V.S. JoinsPerformance
--========================================================================

--========================================================================
--T020_05_01
--Compare Join V.S. SubQuery
SELECT  b.BookID ,
        b.BookName ,
        b.BookUnitPrice ,
        b.[Description]
FROM    Book b
WHERE   b.BookID IN ( SELECT    bsc.BookID
                      FROM      BookShoppingCart bsc ); 
GO -- Run the previous command and begins new batch
/*
Run 221073 rows in 1 second.
*/

CHECKPOINT; 
GO -- Run the previous command and begins new batch
-- Clears query cache
DBCC DROPCLEANBUFFERS;
GO -- Run the previous command and begins new batch
-- Clears execution plan cache
DBCC FREEPROCCACHE; 
GO -- Run the previous command and begins new batch

SELECT DISTINCT
        b.BookID ,
        b.BookName ,
        b.BookUnitPrice ,
        b.[Description]
FROM    Book b
        INNER JOIN BookShoppingCart bsc ON b.BookID = bsc.BookID;
GO -- Run the previous command and begins new batch
/*
Run 221073 rows in 1 second.
*/

CHECKPOINT; 
GO -- Run the previous command and begins new batch
-- Clears query cache
DBCC DROPCLEANBUFFERS;
GO -- Run the previous command and begins new batch
-- Clears execution plan cache
DBCC FREEPROCCACHE; 
GO -- Run the previous command and begins new batch


--========================================================================
--T020_05_02
--Compare Join V.S. SubQuery

/*
Theoretically, joins is faster than sub-queries.
In reality, SQL Server always transforms query on an execution plan. 
If sql server generates the same execution plan from both queries, 
then it will return the same result.
It is alwys better to do real testing and make a decision. 
*/

SELECT  b.BookID ,
        b.BookName ,
        b.BookUnitPrice ,
        b.[Description]
FROM    Book b
WHERE   b.BookID NOT IN ( SELECT    bsc.BookID
                      FROM      BookShoppingCart bsc ); 
GO -- Run the previous command and begins new batch
/*
Run 78927 rows less than 1 second.
*/

CHECKPOINT; 
GO -- Run the previous command and begins new batch
-- Clears query cache
DBCC DROPCLEANBUFFERS;
GO -- Run the previous command and begins new batch
-- Clears execution plan cache
DBCC FREEPROCCACHE; 
GO -- Run the previous command and begins new batch

SELECT DISTINCT
        b.BookID ,
        b.BookName ,
        b.BookUnitPrice ,
        b.[Description]
FROM    Book b
        LEFT JOIN BookShoppingCart bsc ON b.BookID = bsc.BookID
WHERE   bsc.BookID IS NULL; 
GO -- Run the previous command and begins new batch
/*
Run 78927 rows less than 1 second.
*/

CHECKPOINT; 
GO -- Run the previous command and begins new batch
-- Clears query cache
DBCC DROPCLEANBUFFERS;
GO -- Run the previous command and begins new batch
-- Clears execution plan cache
DBCC FREEPROCCACHE; 
GO -- Run the previous command and begins new batch

--========================================================================
--T020_06_Clean up
--========================================================================

--Clean up
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'BookShoppingCart' ) )
    BEGIN
        DROP TABLE BookShoppingCart;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Book' ) )
    BEGIN
        DROP TABLE Book;
    END;
GO -- Run the previous command and begins new batch
