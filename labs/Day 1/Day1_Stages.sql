USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY1;
USE SCHEMA RAW;


/**=========================USER STAGE=======================

Each user has a Snowflake stage allocated to them by default for storing files and these cannot be altered or dropped. 

■ Allocated for each user.
■ Designed for files managed by one user, but can load into multiple tables.
■ Cannot be altered or dropped.

=============================================================*/

List @~; --List the user stage.

-- To load the file to user stages, use below command

-- PUT file:////Users/srinikoms/Desktop/Training2025/Employee.csv @~/staged;

List @~;

-- How to load the user stage files to a table

CREATE TABLE USERSTAGE
(
ID INTEGER,
NAME VARCHAR
);

COPY INTO USERSTAGE from @~/staged FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1);

SELECT * FROM USERSTAGE;

/**=========================TABLE STAGE=======================

Each table has a Snowflake stage allocated to it by default for storing files and these cannot be altered or dropped. 

■ Available for each Snowflake table.
■ Stores files for one or multiple users but loads only into its linked table.
■ Implicitly tied to the table; no separate database object.
■ No grantable privileges; table owner required for staging operations.

============================================================*/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY1;
USE SCHEMA RAW;

CREATE OR REPLACE TABLE TABLESTAGE
(
ID INTEGER,
NAME VARCHAR
);

List @%TABLESTAGE; -- How to list table stage

SELECT * FROM TABLESTAGE;

--To load the file to Table stages, use below command

--PUT file:////Users/srinikoms/Desktop/Training2025/Employee.csv @%TABLESTAGE;

List @%TABLESTAGE;

COPY INTO TABLESTAGE FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1) FORCE=TRUE;

SELECT * FROM TABLESTAGE;

--Try load into a different table with the same stage.

CREATE OR REPLACE TABLE TABLESTAGE_NEW
(
ID INTEGER,
NAME VARCHAR
);

COPY INTO TABLESTAGE_NEW FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1) FORCE=TRUE;

SELECT * FROM TABLESTAGE_NEW;


/**=========================NAMED STAGE=======================

Named stages are database objects that provide the greatest degree of flexibility for data loading. 
They overcome the limitations of both User and Table stages.

■ A distinct database object in a schema.
■ Can store files for multiple users and load into various tables.
■ Access and operations controlled by security privileges.
■ Created using the "CREATE STAGE" command.

Internal Stage: Storage managed by snowflake, but still files still reside in the cloud

External Stage: Storage managed by user, and resides in the cloud.

============================================================**/

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY1;
USE SCHEMA RAW;

-- INTERNAL STAGE

CREATE OR REPLACE STAGE NAMEDSTAGE_INTERNAL;

List @NAMEDSTAGE_INTERNAL;

CREATE OR REPLACE TABLE NAMEDSTAGE_INTERNAL_TABLE
(
ID INTEGER,
NAME VARCHAR
);

--To Load files to internal stage

--PUT file:////Users/srinikoms/Desktop/Training2025/Employee.csv @NAMEDSTAGE_INTERNAL;

COPY INTO NAMEDSTAGE_INTERNAL_TABLE FROM @NAMEDSTAGE_INTERNAL
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1) FORCE=TRUE;

SELECT * FROM NAMEDSTAGE_INTERNAL_TABLE;




-- EXTERNAL STAGE

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY1;
USE SCHEMA RAW;

-- Create External Stage
CREATE OR REPLACE STAGE NAMEDSTAGE_EXTERNAL
URL = 's3://snowflakeadvanced/Employee.csv';

List @NAMEDSTAGE_EXTERNAL;

CREATE OR REPLACE TABLE NAMEDSTAGE_EXTERNAL_TABLE
(
ID INTEGER,
NAME VARCHAR
);

-- To Load data from External stages

COPY INTO NAMEDSTAGE_EXTERNAL_TABLE FROM @NAMEDSTAGE_EXTERNAL
FILE_FORMAT = (TYPE = CSV FIELD_DELIMITER = ',' SKIP_HEADER = 1) FORCE=TRUE;

SELECT * FROM NAMEDSTAGE_EXTERNAL_TABLE;