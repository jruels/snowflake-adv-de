USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY1;
USE SCHEMA RAW;

/*=============Repeatable read isolation========

Streams support repeatable read isolation. In repeatable read mode, multiple SQL
statements within a transaction see the same set of records in a stream. 

================================================*/


CREATE OR REPLACE TABLE EMPLOYEES_REPEATABLE_ISOLATION(
ID NUMBER,
NAME VARCHAR(50),
SALARY NUMBER
);

CREATE OR REPLACE STREAM REPEATABLE_STREAM ON TABLE EMPLOYEES_REPEATABLE_ISOLATION;

--Initial Version

SELECT * FROM REPEATABLE_STREAM;

--Insert three records into table
INSERT INTO EMPLOYEES_REPEATABLE_ISOLATION VALUES (101,'Tony',25000);

--Initiate a transaction1
BEGIN;

SELECT * FROM REPEATABLE_STREAM;

--Initiate a transaction2
BEGIN;

INSERT INTO EMPLOYEES_REPEATABLE_ISOLATION VALUES (104,'Srini',40000);

COMMIT;
