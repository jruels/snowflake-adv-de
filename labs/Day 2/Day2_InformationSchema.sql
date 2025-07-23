USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE SNOWFLAKE;
USE SCHEMA INFORMATION_SCHEMA;

/*
Snowflake offers few tables functions which provide the activity 
without any latency unlike the Account Usage views.
1. No Latency 
2. Data Available for 7-14  days only, few have more than that. Please refer the official documentation
3. Doesnot include dropped objects
*/

--Query History Table Function

SELECT * FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
ORDER BY start_time desc;


--Task History Table Function

SELECT * FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
ORDER BY SCHEDULED_TIME;
