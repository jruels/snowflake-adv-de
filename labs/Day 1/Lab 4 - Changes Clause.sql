--STEP 1 SET CONTEXT

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;


--STEP 2 CREATE DATABASE LAB_CHANGES
CREATE OR REPLACE DATABASE LAB_CHANGES;

-- STEP 3 SET CONTEXT FOR DATABASE + SCHEMA
USE DATABASE LAB_CHANGES;
USE SCHEMA PUBLIC;


--STEP 4 CREATE TABLE T1
CREATE OR REPLACE TABLE t1 (
   id number(8) NOT NULL,
   c1 varchar(255) default NULL
 );

-- STEP 5 Enable change tracking on the table.
 ALTER TABLE t1 SET CHANGE_TRACKING = TRUE;

 -- STEP 6 Initialize a session variable for the current timestamp.
 SET ts1 = (SELECT CURRENT_TIMESTAMP());


 --STEP 7 INSERT RECORDS INTO T1 TABLE
 INSERT INTO t1 (id,c1)
 VALUES
 (1,'red'),
 (2,'blue'),
 (3,'green');

 
 --STEP 8 DELETE RECORDS FROM T1 TABLE
 DELETE FROM t1 WHERE id = 1;

 

 --STEP 9 UPDATE RECORDS FROM T1 TABLE
 UPDATE t1 SET c1 = 'purple' WHERE id = 2;

 
 
 -- STEP 10 - Query the change tracking metadata in the table during the interval from $ts1 to the current time.
 SELECT *
 FROM t1
   CHANGES(INFORMATION => DEFAULT)
   AT(TIMESTAMP => $ts1);



 -- STEP 11 Query the change tracking metadata in the table during the interval from $ts1 to the current time.
 -- Return the append-only changes.
 SELECT *
 FROM t1
   CHANGES(INFORMATION => APPEND_ONLY)
   AT(TIMESTAMP => $ts1);


-- STEP 10 DROP DATABASE
DROP DATABASE LAB_CHANGES;


