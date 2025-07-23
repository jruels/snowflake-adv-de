USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE SNOWFLAKE;
USE SCHEMA ACCOUNT_USAGE;

/*
Snowflake offers two types of feature to 
check the activity in your snowflake account

1.Latency factor
2.Holds the information for an year
3.Includes dropped objects

*/

SHOW VIEWS;

/*
Query history view is one of the key object to verify the
query history for the last year. It can be used for multiple reasons

1. Identify long running queries
2. Identify queries which are spilling storage
3. Identify queries which are failed in last few days
*/

SELECT * FROM QUERY_HISTORY LIMIT 10;

--Long running queries example

SELECT
QUERY_ID,
START_TIME,
END_TIME,
DATABASE_NAME,
SCHEMA_NAME,
QUERY_TEXT
FROM
QUERY_HISTORY
WHERE EXECUTION_TIME >=10*60000 ;--10 MINS


--Spilled Queries , which spilled storage to local disk
--Possible candidate for ScaleUp

SELECT
QUERY_ID,
START_TIME,
END_TIME,
DATABASE_NAME,
SCHEMA_NAME,
QUERY_TEXT
FROM
QUERY_HISTORY
WHERE BYTES_SPILLED_TO_REMOTE_STORAGE>10000000000;--10GB


---Queries which are failed in the last few days

SELECT
QUERY_ID,
START_TIME,
END_TIME,
DATABASE_NAME,
SCHEMA_NAME,
QUERY_TEXT,
ERROR_MESSAGE
FROM
QUERY_HISTORY
WHERE EXECUTION_STATUS='FAIL'
AND START_TIME>=CURRENT_DATE()-2;



/*
Similar to query_history we have tables for
1.Copy History
2 Task History
3 Warehouse metering History etc
*/

--COPY HISTORY
SELECT * FROM COPY_HISTORY LIMIT 10;


--TASK HISTORY
SELECT * FROM TASK_HISTORY LIMIT 10;


--METERING HISTORY
SELECT * FROM WAREHOUSE_METERING_HISTORY LIMIT 10;
