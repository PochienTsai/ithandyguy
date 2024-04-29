-- T009_DateTime2_SmallDateTime_EoMonth_DateFromParts_DateTime2FromParts -------------------------

/*
1.
DateTime V.S. SmallDateTime V.S. DateTime2
1.1.
DateTime
1.1.1.
Date Range :
January 1, 1753, through December 31, 9999
1.1.2.
Time Range : 
00:00:00 through 23:59:59.997
1.1.3.
Accuracy : 
3.33 Milli-seconds
1.1.4.
Size :
8 Bytes
1.1.5.
Default value :
1900-01-01 00:00:00
------------------------------------
1.2.
SmallDateTime
1.2.1.
Date Range :
January 1, 1900, through June 6, 2079
1.2.2.
Time Range : 
00:00:00 through 23:59:59
1.2.3.
Accuracy : 
1 Minute
1.2.4.
Size :
4 Bytes
1.2.5.
Default value :
1900-01-01 00:00:00
------------------------------------
1.3.
DateTime2 Syntax:
--DateTime2[(FractionalSecondsPrecision)]
1.3.1.
Date Range :
January 1, 0001, through December 31, 9999
1.3.2.
Time Range : 
00:00:00 through 23:59:59.9999999
1.3.3.
Accuracy : 
100 nanoseconds
1.3.4.
Size :
FractionalSecondsPrecision is optional parameter
and can be 0 to 7 digits.
The default is DateTime2(7).
DateTime2(0) to DateTime2(2) take 6 bytes.
DateTime2(3) to DateTime2(4) take 7 bytes
DateTime2(5) to DateTime2(7) take 8 bytes
1.3.5.
Default value :
1900-01-01 00:00:00
------------------------------------------------------------------

2.
EoMonth Syntax
--EOMONTH(datetime [,monthToAdd])
Reference:
https://docs.microsoft.com/en-us/sql/t-sql/functions/eomonth-transact-sql
EoMonth means End of Month.
It returns the last date of the month.

3.
--DATEFROMPARTS(year,month,day)
--DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision ) 
--SMALLDATETIMEFROMPARTS ( year, month, day, hour, minute )
--TIMEFROMPARTS( hour, minute, seconds, fractions, precision ) 
--DATETIMEOFFSETFROMPARTS ( year, month, day, hour, minute, seconds, fractions, hour_offset, minute_offset, precision )
Reference:
https://docs.microsoft.com/en-us/sql/t-sql/functions/datefromparts-transact-sql
The function with invalid argument valuse will return an error.
If any of the arguments are NULL, then the function returns null.
3.1.
DateFromParts Syntax : 
--DATEFROMPARTS(year,month,day)
Returns a date value.
3.2.
DatetimeFromParts Syntax : 
--DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision ) 
Returns a datetime2 value.
3.3.
SmallDateTimeFromParts Syntax :
--SMALLDATETIMEFROMPARTS ( year, month, day, hour, minute )
Returns a SmallDateTime value.
3.4.
TimeFromParts Syntax :
--TIMEFROMPARTS( hour, minute, seconds, fractions, precision ) 
Returns a Time value.
3.5.
DateTimeOffsetFromParts Syntax : 
--DATETIMEOFFSETFROMPARTS ( year, month, day, hour, minute, seconds, fractions, hour_offset, minute_offset, precision )
Returns a DateTimeOffset value.
*/

--==========================================================================
--T009_01_EoMonthFunction
--==========================================================================

/*
--EOMONTH(datetime [,monthToAdd])
End of Month Syntax
It returns the last date of the month.
*/

--==========================================================================
--T009_01_01
--EOMONTH(datetime [,monthToAdd])
--Last day of the Month of the LEAP year
SELECT  EOMONTH('2/15/2016') AS [EoMonth];
--2016-02-29
DECLARE @EoMonth1 DATETIME = EOMONTH('2/15/2016');
PRINT @EoMonth1;
--Feb 29 2016 12:00AM
GO -- Run the previous command and begins new batch

--==========================================================================
--T009_01_02
--EOMONTH(datetime [,monthToAdd])
--Last day of the Month of the NON-LEAP year
SELECT  EOMONTH('2/15/2015') AS [EoMonth];
--2015-02-28
DECLARE @EoMonth1 DATETIME = EOMONTH('2/15/2015');
PRINT @EoMonth1;
--Feb 28 2015 12:00AM
GO -- Run the previous command and begins new batch

--==========================================================================
--T009_01_03
--EOMONTH(datetime [,monthToAdd])
--Add (monthToAdd) Months and return last day of that month.
SELECT  EOMONTH('2/15/2015', 2) AS [EoMonth];
--2015-04-30
DECLARE @EoMonth1 DATETIME = EOMONTH('2/15/2015', 2);
PRINT @EoMonth1;
--Apr 30 2015 12:00AM
GO -- Run the previous command and begins new batch

--==========================================================================
--T009_01_04
--EOMONTH(datetime [,monthToAdd])
--Add (monthToAdd) Months and return last day of that month.
SELECT  EOMONTH('2/15/2015', -2) AS [EoMonth];
--2014-12-31
DECLARE @EoMonth1 DATETIME = EOMONTH('2/15/2015', -2);
PRINT @EoMonth1;
--Dec 31 2014 12:00AM
GO -- Run the previous command and begins new batch

--==========================================================================
--T009_01_05
--EOMONTH(datetime [,monthToAdd]) return the last date of the month.
--DATEPART(DD,EOMONTH(DateOfBirth [,monthToAdd]))  returns the last day.

---------------------------------------------------------------------
--T009_01_05_01
--SELECT...
SELECT  EOMONTH('2/15/2016') AS [EoMonth];
--2016-02-29
SELECT  DATEPART(DD, EOMONTH('2/15/2016')) AS [EoMonth];
--29
SELECT  EOMONTH('2/15/2015') AS [EoMonth];
--2015-02-28
SELECT  DATEPART(DD, EOMONTH('2/15/2015')) AS [EoMonth];
--28
SELECT  EOMONTH('2/15/2015', 2) AS [EoMonth];
--2015-04-30
SELECT  DATEPART(DD, EOMONTH('2/15/2015', 2)) AS [EoMonth];
--30
SELECT  EOMONTH('2/15/2015', -2) AS [EoMonth];
--2014-12-31
SELECT  DATEPART(DD, EOMONTH('2/15/2015', -2)) AS [EoMonth];
--31
GO -- Run the previous command and begins new batch

---------------------------------------------------------------------
--T009_01_05_02
--PRINT...
DECLARE @EoMonth1 DATETIME = EOMONTH('2/15/2016');
PRINT @EoMonth1;
--Feb 29 2016 12:00AM
DECLARE @EoMonthStr1 NVARCHAR(20) = DATEPART(DD, EOMONTH('2/15/2016'));
PRINT @EoMonthStr1
--29
DECLARE @EoMonth2 DATETIME = EOMONTH('2/15/2015');
PRINT @EoMonth2;
--Feb 28 2015 12:00AM
DECLARE @EoMonthStr2 NVARCHAR(20) = DATEPART(DD, EOMONTH('2/15/2015'));
PRINT @EoMonthStr2
--28
DECLARE @EoMonth3 DATETIME = EOMONTH('2/15/2015', 2);
PRINT @EoMonth3;
--Apr 30 2015 12:00AM
DECLARE @EoMonthStr3 NVARCHAR(20) = DATEPART(DD, EOMONTH('2/15/2015', 2));
PRINT @EoMonthStr3
--30
DECLARE @EoMonth4 DATETIME = EOMONTH('2/15/2015', -2);
PRINT @EoMonth4;
--Dec 31 2014 12:00AM
DECLARE @EoMonthStr4 NVARCHAR(20) = DATEPART(DD, EOMONTH('2/15/2015', -2));
PRINT @EoMonthStr4
--31
GO -- Run the previous command and begins new batch


--==========================================================================
--T009_02_DateTime V.S. SmallDateTime V.S. DateTime2
--==========================================================================



--==========================================================================
--T009_02_01 
--SmallDateTime Range is between January 1, 1900 and June 6, 2079

-----------------------------------------------------------------------------
--T009_02_01_01
DECLARE @SmallDateTime1 SMALLDATETIME = CONVERT(SMALLDATETIME, '01/01/1990')
PRINT @SmallDateTime1
GO -- Run the previous command and begins new batch
--Jan  1 1990 12:00AM

-----------------------------------------------------------------------------
--T009_02_01_02
DECLARE @SmallDateTime1 SMALLDATETIME = CONVERT(SMALLDATETIME, '06/05/2079')
PRINT @SmallDateTime1
GO -- Run the previous command and begins new batch
--Jun  5 2079 12:00AM

-----------------------------------------------------------------------------
--T009_02_01_03
DECLARE @SmallDateTime1 SMALLDATETIME = CONVERT(SMALLDATETIME, '06/06/2079')
PRINT @SmallDateTime1
GO -- Run the previous command and begins new batch
--Jun  6 2079 12:00AM

-----------------------------------------------------------------------------
--T009_02_01_04
DECLARE @SmallDateTime1 SMALLDATETIME = CONVERT(SMALLDATETIME, '12/31/1899')
PRINT @SmallDateTime1
GO -- Run the previous command and begins new batch
/*
Error
--Msg 242, Level 16, State 3, Line 200
--The conversion of a varchar data type to a smalldatetime data type resulted in an out-of-range value.
*/

-----------------------------------------------------------------------------
--T009_02_01_05
DECLARE @SmallDateTime1 SMALLDATETIME = CONVERT(SMALLDATETIME, '06/07/2079')
PRINT @SmallDateTime1
GO -- Run the previous command and begins new batch
/*
Error
--Msg 242, Level 16, State 3, Line 210
--The conversion of a varchar data type to a smalldatetime data type resulted in an out-of-range value.
*/


--==========================================================================
--T009_02_02
--DateTime Range is between January 1, 1753 and December 31, 9999

-----------------------------------------------------------------------------
--T009_02_02_01
DECLARE @DateTime1 DateTime = CONVERT(DateTime, '01/01/1753')
PRINT @DateTime1
GO -- Run the previous command and begins new batch
--Jan  1 1753 12:00AM

-----------------------------------------------------------------------------
--T009_02_02_02
DECLARE @DateTime1 DateTime = CONVERT(DateTime, '12/31/9999')
PRINT @DateTime1
GO -- Run the previous command and begins new batch
--Dec 31 9999 12:00AM

-----------------------------------------------------------------------------
--T009_02_02_03
DECLARE @DateTime1 DateTime = CONVERT(DateTime, '12/31/1752')
PRINT @DateTime1
GO -- Run the previous command and begins new batch
/*
Error
--Msg 242, Level 16, State 3, Line 270
--The conversion of a varchar data type to a datetime data type resulted in an out-of-range value.
*/

-----------------------------------------------------------------------------
--T009_02_02_04
DECLARE @DateTime1 DateTime = CONVERT(DateTime, '01/01/10000')
PRINT @DateTime1
GO -- Run the previous command and begins new batch
/*
Error
--Msg 241, Level 16, State 1, Line 281
--Conversion failed when converting date and/or time from character string.
*/

--==========================================================================
--T009_02_03
--DateTime2 Range is between January 1, 0001 and December 31, 9999

-----------------------------------------------------------------------------
--T009_02_03_01
DECLARE @DateTime2 DateTime2 = CONVERT(DateTime2, '01/01/0001')
PRINT @DateTime2
GO -- Run the previous command and begins new batch
--0001-01-01 00:00:00.0000000

-----------------------------------------------------------------------------
--T009_02_03_02
DECLARE @DateTime2 DateTime2 = CONVERT(DateTime2, '12/31/9999')
PRINT @DateTime2
GO -- Run the previous command and begins new batch
--9999-12-31 00:00:00.0000000

--==========================================================================
--T009_02_04
--DateTime2[(FractionalSecondsPrecision)]

-----------------------------------------------------------------------------
--T009_02_04_01
DECLARE @DateTime2 DATETIME2(0) = CONVERT(DATETIME2(0), '12/15/2017 21:21:21.1234567')
DECLARE @DataLength INT = DATALENGTH(@DateTime2) 
PRINT @DateTime2
PRINT CONVERT(NVARCHAR(10), @DataLength) + ' Bytes'
GO -- Run the previous command and begins new batch
--2017-12-15 21:21:21
--6 Bytes

-----------------------------------------------------------------------------
--T009_02_04_02
DECLARE @DateTime2 DATETIME2(1) = CONVERT(DATETIME2(1), '12/15/2017 21:21:21.1234567')
DECLARE @DataLength INT = DATALENGTH(@DateTime2) 
PRINT @DateTime2
PRINT CONVERT(NVARCHAR(10), @DataLength) + ' Bytes'
GO -- Run the previous command and begins new batch
--2017-12-15 21:21:21.1
--6 Bytes

-----------------------------------------------------------------------------
--T009_02_04_03
DECLARE @DateTime2 DATETIME2(2) = CONVERT(DATETIME2(2), '12/15/2017 21:21:21.1234567')
DECLARE @DataLength INT = DATALENGTH(@DateTime2) 
PRINT @DateTime2
PRINT CONVERT(NVARCHAR(10), @DataLength) + ' Bytes'
GO -- Run the previous command and begins new batch
--2017-12-15 21:21:21.12
--6 Bytes

-----------------------------------------------------------------------------
--T009_02_04_04
DECLARE @DateTime2 DATETIME2(3) = CONVERT(DATETIME2(3), '12/15/2017 21:21:21.1234567')
DECLARE @DataLength INT = DATALENGTH(@DateTime2) 
PRINT @DateTime2
PRINT CONVERT(NVARCHAR(10), @DataLength) + ' Bytes'
GO -- Run the previous command and begins new batch
--2017-12-15 21:21:21.123
--7 Bytes

-----------------------------------------------------------------------------
--T009_02_04_05
DECLARE @DateTime2 DATETIME2(4) = CONVERT(DATETIME2(4), '12/15/2017 21:21:21.1234567')
DECLARE @DataLength INT = DATALENGTH(@DateTime2) 
PRINT @DateTime2
PRINT CONVERT(NVARCHAR(10), @DataLength) + ' Bytes'
GO -- Run the previous command and begins new batch
--2017-12-15 21:21:21.1235
--7 Bytes

-----------------------------------------------------------------------------
--T009_02_04_06
DECLARE @DateTime2 DATETIME2(5) = CONVERT(DATETIME2(5), '12/15/2017 21:21:21.1234567')
DECLARE @DataLength INT = DATALENGTH(@DateTime2) 
PRINT @DateTime2
PRINT CONVERT(NVARCHAR(10), @DataLength) + ' Bytes'
GO -- Run the previous command and begins new batch
--2017-12-15 21:21:21.12346
--8 Bytes

-----------------------------------------------------------------------------
--T009_02_04_07
DECLARE @DateTime2 DATETIME2(6) = CONVERT(DATETIME2(6), '12/15/2017 21:21:21.1234567')
DECLARE @DataLength INT = DATALENGTH(@DateTime2) 
PRINT @DateTime2
PRINT CONVERT(NVARCHAR(10), @DataLength) + ' Bytes'
GO -- Run the previous command and begins new batch
--2017-12-15 21:21:21.123457
--8 Bytes

-----------------------------------------------------------------------------
--T009_02_04_08
DECLARE @DateTime2 DATETIME2(7) = CONVERT(DATETIME2(7), '12/15/2017 21:21:21.1234567')
DECLARE @DataLength INT = DATALENGTH(@DateTime2) 
PRINT @DateTime2
PRINT CONVERT(NVARCHAR(10), @DataLength) + ' Bytes'
GO -- Run the previous command and begins new batch
--2017-12-15 21:21:21.1234567
--8 Bytes


--==========================================================================
--T009_03_DateFromPartsFunction V.S. DateTime2FromPartsFunction
--==========================================================================


/*
1.
--DATEFROMPARTS(year,month,day)
--DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision ) 
--SMALLDATETIMEFROMPARTS ( year, month, day, hour, minute )
--TIMEFROMPARTS( hour, minute, seconds, fractions, precision ) 
--DATETIMEOFFSETFROMPARTS ( year, month, day, hour, minute, seconds, fractions, hour_offset, minute_offset, precision )
Reference:
https://docs.microsoft.com/en-us/sql/t-sql/functions/datefromparts-transact-sql
The function with invalid argument valuse will return an error.
If any of the arguments are NULL, then the function returns null.
1.1.
DateFromParts Syntax : 
--DATEFROMPARTS(year,month,day)
Returns a date value.
1.2.
DatetimeFromParts Syntax : 
--DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision ) 
Returns a datetime2 value.
1.3.
SmallDateTimeFromParts Syntax :
--SMALLDATETIMEFROMPARTS ( year, month, day, hour, minute )
Returns a SmallDateTime value.
1.4.
TimeFromParts Syntax :
--TIMEFROMPARTS( hour, minute, seconds, fractions, precision ) 
Returns a Time value.
1.5.
DateTimeOffsetFromParts Syntax : 
--DATETIMEOFFSETFROMPARTS ( year, month, day, hour, minute, seconds, fractions, hour_offset, minute_offset, precision )
Returns a DateTimeOffset value.
*/

--==========================================================================
--T009_03_01
--DATEFROMPARTS(year,month,day)

-----------------------------------------------------------------------------
--T009_03_01_01
--DATEFROMPARTS(year,month,day)
--Valid argument
--Returns a date value for the specified year, month, and day.
SELECT DATEFROMPARTS(2015, 2, 15) AS [DATEFROMPARTS]
--2015-02-15
DECLARE @DateTime1 DATETIME = DATEFROMPARTS(2015, 2, 15);
PRINT @DateTime1;
--Feb 15 2015 12:00AM
GO -- Run the previous command and begins new batch

-----------------------------------------------------------------------------
--T009_03_01_02
--DATEFROMPARTS(year,month,day)
--Invalid argument for Month
--The function with invalid argument valuse will return an error.
SELECT DATEFROMPARTS(2015, 15, 15) AS [DATEFROMPARTS]
/*
Error
--Msg 289, Level 16, State 1, Line 225
--Cannot construct data type date, some of the arguments have values which are not valid.
*/
DECLARE @DateTime1 DATETIME = DATEFROMPARTS(2015, 15, 15);
PRINT @DateTime1;
/*
Error
--Msg 289, Level 16, State 1, Line 231
--Cannot construct data type date, some of the arguments have values which are not valid.
*/
GO -- Run the previous command and begins new batch

-----------------------------------------------------------------------------
--T009_03_01_03
--DATEFROMPARTS(year,month,day)
--NULL argument
--If any of the arguments are NULL, then the function returns null.
SELECT DATEFROMPARTS(2015, NULL, 15) AS [DATEFROMPARTS]
--NULL
GO -- Run the previous command and begins new batch


--==========================================================================
--T009_03_02
----DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision ) 

-----------------------------------------------------------------------------
--T009_03_02_01
--DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision ) 
--Valid argument
--Returns a date value for the specified year, month, and day.
SELECT DATETIME2FROMPARTS(2015, 2, 15, 15,59,59,0,0) AS [DATETIME2FROMPARTS]
--2015-02-15 15:59:59
DECLARE @DateTime1 DATETIME2 = DATETIME2FROMPARTS(2015, 2, 15, 15,59,59,0,0);
PRINT @DateTime1;
--2015-02-15 15:59:59.0000000
GO -- Run the previous command and begins new batch


-----------------------------------------------------------------------------
--T009_03_02_02
--DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision ) 
--Invalid argument for Month
--The function with invalid argument valuse will return an error.
SELECT DATETIME2FROMPARTS(2015, 15, 15, 15,59,59,0,0) AS [DATETIME2FROMPARTS]
/*
Error
--Msg 289, Level 16, State 5, Line 294
--Cannot construct data type datetime2, some of the arguments have values which are not valid.
*/
DECLARE @DateTime1 DATETIME = DATETIME2FROMPARTS(2015, 15, 15, 15,59,59,0,0);
PRINT @DateTime1;
/*
Error
--Msg 289, Level 16, State 5, Line 300
--Cannot construct data type datetime2, some of the arguments have values which are not valid.
*/
GO -- Run the previous command and begins new batch

-----------------------------------------------------------------------------
--T009_03_02_03
--DATETIME2FROMPARTS ( year, month, day, hour, minute, seconds, fractions, precision ) 
--NULL argument
--If any of the arguments are NULL, then the function returns null.
SELECT DATETIME2FROMPARTS(2015, NULL, 15, 15,59,59,0,0) AS [DATETIME2FROMPARTS]
--NULL
GO -- Run the previous command and begins new batch


