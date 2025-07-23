USE ROLE ACCOUNTADMIN;

---Enabling the mutlicluster warehouse

CREATE OR REPLACE WAREHOUSE NEW_COMPUTE_WH
  WITH
    WAREHOUSE_SIZE = 'XSMALL'  -- You can choose from 'XSMALL', 'SMALL', 'MEDIUM', 'LARGE', 'XLARGE', etc.
    MAX_CLUSTER_COUNT = 4      -- The maximum number of clusters Snowflake can scale up to
    MIN_CLUSTER_COUNT = 1       -- The minimum number of clusters to maintain
    SCALING_POLICY = 'STANDARD'  -- This controls the scaling behavior (options: 'ECONOMY', 'STANDARD')
    AUTO_SUSPEND = 300          -- The number of seconds to wait before suspending the warehouse when idle
    AUTO_RESUME = TRUE;         -- Whether the warehouse should automatically resume when a query is run


USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NEW_COMPUTE_WH;

--Alter session the session not to use the query cache
ALTER SESSION SET USE_CACHED_RESULT = FALSE;



USE ROLE ACCOUNTADMIN;
USE WAREHOUSE NEW_COMPUTE_WH;

--XS
SELECT
C_CUSTKEY,
SUM(O_TOTALPRICE) TOTAL_SALES,
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.ORDERS O
INNER JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER C -- ON O.O_CUSTKEY=C.C_CUSTKEY
GROUP BY C_CUSTKEY ;