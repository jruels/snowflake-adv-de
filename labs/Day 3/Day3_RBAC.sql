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


grant role data_analyst to user srinivassukka;
grant role data_engineer to user srinivassukka;


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

