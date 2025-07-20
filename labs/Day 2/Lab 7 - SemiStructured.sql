--STEP 1 SET CONTEXT
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

--STEP 2 CREATE OR REPLACE DATABASE
CREATE OR REPLACE DATABASE LAB_SEMI;

--STEP 3 SET_CONTEXT
USE DATABASE LAB_SEMI;
USE SCHEMA PUBLIC;

--STEP 4 CREATE TABLE 
CREATE OR REPLACE TABLE complex_nested_json_data (
    id INT,
    data VARIANT
);



--STEP 5 INSERT COMPLEXT NESTED JSON DATA INTO Table
INSERT INTO complex_nested_json_data (id, data) 
select column1 as id, parse_json(column2) as data
from
VALUES
(1, '{
    "name": "Alice",
    "properties": {
        "age": 30,
        "skills": ["SQL", "Python"],
        "education": {
            "degree": "Bachelor",
            "university": "State University"
        }
    },
    "projects": [
        {"title": "Project A", "year": 2018},
        {"title": "Project B", "year": 2019}
    ]
}'),
(2, '{
    "name": "Bob",
    "properties": {
        "age": 35,
        "skills": ["Java", "JavaScript"],
        "education": {
            "degree": "Master",
            "university": "Tech Institute"
        }
    },
    "projects": [
        {"title": "Project X", "year": 2017},
        {"title": "Project Y", "year": 2020}
    ]
}');



--STEP 6 - Flattening Deeply Nested JSON Objects
SELECT id,
       data:name::STRING AS name,
       data:properties:age::INT AS age,
data:properties:education:degree::STRING AS degree,
       data:properties:education:university::STRING AS university
FROM complex_nested_json_data;


--STEP 7 Handling Nested Arrays within Nested Objects:
SELECT id,
       f.value::STRING AS skill
FROM complex_nested_json_data,
LATERAL FLATTEN(input => data:properties:skills) f;


--STEP 8: Dealing with Arrays of Nested Objects
SELECT id,
       p.value:title::STRING AS project_title,
       p.value:year::INT AS project_year
FROM complex_nested_json_data,
     LATERAL FLATTEN(input => data:projects) p;

--STEP 9 - Query Complex Flattened Data
SELECT DISTINCT d.id,
                d.data:name::STRING AS name
FROM complex_nested_json_data d,
     LATERAL FLATTEN(input => d.data:properties:skills) s
WHERE s.value = 'Python';


--STEP 10 - Cleanup
DROP DATABASE LAB_SEMI;
