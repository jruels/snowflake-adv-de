USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY3;
USE SCHEMA RAW;

/*=======================Dependencies===============

This Account Usage view displays object dependencies. 
An object dependency results when an object references a base object but does not materialize or copy data, 
such as when a view references a table.

===================================================*/

--If you have created a view, you could identify the base table from this example
select * from snowflake.account_usage.OBJECT_DEPENDENCIES
where referenced_object_name='TEST_DATAENGINEER';