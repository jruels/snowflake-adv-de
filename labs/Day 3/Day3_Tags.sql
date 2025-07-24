USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY3;
USE SCHEMA RAW;

--create table employee
CREATE OR REPLACE TABLE employees (
    id INT,
    name STRING,
    department STRING,
    salary DECIMAL,
    email VARCHAR
);

--How to create a TAG
CREATE TAG sensitivity_tag COMMENT = 'Classifies data sensitivity';

--Set sensitivity as high
ALTER TABLE employees SET TAG sensitivity_tag = 'high';

-- Assign tag to a column
ALTER TABLE employees MODIFY COLUMN email SET TAG sensitivity_tag = 'pii';


-- Show tags on the table
select * from table(day3.information_schema.tag_references_all_columns('employees', 'table'));

--
SELECT * 
FROM SNOWFLAKE.ACCOUNT_USAGE.TAG_REFERENCES
WHERE TAG_NAME = 'SENSITIVITY_TAG' AND TAG_VALUE = 'high';

