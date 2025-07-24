USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY3;
USE SCHEMA RAW;

/*==============Create ROLES=======*/

CREATE OR REPLACE ROLE HR_ROLE;
CREATE OR REPLACE  ROLE FINANCE_ROLE;

-- Create users
CREATE or replace USER hr_user PASSWORD='password';
CREATE or replace USER finance_user PASSWORD='password';

--employee table creation
CREATE OR REPLACE TABLE employees (
    id INT,
    name STRING,
    department STRING,
    salary DECIMAL
);

-- Assign roles to users
GRANT ROLE HR_ROLE TO USER hr_user;
GRANT ROLE FINANCE_ROLE TO USER finance_user;

GRANT USAGE ON DATABASE DAY3 TO ROLE HR_ROLE;
GRANT USAGE ON SCHEMA DAY3.RAW TO ROLE HR_ROLE;
GRANT SELECT ON TABLE DAY3.RAW.employees TO ROLE HR_ROLE;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE HR_ROLE;


GRANT USAGE ON DATABASE DAY3 TO ROLE FINANCE_ROLE;
GRANT USAGE ON SCHEMA DAY3.RAW TO ROLE FINANCE_ROLE;
GRANT SELECT ON TABLE DAY3.RAW.employees TO ROLE FINANCE_ROLE;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE FINANCE_ROLE;



INSERT INTO employees (id, name, department, salary) VALUES
(1, 'John Doe', 'HR', 55000),
(2, 'Jane Smith', 'Finance', 75000),
(3, 'Sam Brown', 'IT', 62000),
(4, 'Emily White', 'Finance', 80000),
(5, 'Mike Black', 'HR', 52000);


/*


*/

CREATE OR REPLACE ROW ACCESS POLICY dept_filter_policy
  AS (department STRING)
  RETURNS BOOLEAN ->
    CASE
      WHEN CURRENT_ROLE() = 'HR_ROLE' THEN TRUE    -- HR users can see all rows
      WHEN CURRENT_ROLE() = 'FINANCE_ROLE' THEN (department = 'Finance')  -- Finance users see only Finance employees
      ELSE FALSE  -- All other roles see no rows
    END;



ALTER TABLE employees 
  ADD ROW ACCESS POLICY dept_filter_policy
  ON (department);



/*============Testing===========

If we choose HR role, we can all records from the 
table

===============================*/

USE ROLE hr_role;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY3;
USE SCHEMA RAW;

select * from DAY3.RAW.EMPLOYEES;


/*============Testing===========

If we choose Finance role, we can all records from the 
table

===============================*/

USE ROLE finance_role;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY3;
USE SCHEMA RAW;

select * from DAY3.RAW.EMPLOYEES;
