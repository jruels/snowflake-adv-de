USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY1;
USE SCHEMA RAW;

/*===================CONTINUOUS LOAD STAGE========================

Snowpipe: Data Pipelines for Advanced Transformations
Snowpipe Streaming API: Directly writes data rows to Snowflake tables without staging.
Snowflake Connector for Kafka:

===============================================================*/

CREATE OR REPLACE STAGE CONTINUOUSLOADSTAGE;

List @CONTINUOUSLOADSTAGE;

CREATE OR REPLACE TABLE CONTINUOUSLOAD_TABLE
(
ID INTEGER,
NAME VARCHAR
);

-- To create a snowpipe
CREATE OR REPLACE PIPE CONTINUOUS_LOAD_PIPE 
AUTO_INGEST=TRUE -- Ingests the file from stage to table
AS
COPY INTO CONTINUOUSLOAD_TABLE(ID,NAME) 
FROM (
    SELECT 
        $1::INT, 
        $2::VARCHAR
    FROM @CONTINUOUSLOADSTAGE 
    )
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1);

SELECT * FROM CONTINUOUSLOAD_TABLE;

--PUT file:////Users/srinikoms/Desktop/Training2025/Employee1.csv @CONTINUOUSLOADSTAGE;
--PUT file:////Users/srinikoms/Desktop/Training2025/Employee2.csv @CONTINUOUSLOADSTAGE;
--PUT file:////Users/srinikoms/Desktop/Training2025/Employee3.csv @CONTINUOUSLOADSTAGE;
--PUT file:////Users/srinikoms/Desktop/Training2025/Employee4.csv @CONTINUOUSLOADSTAGE;
--PUT file:////Users/srinikoms/Desktop/Training2025/Employee5.csv @CONTINUOUSLOADSTAGE;

SELECT * FROM CONTINUOUSLOAD_TABLE;

--command to check the pipe status
SELECT SYSTEM$PIPE_STATUS('CONTINUOUS_LOAD_PIPE');