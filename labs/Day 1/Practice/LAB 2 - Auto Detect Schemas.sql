--STEP 1 - SET USER ACCOUNT AND WAREHOUSE
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

--SETP 2 - CREATE DATABASE IF IT DOESN'T EXIST
CREATE OR REPLACE DATABASE CITIBIKE;


--STEP 3 -- SET DATBASE CONTEXT
USE DATABASE CITIBIKE;


--STEP 4 -- SET SCHEMA CONTEXT
USE SCHEMA PUBLIC;


--STEP 5 -- CREATE EXTERNAL STAGE
CREATE OR REPLACE STAGE "CITIBIKE"."PUBLIC".citibike_trips URL = 's3://snowflake-workshop-lab/citibike-trips-json';


--STEP 6 -- CREATE JSON FILE FORMAT 
CREATE OR REPLACE FILE FORMAT my_json_format
TYPE = json;


--STEP 7 - SEE CONTENTS OF EXTERNAL STAGE
LIST @citibike_trips;


--STEP 8 -- SEE RESULTS USING INFER_SCHEMA FUNCTION

--THIS MIGHT TAKE A BIT OF TIME AS SNOWFLAKE IS QUERYING THROUGH THE ENTIRE STAGE
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION => '@citibike_trips'
      , FILE_FORMAT=>'my_json_format'
      )
    );


--STEP 9 -- SEE RESULTS USING INFER_SCHEMA FUNCTION BUT WITH ONLY ONE FILE
-- THIS SHOULD BE MUCH FASTER
SELECT *
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION => '@citibike_trips'
      ,FILES => '2013-06-01/data_01a304b5-0601-4bbe-0045-e8030021523e_005_7_2.json.gz'
      , FILE_FORMAT=>'my_json_format'
      )
    );


--SETP 10 - USE GENERATE_GENERATE_COLUMN_DESCRIPTION FUNCITON TO GET COLUMN NAMES 
    
SELECT GENERATE_COLUMN_DESCRIPTION(ARRAY_AGG(OBJECT_CONSTRUCT(*)), 'table') AS COLUMNS
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION => '@citibike_trips'
      ,FILES => '2013-06-01/data_01a304b5-0601-4bbe-0045-e8030021523e_005_7_2.json.gz'
      , FILE_FORMAT=>'my_json_format'
      )
    );


--STEP 11 - CREATE TABLE USING THE OUTPUT OF GENERATE COLUMN FUNCTION

CREATE TABLE MYTABLE ("BIKE" OBJECT,
"ENDTIME" TIMESTAMP_NTZ,
"END_STATION_ID" NUMBER(4, 0),
"RIDER" OBJECT,
"STARTTIME" TIMESTAMP_NTZ,
"START_STATION_ID" NUMBER(4, 0));


--STEP 12 - DESCRIBE RECENTLY CREATED TABLE 
DESCRIBE TABLE MYTABLE;



--STEP 13 - ALTERNATIVE WAY TO CREATE TABLE 
CREATE TABLE MYTABLE2
USING TEMPLATE
(SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) AS COLUMNS
  FROM TABLE(
    INFER_SCHEMA(
      LOCATION => '@citibike_trips'
      ,FILES => '2013-06-01/data_01a304b5-0601-4bbe-0045-e8030021523e_005_7_2.json.gz'
      , FILE_FORMAT=>'my_json_format'
      )
    ));


--STEP 14 - DESCRIBE THE SECOND CREATED TABLE
DESCRIBE TABLE MYTABLE2;



--STEP 15 - COPY DATA FROM EXTERNAL STAGE INTO MYTABLE
-- This operation will take some time
COPY INTO MYTABLE from @citibike_trips FILE_FORMAT = (FORMAT_NAME= 'my_json_format') MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE;


--STEP 16 - QUERY FIRST TABLE
SELECT * from MYTABLE LIMIT 100;


--STEP 17 - COPY DATA FROM EXTERNAL STAGE INTO MYTABLE2
-- This operation will take some time
COPY INTO MYTABLE2 from @citibike_trips FILE_FORMAT = (FORMAT_NAME= 'my_json_format') MATCH_BY_COLUMN_NAME=CASE_INSENSITIVE;

--STEP 18 - QUERY MYTABLE2
SELECT * FROM MYTABLE2 LIMIT 100;

--STEP 19 -- DELETE DATBASE
DROP DATABASE CITIBIKE;

