--STEP 1 SET CONTEXT

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;


--STEP 2 CREATE DATABASE LAB_DYNAMIC
CREATE OR REPLACE DATABASE LAB_DYNAMIC;

-- STEP 3 SET CONTEXT FOR DATABASE + SCHEMA
USE DATABASE LAB_DYNAMIC;
USE SCHEMA PUBLIC;

--STEP 4 Create Source Tables:

CREATE TABLE source_table1 (id INT, value VARCHAR);

CREATE TABLE source_table2 (id INT, value VARCHAR);


--STEP 5 Populate Source Tables:

INSERT INTO source_table1 VALUES (1, 'A'), (2, 'B'), (3, 'C');

INSERT INTO source_table2 VALUES (1, 'X'), (2, 'Y'), (3, 'Z');


--STEP 6 Create Dynamic Table:
CREATE or replace DYNAMIC TABLE dynamic_table 
TARGET_LAG = '1 minute'
  WAREHOUSE = COMPUTE_WH
  AS
SELECT a.id, a.value AS value1,
b.value AS value2
FROM source_table1 a
left JOIN source_table2 b ON a.id = b.id;


--STEP 7 View Dynamic Table Content:
SELECT * FROM dynamic_table;


--STEP 8 - INSERT additonal data into source
INSERT INTO source_table1 VALUES (4, 'D');
INSERT INTO source_table1 VALUES (5, 'E');


--STEP 9 - QUERY DYNAMIC TABLE (MIGHT HAVE TO WAIT 1 MINUTE TO SEE NEW RESULTS)
SELECT * FROM dynamic_table;


--STEP 10 DELETE data in Source
DELETE FROM SOURCE_TABLE1 WHERE ID IN (4,5);


--STEP 11 - WAIT 1 MINUTE
SELECT * FROM DYNAMIC_TABLE;


--STEP 12 UPDATE data in Source
UPDATE SOURCE_TABLE1
SET value = 'AA'
where ID = 1;

--STEP 13 WAIT 1 MINUTE
select * from dynamic_table;


--STEP 14 
DROP DATABASE LAB_DYNAMIC;





