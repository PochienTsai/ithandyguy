-- T033_DebuggingStoredProcedures ---------------------------------------

--======================================================================
--T033_01
--spPrintSmallerOrEqualNumber

--Drop Store Procedure exists then DROP it
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.ROUTINES
              WHERE     ROUTINE_TYPE = 'PROCEDURE'
                        AND LEFT(ROUTINE_NAME, 3) NOT IN ( 'sp_', 'xp_', 'ms_' )
                        AND SPECIFIC_NAME = 'spPrintSmallerOrEqualNumber' ) )
    BEGIN
        DROP PROCEDURE spPrintSmallerOrEqualNumber;
    END;
GO -- Run the previous command and begins new batch
CREATE PROCEDURE spPrintSmallerOrEqualNumber ( @Target INT )
AS
    BEGIN
        DECLARE @Count INT;
        SET @Count = 1;
		--** Logic error here
		WHILE (@Count < @Target )
		BEGIN
			PRINT @Count;
			SET @Count+=1
        END
        PRINT 'Finished spPrintSmallerOrEqualNumber, Target = ' + RTRIM(@Target);
    END;
GO -- Run the previous command and begins new batch

/*
1.
Open 2 query window.
Run T033_01 to build spPrintSmallerOrEqualNumber in Query Window 1.
Once you finised, close the Query Window 1.
In the Query Window 2, 
we will run   T033_02
2.
spPrintSmallerOrEqualNumber should print all the integers 
which is less than or equal to the input target value. 
E.g.
When target==5
it suppose to print as following.
--1
--2
--3
--4
--5
--Finished spPrintSmallerOrEqualNumber, Target = 5
However, we make mistake here
--WHILE (@Count < @Target )
Thus, it actually print as following
--1
--2
--3
--4
--Finished spPrintSmallerOrEqualNumber, Target = 5
We will go through some debug processes with debug tools.
Then we will find out the correct code should be ..
--WHILE (@Count <= @Target )
Let's go through some debug processes with debug tools from now.
*/

--======================================================================
--T033_02
--Debug spPrintSmallerOrEqualNumber
DECLARE @Target INT
SET @Target = 5
EXECUTE spPrintSmallerOrEqualNumber @Target
Print 'Finished'

/*
1.
Open 2 query window.
Run T033_01 to build spPrintSmallerOrEqualNumber in Query Window 1.
Once you finised, close the Query Window 1.
In the Query Window 2, 
we will run   T033_02
2.
Let's go through some debug processes with debug tools from now. 
*/

--======================================================================
--T033_03
--Corrent spPrintSmallerOrEqualNumber

--Drop Store Procedure exists then DROP it
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.ROUTINES
              WHERE     ROUTINE_TYPE = 'PROCEDURE'
                        AND LEFT(ROUTINE_NAME, 3) NOT IN ( 'sp_', 'xp_', 'ms_' )
                        AND SPECIFIC_NAME = 'spPrintSmallerOrEqualNumber' ) )
    BEGIN
        DROP PROCEDURE spPrintSmallerOrEqualNumber;
    END;
GO -- Run the previous command and begins new batch
CREATE PROCEDURE spPrintSmallerOrEqualNumber ( @Target INT )
AS
    BEGIN
        DECLARE @Count INT;
        SET @Count = 1;
		--** Logic error here
		WHILE (@Count <= @Target )
		BEGIN
			PRINT @Count;
			SET @Count+=1
        END
        PRINT 'Finished spPrintSmallerOrEqualNumber, Target = ' + RTRIM(@Target);
    END;
GO -- Run the previous command and begins new batch

/*
The correct spPrintSmallerOrEqualNumber
*/


--======================================================================
--T033_04
--Clean up

--Drop Store Procedure exists then DROP it
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.ROUTINES
              WHERE     ROUTINE_TYPE = 'PROCEDURE'
                        AND LEFT(ROUTINE_NAME, 3) NOT IN ( 'sp_', 'xp_', 'ms_' )
                        AND SPECIFIC_NAME = 'spPrintSmallerOrEqualNumber' ) )
    BEGIN
        DROP PROCEDURE spPrintSmallerOrEqualNumber;
    END;
GO -- Run the previous command and begins new batch

