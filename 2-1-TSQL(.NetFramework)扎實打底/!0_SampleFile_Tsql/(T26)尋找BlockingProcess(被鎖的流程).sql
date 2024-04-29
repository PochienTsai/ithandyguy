-- T026_FindingBlockingProcess -------------------------------


--==============================================================
--T026_01_Finding Blocking Process
--==============================================================

--==============================================================
--T026_01_01
--Create Sample Data
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'TableA' ) )
    BEGIN
        TRUNCATE TABLE dbo.TableA;
        DROP TABLE TableA;
    END;
GO -- Run the previous command and begins new batch
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'TableB' ) )
    BEGIN
        TRUNCATE TABLE dbo.TableB;
        DROP TABLE TableB;
    END;
GO -- Run the previous command and begins new batch
CREATE TABLE TableA
(
  ID INT IDENTITY
         PRIMARY KEY ,
  Name NVARCHAR(50)
);
	GO -- Run the previous command and begins new batch
INSERT  INTO TableA
VALUES  ( 'TableAName1' );
INSERT  INTO TableA
VALUES  ( 'TableAName2' );
INSERT  INTO TableA
VALUES  ( 'TableAName3' );
INSERT  INTO TableA
VALUES  ( 'TableAName4' );
INSERT  INTO TableA
VALUES  ( 'TableAName5' );
GO -- Run the previous command and begins new batch
CREATE TABLE TableB
(
  ID INT IDENTITY
         PRIMARY KEY ,
  Name NVARCHAR(50)
);
INSERT  INTO TableB
VALUES  ( 'TableBName1' );
INSERT  INTO TableB
VALUES  ( 'TableBName2' );
INSERT  INTO TableB
VALUES  ( 'TableBName3' );
INSERT  INTO TableB
VALUES  ( 'TableBName4' );
INSERT  INTO TableB
VALUES  ( 'TableBName5' );
GO -- Run the previous command and begins new batch

SELECT  *
FROM    TableA;
SELECT  *
FROM    TableB;
GO -- Run the previous command and begins new batch

--==============================================================
--T026_01_02
--display the oldest active transaction information.
DBCC OPENTRAN; 
GO -- Run the previous command and begins new batch
/*
Output
--No active open transactions.
--DBCC execution completed. If DBCC printed error messages, contact your system administrator.
*/

--==============================================================
--T026_01_03
--Create Blocking Query

-------------------------------------------------------------
--T026_01_03_01
--Transaction1
BEGIN TRAN;
UPDATE  TableA
SET     Name += ' Tran1'
WHERE   ID = 1; 
--Thus, TableA will be block.

/*
Open another query windows to execute the query.
Begin a transaction and do not commit.
Thus, TableA will be locked by this uncommited transaction.
All other transaction will not be able to use TableA.
*/

-------------------------------------------------------------
--T026_01_03_02
--Transaction2

--T026_01_03_03_01
SELECT  COUNT(*)
FROM    TableA;

--T026_01_03_03_02
DELETE  FROM TableA
WHERE   ID = 1;

--T026_01_03_03_03
TRUNCATE TABLE TableA;

--T026_01_03_03_04
DROP TABLE TableA;

/*
Open another query windows to execute the query.
Execute 1~4 query in Transaction2 separately.
All these query will be blocked 
by the previous uncommited transaction, Transaction1.
TableA has beem locked by Transaction1.
*/

-------------------------------------------------------------
--T026_01_03_03
--Transaction3
--Create Blocking Query
BEGIN TRAN;
UPDATE  dbo.TableB
SET     Name += ' Tran3'
WHERE   ID = 1; 
--Thus, TableB will be block.

/*
Open another query windows to execute the query.
Begin another transaction and do not commit.
Thus, TableB will be locked by this uncommited transaction.
All other transaction will not be able to use TableB.
*/

-------------------------------------------------------------
--T026_01_03_04
--Transaction4
--display the oldest active transaction information.
DBCC OPENTRAN; 

/*
Output
--Transaction information for database 'Sample3'.
--Oldest active transaction:
--    SPID (server process ID): 81
--    UID (user ID) : -1
--    Name          : user_transaction
--    LSN           : (144:13115:62)
--    Start time    : Oct  8 2017 12:19:23:033AM
--    SID           : 0x01050000000000051500000054784a4d0334c4f05dd5fdcde9030000
--DBCC execution completed. If DBCC printed error messages, contact your system administrator.
You can see the bottom of SSMS, it display "ComputerName\UserLoginName (81)"
(81) means the processID=81
*/

--Display all the active transaction information.
SELECT
    [s_tst].[session_id],
    [s_es].[login_name] AS [Login Name],
    DB_NAME (s_tdt.database_id) AS [Database],
    [s_tdt].[database_transaction_begin_time] AS [Begin Time],
    [s_tdt].[database_transaction_log_bytes_used] AS [Log Bytes],
    [s_tdt].[database_transaction_log_bytes_reserved] AS [Log Rsvd],
    [s_est].text AS [Last T-SQL Text],
    [s_eqp].[query_plan] AS [Last Plan]
FROM
    sys.dm_tran_database_transactions [s_tdt]
JOIN
    sys.dm_tran_session_transactions [s_tst]
ON
    [s_tst].[transaction_id] = [s_tdt].[transaction_id]
JOIN
    sys.[dm_exec_sessions] [s_es]
ON
    [s_es].[session_id] = [s_tst].[session_id]
JOIN
    sys.dm_exec_connections [s_ec]
ON
    [s_ec].[session_id] = [s_tst].[session_id]
LEFT OUTER JOIN
    sys.dm_exec_requests [s_er]
ON
    [s_er].[session_id] = [s_tst].[session_id]
CROSS APPLY
    sys.dm_exec_sql_text ([s_ec].[most_recent_sql_handle]) AS [s_est]
OUTER APPLY
    sys.dm_exec_query_plan ([s_er].[plan_handle]) AS [s_eqp]
ORDER BY
    [Begin Time] ASC;
GO -- Run the previous command and begins new batch

/*
--DBCC OpenTran 
Reference:
https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-opentran-transact-sql
https://www.sqlskills.com/blogs/paul/script-open-transactions-with-text-and-plans/
DBCC OPENTRAN can only display 
the oldest active transaction information.
If you want to see all the active transaction information,
You have to use the following script.
--SELECT
--    [s_tst].[session_id],
--    [s_es].[login_name] AS [Login Name],
--    DB_NAME (s_tdt.database_id) AS [Database],
--    [s_tdt].[database_transaction_begin_time] AS [Begin Time],
--    [s_tdt].[database_transaction_log_bytes_used] AS [Log Bytes],
--    [s_tdt].[database_transaction_log_bytes_reserved] AS [Log Rsvd],
--    [s_est].text AS [Last T-SQL Text],
--    [s_eqp].[query_plan] AS [Last Plan]
--FROM
--    sys.dm_tran_database_transactions [s_tdt]
--JOIN
--    sys.dm_tran_session_transactions [s_tst]
--ON
--    [s_tst].[transaction_id] = [s_tdt].[transaction_id]
--JOIN
--    sys.[dm_exec_sessions] [s_es]
--ON
--    [s_es].[session_id] = [s_tst].[session_id]
--JOIN
--    sys.dm_exec_connections [s_ec]
--ON
--    [s_ec].[session_id] = [s_tst].[session_id]
--LEFT OUTER JOIN
--    sys.dm_exec_requests [s_er]
--ON
--    [s_er].[session_id] = [s_tst].[session_id]
--CROSS APPLY
--    sys.dm_exec_sql_text ([s_ec].[most_recent_sql_handle]) AS [s_est]
--OUTER APPLY
--    sys.dm_exec_query_plan ([s_er].[plan_handle]) AS [s_eqp]
--ORDER BY
--    [Begin Time] ASC;
--GO
2.1.
Output
--session_id ...
--81...
--60...
*/

-------------------------------------------------------------
--T026_01_03_05
--Go back to the query window of 
--the Transaction1: 
--and perform COMMIT;
COMMIT; 

-------------------------------------------------------------
--T026_01_03_06
--Go back to the query window of 
--the Transaction3: 
--and perform COMMIT;
COMMIT; 

-------------------------------------------------------------
--T026_01_03_07
--Transaction4
--display the oldest active transaction information.
DBCC OPENTRAN; 

/*
Output
--No active open transactions.
--DBCC execution completed. 
--If DBCC printed error messages, 
--contact your system administrator.
*/

--Display all the active transaction information.
SELECT
    [s_tst].[session_id],
    [s_es].[login_name] AS [Login Name],
    DB_NAME (s_tdt.database_id) AS [Database],
    [s_tdt].[database_transaction_begin_time] AS [Begin Time],
    [s_tdt].[database_transaction_log_bytes_used] AS [Log Bytes],
    [s_tdt].[database_transaction_log_bytes_reserved] AS [Log Rsvd],
    [s_est].text AS [Last T-SQL Text],
    [s_eqp].[query_plan] AS [Last Plan]
FROM
    sys.dm_tran_database_transactions [s_tdt]
JOIN
    sys.dm_tran_session_transactions [s_tst]
ON
    [s_tst].[transaction_id] = [s_tdt].[transaction_id]
JOIN
    sys.[dm_exec_sessions] [s_es]
ON
    [s_es].[session_id] = [s_tst].[session_id]
JOIN
    sys.dm_exec_connections [s_ec]
ON
    [s_ec].[session_id] = [s_tst].[session_id]
LEFT OUTER JOIN
    sys.dm_exec_requests [s_er]
ON
    [s_er].[session_id] = [s_tst].[session_id]
CROSS APPLY
    sys.dm_exec_sql_text ([s_ec].[most_recent_sql_handle]) AS [s_est]
OUTER APPLY
    sys.dm_exec_query_plan ([s_er].[plan_handle]) AS [s_eqp]
ORDER BY
    [Begin Time] ASC;
GO

/*
--DBCC OpenTran 
Reference:
https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-opentran-transact-sql
https://www.sqlskills.com/blogs/paul/script-open-transactions-with-text-and-plans/
DBCC OPENTRAN can only display 
the oldest active transaction information.
If you want to see all the active transaction information,
You have to use the following script.
--SELECT
--    [s_tst].[session_id],
--    [s_es].[login_name] AS [Login Name],
--    DB_NAME (s_tdt.database_id) AS [Database],
--    [s_tdt].[database_transaction_begin_time] AS [Begin Time],
--    [s_tdt].[database_transaction_log_bytes_used] AS [Log Bytes],
--    [s_tdt].[database_transaction_log_bytes_reserved] AS [Log Rsvd],
--    [s_est].text AS [Last T-SQL Text],
--    [s_eqp].[query_plan] AS [Last Plan]
--FROM
--    sys.dm_tran_database_transactions [s_tdt]
--JOIN
--    sys.dm_tran_session_transactions [s_tst]
--ON
--    [s_tst].[transaction_id] = [s_tdt].[transaction_id]
--JOIN
--    sys.[dm_exec_sessions] [s_es]
--ON
--    [s_es].[session_id] = [s_tst].[session_id]
--JOIN
--    sys.dm_exec_connections [s_ec]
--ON
--    [s_ec].[session_id] = [s_tst].[session_id]
--LEFT OUTER JOIN
--    sys.dm_exec_requests [s_er]
--ON
--    [s_er].[session_id] = [s_tst].[session_id]
--CROSS APPLY
--    sys.dm_exec_sql_text ([s_ec].[most_recent_sql_handle]) AS [s_est]
--OUTER APPLY
--    sys.dm_exec_query_plan ([s_er].[plan_handle]) AS [s_eqp]
--ORDER BY
--    [Begin Time] ASC;
--GO
*/

--==============================================================
--T026_01_04
--Clean up

--If Table exists then DROP it
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'TableA' ) )
    BEGIN
        TRUNCATE TABLE dbo.TableA;
        DROP TABLE TableA;
    END;
GO -- Run the previous command and begins new batch
--clean up
--If Table exists then DROP it
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'TableB' ) )
    BEGIN
        TRUNCATE TABLE dbo.TableB;
        DROP TABLE TableB;
    END;
GO -- Run the previous command and begins new batch


