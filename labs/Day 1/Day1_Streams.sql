/*==============================STREAMS==================

CDC - Change Data Capture

Stream: A stream object records data manipulation language (DML) changes made to tables, including inserts (including COPY INTO), updates, and deletes, as well as metadata about each change, so that actions can be taken using the changed data

Types of Stream: STANDARD, APPEND_ONLY, INSERT_ONLY

Repeatable Read Isolation:

Staleness:

========================================================*/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY1;
USE SCHEMA RAW;


--create employees_raw table
CREATE OR REPLACE TABLE EMPLOYEES_RAW(
ID NUMBER,
NAME VARCHAR(50),
SALARY NUMBER
);

--https://docs.snowflake.com/en/_images/table-streams-offset.png

--Insert three records into table
INSERT INTO EMPLOYEES_RAW VALUES (101,'Tony',25000);
INSERT INTO EMPLOYEES_RAW VALUES (102,'Chris',55000);
INSERT INTO EMPLOYEES_RAW VALUES (103,'Bruce',40000);


--create employees table
CREATE OR REPLACE TABLE EMPLOYEES(
ID NUMBER,
NAME VARCHAR(50),
SALARY NUMBER
);


--Inserting initial set of records from raw table
INSERT INTO EMPLOYEES SELECT * FROM EMPLOYEES_RAW;

--create stream
CREATE OR REPLACE STREAM MY_STREAM ON TABLE EMPLOYEES_RAW;

--Insert two records
INSERT INTO EMPLOYEES_RAW VALUES (104,'Clark',35000);
INSERT INTO EMPLOYEES_RAW VALUES (105,'Steve',30000);

--Update two records
UPDATE EMPLOYEES_RAW SET SALARY = '50000' WHERE ID = '102';
UPDATE EMPLOYEES_RAW SET SALARY = '45000' WHERE ID = '103';


--Delete one record
DELETE FROM EMPLOYEES_RAW WHERE ID = '102';


--Check the stream
SELECT * FROM MY_STREAM;

MERGE INTO EMPLOYEES a USING MY_STREAM b ON a.ID = b.ID
WHEN MATCHED AND metadata$action = 'DELETE' AND metadata$isupdate =
'FALSE'
THEN DELETE
WHEN MATCHED AND metadata$action = 'INSERT' AND metadata$isupdate =
'TRUE'
THEN UPDATE SET a.NAME = b. NAME, a.SALARY = b.SALARY
WHEN NOT MATCHED AND metadata$action = 'INSERT' AND metadata$isupdate
= 'FALSE'
THEN INSERT (ID, NAME, SALARY) VALUES (b.ID, b.NAME, b.SALARY);
SELECT * FROM EMPLOYEES;



/*=============Types of Streams======

Types of Stream: 

STANDARD: Tracks all DML transactions

APPEND_ONLY: Tracks only INSERT DML, (DELETE AND UPDATE are ignored)

INSERT_ONLY (Exclusive for external tables): Tracks only INSERT DML. Ignoring delete operations

=====================================*/



/*=============Stale Stream=============

A stream becomes stale when its offset is beyond the data retention period of its source table. 
When stale, historical data becomes inaccessible.

if unconsumed, Snowflake can extend retention up to 14 days by default to avoid staleness.

If a source table/view is recreated, any stream on it becomes stale.

Cloning a database or schema makes unconsumed records in the cloned stream inaccessible.

Renaming doesn't break or stale a stream. Dropping and recreating an object with the same name doesn't link old streams to the new
object.

if stream become stale, recreate it.

==========================================*/

--create employees table
CREATE OR REPLACE TABLE EMPLOYEES_STALE(
ID NUMBER,
NAME VARCHAR(50),
SALARY NUMBER
);

--create stream
CREATE OR REPLACE STREAM MY_STREAM ON TABLE EMPLOYEES_STALE;

--Select stream
SELECT * FROM MY_STREAM;

--Describe Stream
DESCRIBE STREAM MY_STREAM;

--Insert data
INSERT INTO EMPLOYEES_STALE VALUES (101,'Tony',25000);



/*=========================STREAMS ON VIEW=======

Streams on Views Overview
● Streams can be applied to both local and shared views using Snowflake Secure Data Sharing.
● Not applicable for materialized views.
● Underlying tables for the views must be native tables.
● Change tracking should be enabled on the underlying tables.

Supported View Operations
● Projections
● Filters
● Inner or cross joins
● UNION ALL
● Nested views and subqueries in the FROM clause

Unsupported View Operations
● GROUP BY clauses
● QUALIFY clauses
● Subqueries not in the FROM clause
● Correlated subqueries
● LIMIT clauses


==============================================*/


