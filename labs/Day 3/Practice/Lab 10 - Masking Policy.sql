--STEP 1 Set Context
use role accountadmin;
use warehouse compute_wh;


--step 2 create database for lab/set context
CREATE DATABASE IF NOT EXISTS lab_db;
USE DATABASE lab_db;

--step 3 create schema for lab/set context
CREATE SCHEMA IF NOT EXISTS lab_schema;
USE SCHEMA lab_schema;

--step 4 create table
CREATE OR REPLACE table  employees (
    id INT AUTOINCREMENT,
    name STRING,
    email STRING,
    salary FLOAT,
    PRIMARY KEY(id)
);


--step 5 insert data into table
INSERT INTO employees (name, email, salary) VALUES
('Alice', 'alice@example.com', 70000),
('Bob', 'bob@example.com', 80000),
('Charlie', 'charlie@example.com', 90000);


--step 6 create masking policy 
CREATE OR REPLACE MASKING POLICY salary_mask AS (val FLOAT) RETURNS FLOAT ->
  CASE
    WHEN CURRENT_ROLE() IN ('SYSADMIN') THEN val
    ELSE NULL
  END;

--step 7 set masking policy on table  
ALTER TABLE employees MODIFY COLUMN salary SET MASKING POLICY salary_mask;

--step 8 see table employee through accountadmin role;
SELECT * FROM employees;


--step 9 grant priviliges to sysadmin
USE ROLE ACCOUNTADMIN;
GRANT USAGE ON DATABASE lab_db TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA lab_schema TO ROLE SYSADMIN;
GRANT SELECT ON TABLE EMPLOYEES TO ROLE SYSADMIN;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE SYSADMIN;

--step 10 use sysadmin role to query data
USE ROLE SYSADMIN;

SELECT * FROM EMPLOYEES;

  
