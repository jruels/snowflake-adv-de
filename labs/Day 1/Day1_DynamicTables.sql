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


--Insert three records into table
INSERT INTO EMPLOYEES_RAW VALUES (101,'Tony',25000);
INSERT INTO EMPLOYEES_RAW VALUES (102,'Chris',55000);
INSERT INTO EMPLOYEES_RAW VALUES (103,'Bruce',40000);

--Check the employee raw data
SELECT * FROM EMPLOYEES_RAW;


--DROP Table

DROP DYNAMIC TABLE EMPLOYEE;

--STEP 6 Create Dynamic Table:
CREATE or replace DYNAMIC TABLE EMPLOYEE 
TARGET_LAG = '1 minute'
  WAREHOUSE = COMPUTE_WH
  AS
SELECT ID,NAME,SALARY FROM EMPLOYEES_RAW;

--Check the dynamic table
SELECT * FROM EMPLOYEE;

--Insert two records
INSERT INTO EMPLOYEES_RAW VALUES (104,'Clark',35000);
INSERT INTO EMPLOYEES_RAW VALUES (105,'Steve',30000);

--Update two records
UPDATE EMPLOYEES_RAW SET SALARY = '50000' WHERE ID = '102';
UPDATE EMPLOYEES_RAW SET SALARY = '45000' WHERE ID = '103';


--Check the dynamic table refresh status

SELECT * FROM
  TABLE (
    INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY (
      NAME_PREFIX => 'DAY1.RAW.EMPLOYEE'
    )
  );



/*============Types of Refresh============

1. Incremental -- Snowflake will determine if it can identify the changed records and merge only the changed records

2. Full Refresh --If Snowflake cannot identify the changed records, it will continue with full refresh which incurs more cost.

========================================*/


/*============Target Lag============

TARGET_LAG = '10 minute' -- This means that maximum amount of time that the dynamic table’s 
content should lag behind updates to the base table.

TARGET_LAG = DOWNSTREAM --  Specifies that the dynamic table should be refreshed on
demand when other dynamic tables depending on it need to refresh.

========================================*/