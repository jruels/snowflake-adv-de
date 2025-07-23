USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY2;
USE SCHEMA RAW;


-- create employees_raw table
CREATE OR REPLACE TABLE EMPLOYEES_RAW(
ID NUMBER,
NAME VARCHAR(50),
SALARY NUMBER
);

-- create stream
CREATE OR REPLACE STREAM MY_STREAM ON TABLE EMPLOYEES_RAW;

-- Insert three records into table
INSERT INTO EMPLOYEES_RAW VALUES (101,'Tony',25000);
INSERT INTO EMPLOYEES_RAW VALUES (102,'Chris',55000);
INSERT INTO EMPLOYEES_RAW VALUES (103,'Bruce',40000);


-- create employees table
CREATE OR REPLACE TABLE EMPLOYEES(
ID NUMBER,
NAME VARCHAR(50),
SALARY NUMBER
);


--Create a stored procedure in javascript to execute the merge
CREATE OR REPLACE PROCEDURE merge_employees_from_stream()
RETURNS STRING
LANGUAGE JAVASCRIPT -- This can be written in SQL, Python and Java
AS
$$
var results = [];

try {
    results.push("Starting merge operation...");

    // Can execute some data quality tests before executing merge


    var sql_command = `
        MERGE INTO EMPLOYEES a USING MY_STREAM b ON a.ID = b.ID
            WHEN MATCHED AND metadata\$action = 'DELETE' AND metadata\$isupdate = 'FALSE'
                THEN DELETE
            WHEN MATCHED AND metadata\$action = 'INSERT' AND metadata\$isupdate = 'TRUE'
                THEN UPDATE SET a.NAME = b.NAME, a.SALARY = b.SALARY
            WHEN NOT MATCHED AND metadata\$action = 'INSERT' AND metadata\$isupdate = 'FALSE'
                THEN INSERT (ID, NAME, SALARY) VALUES (b.ID, b.NAME, b.SALARY);
    `;

    // Execute the MERGE
    var statement1 = snowflake.createStatement({ sqlText: sql_command });
    var resultSet = statement1.execute();


    //Can execute some reconciliation scripts


    //Combine the logging and pass back to UI.
    results.push("Merge operation completed.");
    return results.join('\n');

} catch (err) {
    results.push("Merge failed: " + err.message);
    return results.join('\n');
}
$$;


--Command to execute a procedure
CALL merge_employees_from_stream();

--Check the data
SELECT * FROM EMPLOYEES;

-- Automating the pipeline
CREATE OR REPLACE TASK MY_FIRST_DATA_PIPELINE
WAREHOUSE = COMPUTE_WH --(If no warehouse is provided, it will be a serverless task)
--TARGET_COMPLETION_INTERVAL='1 MINUTE' (required parameter for serverless tasks)
WHEN SYSTEM$STREAM_HAS_DATA('MY_STREAM')
AS CALL merge_employees_from_stream();


-- Resume task. By default it is suspended
ALTER TASK MY_FIRST_DATA_PIPELINE RESUME;
