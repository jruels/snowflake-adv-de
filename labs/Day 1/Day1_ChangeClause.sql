USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY1;
USE SCHEMA RAW;


--STEP 1 CREATE TABLE T1
CREATE OR REPLACE TABLE t1 (
   id number(8) NOT NULL,
   c1 varchar(255) default NULL
 );

-- STEP 2 Enable change tracking on the table.
 ALTER TABLE t1 SET CHANGE_TRACKING = TRUE;


 -- STEP 3 Initialize a session variable for the current timestamp.
 SET ts1 = (SELECT CURRENT_TIMESTAMP());

 
 --STEP 4 INSERT RECORDS INTO T1 TABLE
 INSERT INTO t1 (id,c1)
 VALUES
 (1,'red'),
 (2,'blue'),
 (3,'green');


 --STEP 5 DELETE RECORDS FROM T1 TABLE
 DELETE FROM t1 WHERE id = 1;


 --STEP 6 UPDATE RECORDS FROM T1 TABLE
 UPDATE t1 SET c1 = 'purple' WHERE id = 2;


 -- STEP 7 - Query the change tracking metadata in the table during the interval from $ts1 to the current time.
 SELECT *
 FROM t1
   CHANGES(INFORMATION => DEFAULT)
   AT(TIMESTAMP => $ts1);



 -- STEP 8 Query the change tracking metadata in the table during the interval from $ts1 to the current time.
 -- Return the append-only changes.
 SELECT *
 FROM t1
   CHANGES(INFORMATION => APPEND_ONLY)
   AT(TIMESTAMP => $ts1);


