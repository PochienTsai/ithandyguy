-- T001_PK_FK_DefaultConstraint_CheckConstraint_IdentityColumn -----------
/*
What to learn
- Creating, altering and dropping a database
- Set database to single user mode and delete it.
*/

--====================================================================================================
--T001_PK_FK_DefaultConstraint_CheckConstraint_IdentityColumn
--====================================================================================================


--====================================================================================================
--T001_01
--Database


------------------------------------------------------------------------------------------------------------
--T001_01_01
--Create Database
USE master;
GO -- Run the prvious command and begins new batch
CREATE DATABASE [Sample];
GO
/*
-- CREATE DATABASE DatabaseName;
Create Database
*/


------------------------------------------------------------------------------------------------------------
--T001_01_02
--Change Database Name
USE master;
GO -- Run the prvious command and begins new batch
ALTER DATABASE [Sample] MODIFY NAME = Sample2;
GO
/*
-- ALTER DATABASE DatabaseName MODIFY NAME = NewDatabaseName;
Alter Database Name
*/


------------------------------------------------------------------------------------------------------------
--T001_01_03
--sp_renamedb
USE master;
GO -- Run the prvious command and begins new batch
EXEC sp_renamedb N'Sample2', N'Sample3';
GO
/*
-- ALTER EXECUTE sp_renameDB 'OldDatabaseName', 'NewDatabaseName';
Reference:
https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-renamedb-transact-sql
Alter Database Name
*/

------------------------------------------------------------------------------------------------------------
--T001_01_04
--sys.databases
USE master;
GO -- Run the prvious command and begins new batch
SELECT  [name] ,
        database_id ,
        create_date
FROM    sys.databases
WHERE   name = N'Sample3';
GO
/*
sys.databases is the system database which store all the database list information
*/

------------------------------------------------------------------------------------------------------------
--T001_01_05
--Create Table ON  [PRIMARY] in Sample3
USE Sample3;
GO -- Run the prvious command and begins new batch
CREATE TABLE [dbo].[tableA]
(
  [Id] [INT] IDENTITY(1, 1)
             NOT NULL ,  
  --[Id] [INT] IDENTITY(1, 1) PRIMARY KEY NOT NULL,              
  [Name] [NVARCHAR](50) NOT NULL ,
  CONSTRAINT [PK_tableA] PRIMARY KEY CLUSTERED ( [Id] ASC )
    WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
           ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
)
    ON
[PRIMARY];
GO

/*
1.
There are 2 ways to set the primary Key
1.1.
--GamerId INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,  
1.2.
--[Id] [INT] IDENTITY(1, 1) NOT NULL ,
--CONSTRAINT [PK_Gamer2] PRIMARY KEY CLUSTERED ( [Id] ASC )
--    WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
--        IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
--        ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]

2.
[Id] [int] IDENTITY(1,1) NOT NULL,
It means Id is the Primary Key and the type is int.
Id will start from 1 (the first one is identity seed), 
and then increase 1 (the second one is identity increment) 
3.
-- ON [PRIMARY]
When you create database, SQL server will generate 
one .MDF(primary data file) and one .LDF(log file)
Sometimes a SQL Server database will include one or more .NDF (secondary data files).
-- ON [PRIMARY]
means create this table on the .MDF(primary data file).
*/


------------------------------------------------------------------------------------------------------------
--T001_01_06
--forced to delete DATABASE Sample3
USE master;
 -- be sure that you're not on the database you want to delete
GO -- Run the prvious command and begins new batch
IF ( EXISTS ( SELECT    [name] ,
                        database_id ,
                        create_date
              FROM      sys.databases
              WHERE     name = N'Sample3' ) )
    BEGIN
        ALTER DATABASE [Sample3] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE [Sample3];
    END;
GO -- Run the previous command and begins new batch

/*
1.
--IF ( EXISTS ( SELECT    [name] ,
--                        database_id ,
--                        create_date
--              FROM      sys.databases
--              WHERE     name = N'Sample3' ) )
If the Sample3 exist.

2.
Reference:
https://stackoverflow.com/questions/17095472/cannot-drop-database-because-it-is-currently-in-use-mvc
Error Message:
Cannot drop database "NewDatabaseName" because it is currently in use.
Solutons:
--ALTER DATABASE [Sample3] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
--DROP DATABASE [Sample3];
put the database in single user mode which 
will rollback all incomplete transactions and closes the connection to the database.
then drop the database.
*/


--====================================================================================================
--T001_02
--Tables

/*
What to learn
- Create Table
- Default Constraint
- Check Constraint
- Identity Column
- Primary Key
- Foreign Key
- Insert
*/

------------------------------------------------------------------------------------------------------------
--T001_02_00
--Create or ReCreate Database.
USE master;
-- be sure that you're not on the database you want to delete
GO -- Run the prvious command and begins new batch
IF ( EXISTS ( SELECT    [name] ,
                        database_id ,
                        create_date
              FROM      sys.databases
              WHERE     name = N'Sample' ) )
    BEGIN
        --forced to delete DATABASE Sample
        ALTER DATABASE [Sample] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE [Sample];
    END;
GO -- Run the previous command and begins new batch
CREATE DATABASE [Sample];
GO -- Run the previous command and begins new batch
USE [Sample];
GO -- Run the prvious command and begins new batch
/*
1.
--IF ( EXISTS ( SELECT    [name] ,
--                        database_id ,
--                        create_date
--              FROM      sys.databases
--              WHERE     name = N'Sample' ) )
If the Sample exist.
2.
Reference:
https://stackoverflow.com/questions/17095472/cannot-drop-database-because-it-is-currently-in-use-mvc
Error Message:
Cannot drop database "NewDatabaseName" because it is currently in use.
Solutons:
--ALTER DATABASE [Sample] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
--DROP DATABASE [Sample];
put the database in single user mode which
will rollback all incomplete transactions and closes the connection to the database.
then drop the database.
*/


-----------------------------------------------------------------------------------------------------
--T001_02_01
--CreateTable - Gender
CREATE TABLE Gender
(
  Id INT IDENTITY(1, 1)
         PRIMARY KEY
         NOT NULL ,
  --Id INT IDENTITY(1,1)
  --       NOT NULL ,
  [Gender] [NVARCHAR](50) NOT NULL ,
  --CONSTRAINT [PK_Gender] PRIMARY KEY CLUSTERED ( [Id] ASC )
  --  WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
  --         ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
)
    ON
[PRIMARY];
GO -- Run the prvious command and begins new batch

/*
1.
There are 2 ways to set the primary Key
1.1.
--Id INT IDENTITY(1, 1) PRIMARY KEY NOT NULL, 
1.2.
--[Id] [INT] IDENTITY(1, 1) NOT NULL ,
--CONSTRAINT [PK_Gender] PRIMARY KEY CLUSTERED ( [Id] ASC )
--WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
--        IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
--        ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
2.
[Id] [int] IDENTITY(1,1) NOT NULL,
It means Id is the Primary Key and the type is int.
Id will start from 1 (the first one is identity seed),
and then increase 1 (the second one is identity increment)
3.
-- ON [PRIMARY]
When you create database, SQL server will generate
one .MDF(primary data file) and one .LDF(log file)
Sometimes a SQL Server database will include one or more .NDF (secondary data files).
-- ON [PRIMARY]
means create this table on the .MDF(primary data file).
*/


-----------------------------------------------------------------------------------------------------
--T001_02_02
--Insert Data to Gender
INSERT  Gender
VALUES  ( N'Male' );

SET IDENTITY_INSERT Gender ON; 
INSERT  Gender
        ( Id, Gender )
VALUES  ( 2, N'Female' );
INSERT  [dbo].Gender
        ( Id, Gender )
VALUES  ( 3, N'Unknow' );
SET IDENTITY_INSERT Gender OFF;
GO -- Run the prvious command and begins new batch

SELECT  *
FROM    Gender;
GO -- Run the prvious command and begins new batch
/*
1.
--INSERT  [dbo].[Gender]
--VALUES  ( N'Male' );
You do not have to provide value for identity column 
because it is auto generated.

2.
You do not have to provide value for identity column 
because it is auto generated.
If you want to provide value for identity column, 
then you have to set IDENTITY_INSERT is ON. 
--SET IDENTITY_INSERT [TableName] ON; 
--INSERT ...
--SET IDENTITY_INSERT [TableName] OFF;

3.
--SELECT *
--FROM Gender;
* means all columns
Get all Columns from Gender Table.
*/


-----------------------------------------------------------------------------------------------------
--T001_02_03
--CreateTable - Gamer
CREATE TABLE Gamer
(
  Id INT IDENTITY(1, 1)
         NOT NULL ,
      --Id INT IDENTITY(1, 1)
      --           PRIMARY KEY
      --           NOT NULL ,
  [Name] NVARCHAR(50) NOT NULL ,
  Email NVARCHAR(50) NOT NULL ,
  GenderId INT NULL ,
  CreatedDateTime DATETIME NOT NULL ,
  Age INT NULL ,
  CONSTRAINT [PK_Gamer_1] PRIMARY KEY CLUSTERED ( [Id] ASC )
    WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
           ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
)
    ON
[PRIMARY];
GO -- Run the prvious command and begins new batch

/*
1.
There are 2 ways to set the primary Key
1.1.
--Id INT IDENTITY(1, 1) PRIMARY KEY NOT NULL, 
1.2.
--[Id] [INT] IDENTITY(1, 1) NOT NULL ,
--CONSTRAINT [PK_Gamer_1] PRIMARY KEY CLUSTERED ( [Id] ASC )
--    WITH ( PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
--            IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
--            ALLOW_PAGE_LOCKS = ON ) ON [PRIMARY]
2.
[Id] [int] IDENTITY(1,1) NOT NULL,
It means Id is the Primary Key and the type is int.
Id will start from 1 (the first one is identity seed),
and then increase 1 (the second one is identity increment)
3.
-- ON [PRIMARY]
When you create database, SQL server will generate
one .MDF(primary data file) and one .LDF(log file)
Sometimes a SQL Server database will include one or more .NDF (secondary data files).
-- ON [PRIMARY]
means create this table on the .MDF(primary data file).
*/


-----------------------------------------------------------------------------------------------------
--T001_02_04
--dbo.Gamer - Default Constraint

--------------------------------------------------------------------------
--T001_02_04_01
--Altering an existing column to add a default constraint.
ALTER TABLE Gamer 
ADD  CONSTRAINT DF_Gamer_GenderId  
DEFAULT ((3)) FOR [GenderId];

ALTER TABLE Gamer 
ADD  CONSTRAINT [DF_Gamer_CreatedDateTime]  
DEFAULT (GETUTCDATE()) FOR [CreatedDateTime];
GO -- Run the prvious command and begins new batch

--------------------------------------------------------------------------
--T001_02_04_02
--Adding a new column, with default value, to an existing table
ALTER TABLE Gamer
ADD GenderId2 INT NULL 
CONSTRAINT DF_Gamer_GenderId2 DEFAULT ((3));
GO -- Run the prvious command and begins new batch

--------------------------------------------------------------------------
--T001_02_04_03
--Check the default constraint.
SELECT  *
FROM    sys.objects
WHERE   type_desc LIKE '%CONSTRAINT'
        AND OBJECT_NAME(object_id) = 'DF_Gamer_GenderId2';
GO -- Run the prvious command and begins new batch

--------------------------------------------------------------------------
--T001_02_04_04
--delete the default constraint if it exists.
IF OBJECT_ID('DF_Gamer_GenderId2', 'D') IS NOT NULL
    BEGIN
        ALTER TABLE Gamer
        DROP CONSTRAINT DF_Gamer_GenderId2;
    END;
GO -- Run the prvious command and begins new batch

/*
Constraint Object Types:
C = CHECK constraint
D = DEFAULT (constraint or stand-alone)
F = FOREIGN KEY constraint
PK = PRIMARY KEY constraint
R = Rule (old-style, stand-alone)
UQ = UNIQUE constraint
*/

--------------------------------------------------------------------------
--T001_02_04_05
--Delete the column
ALTER TABLE Gamer
DROP COLUMN GenderId2;

/*
1.
Default Constraint Syntax1:
--ALTER TABLE {TableName} 
--ADD  CONSTRAINT {DFConstraintName}  
--DEFAULT {DefaultValue} FOR {ColumnName};
Altering an existing column to add a default constraint.
In TableName, 
Add a default constraint called DFConstraintName,
The default value of ColumnName is DefaultValue.
When the column has DEFAULT CONSTRAINT, 
then we do not have to provide value for the column.
1.1.
E.g.
--ALTER TABLE Gamer 
--ADD  CONSTRAINT DF_Gamer_GenderId  
--DEFAULT ((2)) FOR [GenderId];
In Gamer Table, 
Add a default constraint called DF_Gamer_GenderId,
The default value of GenderId Column is 2.
1.2.
E.g.
--ALTER TABLE Gamer 
--ADD  CONSTRAINT [DF_Gamer_CreatedDateTime]  
--DEFAULT (GETUTCDATE()) FOR [CreatedDateTime];
In Gamer Table, 
Add a default constraint called DF_Gamer_CreatedDateTime,
The default value of CreatedDateTime Column is GETUTCDATE().

-------------------------------------
2.
Default Constraint Syntax2:
--ALTER TABLE { TableName } 
--ADD { ColumnName } { DataType } { NULL | NOT NULL } 
--CONSTRAINT { DFConstraintName } DEFAULT { DefaultValue }
Adding a new column, with default value, to an existing table.
In TableName, 
Add a new column called ColumnName, 
its type is DataType,
which can be NULL | NOT NULL
Add a default constraint called DFConstraintName,
The default value of ColumnName is DefaultValue.
When the column has DEFAULT CONSTRAINT, 
then we do not have to provide value for the column.
2.1.
E.g.
--ALTER TABLE Gamer
--ADD GenderId2 INT NULL 
--CONSTRAINT DF_Gamer_GenderId2 DEFAULT ((3))
In Gamer Table, 
Add a new column called "GenderId2", 
its type is "INT",
which can be NULL.
Add a default constraint called "DF_Gamer_GenderId2",
The default value of "GenderId2" is "3".

-------------------------------------
3.
Drop Default Constraint Syntax:
--ALTER TABLE {TableName}
--DROP CONSTRAINT {DFConstraintName}
In {TableName} TABLE
Drop the constraint called DFConstraintName.
3.1.
E.g.
--ALTER TABLE Gamer
--DROP CONSTRAINT DF_Gamer_GenderId2
In Gamer TABLE
Drop the constraint called DF_Gamer_GenderId2.

-------------------------------------
4.
Drop Column Syntax:
--ALTER TABLE {TableName}
--DROP COLUMN {ColumnName};
In {TableName} TABLE
Drop the column called {ColumnName}
4.1.
E.g.
--ALTER TABLE Gamer
--DROP COLUMN GenderId2;
In Gamer TABLE
Drop the column called GenderId2

--------------------------------------
5.
--IF OBJECT_ID('DF_Gamer_GenderId2', 'D') IS NOT NULL
Reference:
https://stackoverflow.com/questions/2499332/how-to-check-if-a-constraint-exists-in-sql-server
Constraint Object Types:
C = CHECK constraint
D = DEFAULT (constraint or stand-alone)
F = FOREIGN KEY constraint
PK = PRIMARY KEY constraint
R = Rule (old-style, stand-alone)
UQ = UNIQUE constraint
*/






------------------------------------------------------------------------------------------------------
--T001_02_05
--Gamer - Check Constraint

---------------------------------------------------------------------------------
--T001_02_05_01
--ALTER TABLE [dbo].[Gamer]  WITH CHECK ADD  CONSTRAINT [CK_Gamer_Age] CHECK  (([Age]>(0) AND [Age]<(150)));
--ALTER TABLE [dbo].[Gamer] CHECK CONSTRAINT [CK_Gamer_Age];
--GO -- Run the prvious command and begins new batch

---------------------------------------------------------------------------------
--T001_02_05_02
--Add Check constraint
ALTER TABLE Gamer
ADD CONSTRAINT CK_Gamer_Age CHECK (Age > 0 AND Age < 150);
GO -- Run the prvious command and begins new batch

INSERT  Gamer
        ( [Name], [Email], [Age] )
VALUES  ( N'NameAA', N'AA@AA.com', 180 );
--Fail to insert, because of the check constraint.

SELECT  *
FROM    Gamer;

---------------------------------------------------------------------------------
--T001_02_05_03
--Get the information of the check constraint.
SELECT  *
FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE   CONSTRAINT_NAME = 'CK_Gamer_Age';  

---------------------------------------------------------------------------------
--T001_02_05_04
--https://stackoverflow.com/questions/2499332/how-to-check-if-a-constraint-exists-in-sql-server
--Create or Recreate Check constraint
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLE_CONSTRAINTS
              WHERE     CONSTRAINT_NAME = 'CK_Gamer_Age' ) )
    BEGIN
        ALTER TABLE Gamer
        DROP CONSTRAINT CK_Gamer_Age;
    END;
GO -- Run the previous command and begins new batch
ALTER TABLE Gamer
ADD CONSTRAINT CK_Gamer_Age CHECK (Age > 0 AND Age < 150);
GO -- Run the prvious command and begins new batch

/*
1.
Add Check Constraint Syntax:
--ALTER TABLE {TableName}
--ADD CONSTRAINT {CKConstraintName} CHECK {Condition};
In {TableName} Table,
Add a check constraint called {CKConstraintName},
It must fullfill the {Condition}.
1.1.
E.g.
--ALTER TABLE Gamer
--ADD CONSTRAINT CK_Gamer_Age CHECK (Age > 0 AND Age < 150);
In Gamer Table,
Add a check constraint called CKConstraintName,
The value in Age Column must be between 0 to 150.

2.
--INSERT  Gamer
--        ( [Name], [Email], [Age] )
--VALUES  ( N'NameAA', N'AA@AA.com', 180 );
Because the Age must be between 0 to 150.
this will fail.

3.
ALTER TABLE {TableName}
DROP CONSTRAINT {CKConstraintName};
In {TableName} Table,
Drop the check constraint called {CKConstraintName},
3.1.
E.g.
--ALTER TABLE Gamer
--DROP CONSTRAINT CK_Gamer_Age;
In Gamer Table,
Drop the check constraint called CK_Gamer_Age,

4.
--SELECT  *
--FROM    Gamer;
* means all columns
Get all columns from Gamer Table.
*/




------------------------------------------------------------------------------------------------------
--T001_02_06
--Gamer - Referential Integrity constraint (Foreign Key)

---------------------------------------------------------------------------------
--T001_02_06_01
--ALTER TABLE [dbo].[Gamer]  WITH CHECK ADD  CONSTRAINT [FK_Gender_Gamer] FOREIGN KEY([Id])
--REFERENCES [dbo].[Gamer] ([Id])
--ALTER TABLE [dbo].[Gamer] CHECK CONSTRAINT [FK_Gender_Gamer]
--GO -- Run the prvious command and begins new batch

---------------------------------------------------------------------------------
--T001_02_06_02
ALTER TABLE Gamer ADD CONSTRAINT FK_Gender_Gamer
FOREIGN KEY (GenderId) REFERENCES Gender(Id)
ON DELETE NO ACTION;
GO -- Run the prvious command and begins new batch
/*
1.
--ALTER TABLE Gamer ADD CONSTRAINT FK_Gender_Gamer
--FOREIGN KEY (GenderId) REFERENCES Gender(Id)
--ON DELETE NO ACTION;
1.1.
Create a FOREIGN KEY CONSTRAINT "FK_Gender_Gamer" in order to 
connect the  [Gamer].[GenderId]   column into  [Gender].[Id]
Foreign keys are used to enforce database integrity.
The values that you enter into the foreign key column, 
has to be one of the values contained in the table it points to.
1.2.
You may delete 
--ON DELETE NO ACTION;
because, Foreign key is "ON DELETE NO ACTION" by default setting.
This means when you delete valueA in Gender Table, 
If the valueA is still used in Gamer table,
then do nothing which means 
valueA can not be deleted if it is still used in other table.
2.
--ALTER TABLE Gamer ADD CONSTRAINT FK_Gender_Gamer
--FOREIGN KEY (GenderId) REFERENCES Gender(Id);
This is easier way to create CHECK CONSTRAINT
*/


------------------------------------------------------------------------------------------------------
--T001_02_07
--INSERT Data to Gamer

SET IDENTITY_INSERT [Gamer] ON; 
INSERT  Gamer
        ( Id ,
          [Name] ,
          Email ,
          GenderId ,
          CreatedDateTime ,
          Age
        )
VALUES  ( 1 ,
          N'Name1' ,
          N'1@1.com' ,
          1 ,
          CAST(N'2017-09-01T18:05:03.127' AS DATETIME) ,
          21
        );
INSERT  [dbo].[Gamer]
        ( Id ,
          [Name] ,
          Email ,
          GenderId ,
          CreatedDateTime ,
          Age
        )
VALUES  ( 2 ,
          N'Name5' ,
          N'2@2.com' ,
          2 ,
          CAST(N'2017-09-01T18:05:18.443' AS DATETIME) ,
          22
        );
INSERT  [dbo].[Gamer]
        ( Id ,
          [Name] ,
          Email ,
          GenderId ,
          CreatedDateTime ,
          Age
        )
VALUES  ( 3 ,
          N'Name3' ,
          N'3@3.com' ,
          3 ,
          CAST(N'2017-09-01T18:05:41.070' AS DATETIME) ,
          23
        );
SET IDENTITY_INSERT [dbo].[Gamer] OFF;

INSERT  Gamer
        ( [Name], Email, GenderId, Age )
VALUES  ( N'Name4', N'4@4.com', 1, 24 );

INSERT  Gamer
VALUES  ( N'Name5', N'5@5.com', 2,
          CAST(N'2017-09-01T18:05:03.127' AS DATETIME), 25 );

INSERT  Gamer
        ( [Name], [Email], [Age] )
VALUES  ( N'Name6', N'6@6.com', 26 );
GO -- Run the prvious command and begins new batch

SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch
/*
1.
--INSERT  Gamer
--        ( [Name], [Email], [Age] )
--VALUES  ( N'Name6', N'6@6.com', 26 );
1.1.
You do not have to provide value for identity column [Id]
because it is auto generated.
When we create the table, we set the id is IDENTITY(1,1)
--Id INT IDENTITY(1,1) NOT NULL,
It means Id is the Primary Key and the type is int.
Id will start from 1 (the first one is identity seed),
and then increase 1 (the second one is identity increment)
1.2.
Previously, We set the default constraint, 
thus, we do not have to provide value for [GenderId] , [CreatedDateTime].
The default value of [GenderId] is 3
The default value of [CreatedDateTime] is GETUTCDATE()
1.3.
--ALTER TABLE Gamer
--ADD CONSTRAINT CK_Gamer_Age CHECK (Age > 0 AND Age < 150);
Previously, We set the Check constraint, 
The Age must be between 0 to 150.

2.
You do not have to provide value for identity column 
because it is auto generated.
If you want to provide value for identity column, 
then you have to set IDENTITY_INSERT is ON. 
--SET IDENTITY_INSERT [TableName] ON; 
--INSERT ...
--SET IDENTITY_INSERT [TableName] OFF;
*/






--====================================================================================================
--T001_03
--Unique Key Constraint

-----------------------------------------------------------------------------------------------------
--T001_03_01
--Add the unique constraint 
ALTER TABLE Gamer
ADD CONSTRAINT UQ_Gamer_Email UNIQUE(Email);
--Email must be unique

SELECT  *
FROM    Gender;
SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

INSERT  Gamer
        ( [Name], [Email], [Age] )
VALUES  ( N'Name7', N'7@7.com', 27 );
--insert Name8 will be fail, because Email must be unique.
INSERT  Gamer
        ( [Name], [Email], [Age] )
VALUES  ( N'Name8', N'7@7.com', 28 );
GO -- Run the prvious command and begins new batch

SELECT  *
FROM    Gender;
SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch


---------------------------------------------------------------------------------------------------------
--T001_03_02
--Get the information of the unique constraint
SELECT  *
FROM    INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE   CONSTRAINT_NAME = 'UQ_Gamer_Email';  
/*
Reference:
https://stackoverflow.com/questions/2499332/how-to-check-if-a-constraint-exists-in-sql-server
*/

---------------------------------------------------------------------------------------------------------
--T001_03_03
--Drop the unique constraint.
ALTER TABLE Gamer
DROP CONSTRAINT UQ_Gamer_Email;

SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

INSERT  Gamer
        ( [Name], [Email], [Age] )
VALUES  ( N'Name7', N'7@7.com', 27 );
--insert Name8 will be fail, because Email must be unique.
INSERT  Gamer
        ( [Name], [Email], [Age] )
VALUES  ( N'Name8', N'7@7.com', 28 );
GO -- Run the prvious command and begins new batch

SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

DELETE Gamer
WHERE Email = N'7@7.com';
/*
Delete the rows which email is '7@7.com'
*/

SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

---------------------------------------------------------------------------------------------------------
--T001_03_04
--Create or Recreate the unique constraint
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLE_CONSTRAINTS
              WHERE     CONSTRAINT_NAME = 'UQ_Gamer_Email' ) )
    BEGIN
        ALTER TABLE Gamer
        DROP CONSTRAINT UQ_Gamer_Email;
    END;
GO -- Run the previous command and begins new batch
ALTER TABLE Gamer
ADD CONSTRAINT UQ_Gamer_Email UNIQUE(Email);
--Email must be unique

/*
1.
Add Unique constraint Syntax:
--ALTER TABLE {TableName}
--ADD CONSTRAINT {UQConstraintName} UNIQUE({ColumnName});
In {ColumnName} column of {TableName} table, 
Add a unique constraint called {UQConstraintName}.
1.1.
E.g.
--ALTER TABLE Gamer
--ADD CONSTRAINT UQ_Gamer_Email UNIQUE(Email);
In Email column of Gamer table, 
Add a unique constraint called UQ_Gamer_Email.

2.
Drop Unique constraint Syntax:
--ALTER TABLE {TableName}
--DROP CONSTRAINT {UQConstraintName};
In {TableName} table, 
Delete the unique constraint called {UQConstraintName}.
2.1.
E.g.
--ALTER TABLE Gamer
--DROP CONSTRAINT UQ_Gamer_Email;
In Gamer table, 
Delete the unique constraint called UQ_Gamer_Email.
*/





--====================================================================================================
--T001_04
--Foreign Key

/*
What to learn
- Foreign Key Constraint
- No Action/Cascade/Set NULL/SetDefault
*/

---------------------------------------------------------------------------------------------------------
--T001_04_01
SELECT  *
FROM    Gender;

SELECT  *
FROM    Gender
WHERE   Id = 1;

SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch
/*
1.
* means all columns
1.1.
--SELECT  *
--FROM    Gender;
Get all columns from Gender Table.
1.2.
--SELECT  *
--FROM    Gamer;
Get all columns from Gamer Table.
1.3.
--SELECT  *
--FROM    Gender
--WHERE   Id = 1;
Get all columns from Gender Table,
Filter the rows where id must be 1.
*/

---------------------------------------------------------------------------------------------------------
--T001_04_02
--Get the information of the foreign key constraint called "FK_Gender_Gamer"
SELECT  *
FROM    INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE   CONSTRAINT_NAME = 'FK_Gender_Gamer';

---------------------------------------------------------------------------------------------------------
--T001_04_03
--ON DELETE NO ACTION;  this is the default setting of the foreign key constraint.

--Create or Recreate the foreign key constraint 
--Delete the the foreign key constraint if it exists
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
              WHERE     CONSTRAINT_NAME = 'FK_Gender_Gamer' ) )
    BEGIN
        ALTER TABLE Gamer
        DROP CONSTRAINT FK_Gender_Gamer;
    END;
GO -- Run the previous command and begins new batch
--Create the foreign key constraint 
ALTER TABLE Gamer ADD CONSTRAINT FK_Gender_Gamer
FOREIGN KEY (GenderId) REFERENCES Gender(Id)
ON DELETE NO ACTION;
GO -- Run the prvious command and begins new batch

-- Delete Rule is No Action
DELETE  FROM Gender
WHERE   Id = 1;

SELECT  *
FROM    Gender;
SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

/*
1.
---- Delete Rule is No Action
--DELETE  FROM Gender
--WHERE   Id = 1;
1.1.
Output as the following
--Msg 547, Level 16, State 0, Line 764
--The DELETE statement conflicted with the REFERENCE constraint "FK_Gender_Gamer". 
--The conflict occurred in database "Sample", table "dbo.Gamer", column 'GenderId'.
--The statement has been terminated.
1.2.
We can not do delete the Gender with id is 1,
because the id 1 gender value is currently still used in Gamer Table.
1.3.
You may delete 
--ON DELETE NO ACTION;
because, Foreign key is "ON DELETE NO ACTION" by default setting.
This means when you delete valueA in Gender Table, 
If the valueA is still used in Gamer table,
then do nothing which means 
valueA can not be deleted if it is still used in other table.
*/


---------------------------------------------------------------------------------------------------------
--T001_04_04
--ON DELETE CASCADE;

--Create or Recreate the foreign key constraint 
--Delete the the foreign key constraint if it exists
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
              WHERE     CONSTRAINT_NAME = 'FK_Gender_Gamer' ) )
    BEGIN
        ALTER TABLE Gamer
        DROP CONSTRAINT FK_Gender_Gamer;
    END;
GO -- Run the previous command and begins new batch
--Create the foreign key constraint 
ALTER TABLE Gamer ADD CONSTRAINT FK_Gender_Gamer
FOREIGN KEY (GenderId) REFERENCES Gender(Id)
ON DELETE CASCADE;
GO -- Run the prvious command and begins new batch

SELECT  *
FROM    Gender;
SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

-- Delete Rule is Cascade
DELETE  FROM Gender
WHERE   Id = 1;

SELECT  *
FROM    Gender;
SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

/*
1.
---- Delete Rule is No Action
--DELETE  FROM Gender
--WHERE   Id = 1;
When we delete the the Gender id 1 row from the Gender Table.
It also delete the Gender id 1 row from Gamer Table.
1.1.
Because of the delete rule is Cascade
When 
--DELETE  FROM Gender
--WHERE   Id = 1;
It also do the following
--DELETE  FROM Gamer
--WHERE   GenderId = 1;
*/


---------------------------------------------------------------------------------------------------------
--T001_04_05
--ON DELETE SET DEFAULT;

--Create or Recreate the foreign key constraint 
--Delete the the foreign key constraint if it exists
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
              WHERE     CONSTRAINT_NAME = 'FK_Gender_Gamer' ) )
    BEGIN
        ALTER TABLE Gamer
        DROP CONSTRAINT FK_Gender_Gamer;
    END;
GO -- Run the previous command and begins new batch
--Create the foreign key constraint 
ALTER TABLE Gamer ADD CONSTRAINT FK_Gender_Gamer
FOREIGN KEY (GenderId) REFERENCES Gender(Id)
ON DELETE SET DEFAULT;
GO -- Run the prvious command and begins new batch

SELECT  *
FROM    Gender;
SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

-- Delete Rule is DEFAULT
DELETE  FROM Gender
WHERE   Id = 2;

SELECT  *
FROM    Gender;
SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

/*
1.
---- Delete Rule is DEFAULT
--DELETE  FROM Gender
--WHERE   Id = 2;
Previously, We set the default constraint of GenderId column in Gamer table.
The default value of [Gamer].[GenderId] is 3.
When we delete the Id 2 row from Gender Table.
It will set the GenderId in Gamer table to default value which is 3.
1.1.
That means when we do the following.
--DELETE  FROM Gender
--WHERE   Id = 2;
It will also do the following.
--UPDATE Gamer
--SET GenderId = 3
--WHERE GenderId = 2;
*/


---------------------------------------------------------------------------------------------------------
--T001_04_06
--ON DELETE SET NULL;

--Create or Recreate the foreign key constraint 
--Delete the the foreign key constraint if it exists
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
              WHERE     CONSTRAINT_NAME = 'FK_Gender_Gamer' ) )
    BEGIN
        ALTER TABLE Gamer
        DROP CONSTRAINT FK_Gender_Gamer;
    END;
GO -- Run the previous command and begins new batch
--Create the foreign key constraint 
ALTER TABLE Gamer ADD CONSTRAINT FK_Gender_Gamer
FOREIGN KEY (GenderId) REFERENCES Gender(Id)
ON DELETE SET NULL;
GO -- Run the prvious command and begins new batch

SELECT  *
FROM    Gender;
SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

-- Delete Rule is SET NULL
DELETE  FROM Gender
WHERE   Id = 3;

SELECT  *
FROM    Gender;
SELECT  *
FROM    Gamer;
GO -- Run the prvious command and begins new batch

/*
1.
---- Delete Rule is SET NULL
--DELETE  FROM Gender
--WHERE   Id = 3;
When we delete the Id 3 row from Gender Table.
It will set the GenderId in Gamer table to NULL value.
1.1.
That means when we do the following.
--DELETE  FROM Gender
--WHERE   Id = 3;
It will also do the following.
--UPDATE Gamer
--SET GenderId = NULL
--WHERE GenderId = 3;
*/









--====================================================================================================
--T001_05
--Clean up

--Drop Table if it exists
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Gamer' ) )
    BEGIN
        TRUNCATE TABLE Gamer;
        DROP TABLE Gamer;
    END;
GO -- Run the previous command and begins new batch

--Drop Table if it exists
IF ( EXISTS ( SELECT    *
              FROM      INFORMATION_SCHEMA.TABLES
              WHERE     TABLE_NAME = 'Gender' ) )
    BEGIN
        TRUNCATE TABLE Gender;
        DROP TABLE Gender;
    END;
GO -- Run the previous command and begins new batch


/*
1.
-- TRUNCATE TABLE dbo.tblPerson2;
and
--DELETE  dbo.tblPerson2
are both doing the same thing to delete every data in the table.
However, TRUNCATE TABLE is better
because TRUNCATE TABLE will delete the data and clean up the space.
DELETE will delete the data without clean up the space.
It is more possible to cause data fragmentation.

2.
--DROP TABLE Gender;
Delete the table.
*/





