USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY3;
USE SCHEMA RAW;

CREATE OR REPLACE TABLE employees (
    id INT,
    name STRING,
    ssn STRING
);

INSERT INTO employees (id, name, ssn) VALUES
(1, 'John Doe', '123-45-6789'),
(2, 'Jane Smith', '987-65-4321'),
(3, 'Sam Brown', '456-78-9012');


--GRANT  the Database, Schema, and Table access to SYSADMIN role
--GRANT the compute_wh access to SYSADMIN role

GRANT USAGE ON DATABASE DAY3 TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA DAY3.RAW TO ROLE SYSADMIN;
GRANT SELECT ON TABLE DAY3.RAW.employees TO ROLE SYSADMIN;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE SYSADMIN;

--GRANT  the Database, Schema, and Table access to PUBLI role
--GRANT the compute_wh access to PUBLIC role

GRANT USAGE ON DATABASE DAY3 TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA DAY3.RAW TO ROLE PUBLIC;
GRANT SELECT ON TABLE DAY3.RAW.employees TO ROLE PUBLIC;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE PUBLIC;



CREATE OR REPLACE MASKING POLICY ssn_masking_policy
  AS (val STRING) 
  RETURNS STRING ->
    CASE
      WHEN CURRENT_ROLE() IN ('SYSADMIN') THEN val  -- Admin roles see full SSN
      ELSE CONCAT('XXX-XX-', RIGHT(val, 4))  -- Other roles see masked SSN
    END;



ALTER TABLE employees MODIFY COLUMN ssn SET MASKING POLICY ssn_masking_policy;

CREATE ROLE sysadmin_role;
CREATE ROLE public_role;


/*=======
Since we are using SYSADMIN role, we can see
the unmasked SSN value
=========*/
USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY3;
USE SCHEMA RAW;

SELECT * FROM employees;

/*=======
Since we are using PUBLIC role, we can see
the masked SSN value
=========*/

USE ROLE PUBLIC;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY3;
USE SCHEMA RAW;

SELECT * FROM employees;