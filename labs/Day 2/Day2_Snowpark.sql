use role accountadmin;
use warehouse compute_wh;
use database day2;
use schema raw;


CREATE OR REPLACE FUNCTION FAKE_NAME("REAL_NAME" VARCHAR)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('faker','snowflake-snowpark-python')
HANDLER = 'main'
AS '
from faker import Faker
import snowflake.snowpark as snowpark
import hashlib
def main(real_name: str): 
    # Your code goes here, inside the "main" handler.
    if real_name is None:
        return None
    seed = int(hashlib.md5(real_name.encode("utf-8")).hexdigest(), 16) % (10**8)
    faker = Faker()
    faker.seed_instance(seed)
    return faker.name()
';


CREATE OR REPLACE TABLE EMPLOYEES_RAW(
ID NUMBER,
NAME VARCHAR(50),
SALARY NUMBER
);

--https://docs.snowflake.com/en/_images/table-streams-offset.png

--Insert three records into table
INSERT INTO EMPLOYEES_RAW VALUES (101,'Tony',25000);
INSERT INTO EMPLOYEES_RAW VALUES (102,'Chris',55000);
INSERT INTO EMPLOYEES_RAW VALUES (103,'Bruce',40000);


--actual data 
select 
id,
name,
salary
from employees_raw;


----Anonymize the data
select 
id,
fake_name(name) as name,
salary
from employees_raw;
