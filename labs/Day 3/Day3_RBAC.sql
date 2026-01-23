/*==========RBAC(Role Based Access Control)===============

Securable object: An entity to which access can be granted. Unless allowed by a grant, access will be denied.

Role: An entity to which privileges can be granted. Roles are in turn assigned to users. 
Note that roles can also be assigned to other roles, creating a role hierarchy.

Privilege: A defined level of access to an object. Multiple distinct privileges may be used to control the granularity of access granted.

User: A user identity recognized by Snowflake, whether associated with a person or program.

Discrentionary Access Control --
=================================*/



use role accountadmin;

-- create the access roles as database roles
use database DAY3;


/*===============Create Access Roles=====
1. Create one role for FUll access
2. Create one role for READ only access
====================================*/


create or replace database role DAY3_FULL;
create or replace database role DAY3_READ;

-- grant full schema usage to the FULL role
grant all privileges on schema RAW to database role DAY3_FULL;


-- grant schema usage to the READ role
grant usage on schema RAW to database role DAY3_READ;

-- grant read access on current and future objects
grant select on all tables in schema RAW to database role DAY3_READ;
grant select on future tables in schema RAW to database role DAY3_READ;
-- ... add grants for other types of objects


/*============Functional Roles======
Create Functional rols
1. For data engineer
2. Data Analyst
===================================*/
create or replace role DATA_ANALYST;
create or replace role DATA_ENGINEER;


-- grant access roles to functional roles
grant database role DAY3_READ to role DATA_ANALYST;
grant database role DAY3_FULL to role DATA_ENGINEER;


grant role data_analyst to user srinivas;
grant role data_engineer to user srinivas;


/*================Test the RBAC======

When use the data engineer , we should
be able to create objects which has full access
========================*/

use role data_engineer;
use database day3;
use schema raw;

create table test_dataengineer
(
id number
);


create view test_dataengineer_vw as
 select * from test_dataengineer;


----RBAC Test Analyst

use role data_analyst;
use database day3;
use schema raw;

create or replace table test_analyst
(
id number
);




-----System Roles and examples

ACCOUNTADMIN

Use cases:
Creating new accounts or managing account-level settings
Setting up resource monitors and billing
Managing account-level parameters like DATA_RETENTION_TIME_IN_DAYS
Emergency access when other admins are locked out

Example:
sql
USE ROLE ACCOUNTADMIN;
ALTER ACCOUNT SET DATA_RETENTION_TIME_IN_DAYS = 7;
CREATE RESOURCE MONITOR monthly_limit WITH CREDIT_QUOTA = 1000;


SECURITYADMIN
Use cases:
Granting privileges across the entire account
Creating and managing roles for the organization
Granting ownership of objects to different roles

Example:
sql
USE ROLE SECURITYADMIN;
CREATE ROLE data_analyst;
GRANT USAGE ON WAREHOUSE compute_wh TO ROLE data_analyst;
GRANT USAGE ON DATABASE sales_db TO ROLE data_analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA sales_db.public TO ROLE data_analyst;


USERADMIN
Use cases:
Creating new users for team members
Assigning roles to users
Resetting user passwords
Managing user properties (email, default role, etc.)

Example:
sql
USE ROLE USERADMIN;
CREATE USER john_smith PASSWORD='secure123' DEFAULT_ROLE=data_analyst;
GRANT ROLE data_analyst TO USER john_smith;
ALTER USER john_smith SET EMAIL='john@company.com';

SYSADMIN
Use cases:
Creating databases, schemas, tables, and views
Creating warehouses for compute
Managing day-to-day database objects
Creating custom roles (then granting privileges via SECURITYADMIN)

Example:
sql
USE ROLE SYSADMIN;
CREATE DATABASE sales_db;
CREATE SCHEMA sales_db.reporting;
CREATE TABLE sales_db.reporting.orders (order_id INT, amount FLOAT);
CREATE WAREHOUSE analytics_wh WITH WAREHOUSE_SIZE='MEDIUM';

-- Create custom role (then switch to SECURITYADMIN to grant privileges)
CREATE ROLE report_viewer;

PUBLIC
Use cases:

Sharing commonly used objects with everyone
Default access that all users automatically have

Example:
sql-- As SECURITYADMIN, grant to PUBLIC so everyone can use this warehouse
USE ROLE SECURITYADMIN;
GRANT USAGE ON WAREHOUSE shared_wh TO ROLE PUBLIC;

-- Now ANY user can run:
USE WAREHOUSE shared_wh;
SELECT CURRENT_USER(); -- Everyone has access
```

---Best Practices Hierarchy
ACCOUNTADMIN (god mode - rarely use)
    ↓ includes
SECURITYADMIN (grants privileges) + USERADMIN (manages users)
    ↓ includes
SYSADMIN (creates objects, custom roles)
    ↓ includes
Custom roles (data_analyst, data_engineer, etc.)
    ↓ includes
PUBLIC (everyone)
