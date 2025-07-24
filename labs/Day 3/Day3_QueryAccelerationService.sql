/*=====================Query Acceleration Service============

Purpose: Enhance Snowflake's performance by efficiently processing demanding queries.

How it Works: Offloads parts of query processing to shared compute resources.


1. SYSTEM$ESTIMATE_QUERY_ACCELERATION 

2. QUERY_ACCELERATION_ELIGIBLE

=============================================================*/

--If you want to check if a previously executed query can benifit from QAS use the below

SELECT SYSTEM$ESTIMATE_QUERY_ACCELERATION('01bde2be-0002-19c7-0002-856a0006333e');


--If you want to identify the queries which can benifit from QAS, use the below view
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE LIMIT 10;


--To enable QAS on your warehouse

ALTER WAREHOUSE <<WH_NAME>> SET
ENABLE_QUERY_ACCELERATION=TRUE
QUERY_ACCELERATION_MAX_SCALE_FACTOR=<> --DEFAULT IS 8

--Scale factor of 5 means the serverless compute cost can't exceed 5 times the warehouse’s rate.
--For example, if you use a small warehouse and set a max scale factor of 4, the absolute maximum hourly QAS bill would be 8 credits (2 credits x 4
