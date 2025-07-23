USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE SNOWFLAKE_FUNDAMENTALS;
USE SCHEMA DAY2;


--Create a table
CREATE OR REPLACE TABLE EMPLOYEES_RAW(
ID NUMBER,
NAME VARCHAR(50),
SALARY NUMBER
);

--Insert three records into table
INSERT INTO EMPLOYEES_RAW VALUES (101,'Tony',25000);
INSERT INTO EMPLOYEES_RAW VALUES (102,'Chris',55000);
INSERT INTO EMPLOYEES_RAW VALUES (103,'Bruce',40000);

ALTER WAREHOUSE COMPUTE_WH SUSPEND;

SELECT COUNT(1) FROM EMPLOYEES_RAW; -- META DATA TYPE 

/*=============Increase Warehouse Size===========
The below has 1.5B records, so we need to increase
the Warehouse size from XS to M

=============================================*/

ALTER WAREHOUSE COMPUTE_WH SET WAREHOUSE_SIZE = 'MEDIUM';

/*=============Results Cache============

The Results Cache holds the results set of every query executed in the past 24 hours. 
These are available across all virtual warehouses, and results returned to one user 
may be used by any other user on the system provided they execute the same query 
and the underlying data remains unchanged.

======================================*/

SELECT
C_NAME,
SUM(O_TOTALPRICE) TOTAL_SALES,
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.ORDERS O
INNER JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER C ON O.O_CUSTKEY=C.C_CUSTKEY
GROUP BY C_NAME LIMIT 10;

01bc7944-0001-dd47-0002-5baa000521de-- | 46 seconds
01bc7947-0001-dcbe-0002-5baa0004cd76 -- | 99MS

/*=============Local Storage Cache============

This is used to cache raw data from SQL queries. Data fetched from slower remote 
storage is cached in faster SSD and memory, which virtual warehouse queries can use.

SSD -- 
LRU (LEAST RECENTLY USED)

===========================================*/

SELECT
O_ORDERKEY, 
O_CUSTKEY, 
O_ORDERSTATUS, 
O_TOTALPRICE, 
O_ORDERDATE, 
O_ORDERPRIORITY, 
O_CLERK, 
--O_SHIPPRIORITY, 
O_COMMENT
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.ORDERS 
WHERE O_ORDERKEY=3871487840;

--01bc794e-0001-dc74-0002-5baa00046342 2.3S
--01bc794f-0001-dd61-0002-5baa000561ea 1.1S

/*=============Remote Cache==============

Provides long-term data storage and resilience. On Amazon Web Services,
this means 99.999999999% durability, even in the event of an entire data center failure.

===========================================*/

SELECT
O_ORDERKEY, 
O_CUSTKEY, 
O_ORDERSTATUS, 
O_TOTALPRICE, 
O_ORDERDATE, 
O_ORDERPRIORITY, 
O_CLERK, 
--O_SHIPPRIORITY, 
O_COMMENT
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.ORDERS 
WHERE O_ORDERKEY=3870515618;
