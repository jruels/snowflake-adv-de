--STEP 1 SET CONTEXT

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;


--STEP 2 CREATE DATABASE LAB_STREAMS
CREATE OR REPLACE DATABASE LAB_STREAMS;

-- STEP 3 SET CONTEXT FOR DATABASE + SCHEMA
USE DATABASE LAB_STREAMS;
USE SCHEMA PUBLIC;

--STEP 4 CREATE TABLES ORDERS + CUSTOMERS
create or replace table orders (id int, order_name varchar);
create or replace table customers (id int, customer_name varchar);

--STEP 5 CREATE VIEW 
create or replace view ordersByCustomer as select * from orders natural join customers;


--STEP 6 Insert Records into Orders and Customers Table
insert into orders values (1, 'order1');
insert into customers values (1, 'customer1');

--STEP 7 CREATE STREAM ON VIEW
create or replace stream ordersByCustomerStream on view ordersBycustomer;

--STEP 8 INSPECT RECORDS OF VIEW
select * from ordersByCustomer;

--STEP 9 INSPECT RECORDS ON STREAM
select * exclude metadata$row_id from ordersByCustomerStream;
select * from ordersByCustomerStream;

--STEP 10 INSERT RECORD INTO ORDERS TABLE
insert into orders values (1, 'order2');

--STEP 11 INSPECT VIEW
select * from ordersByCustomer;

--STEP 12 INSPECT STREAM
select * exclude metadata$row_id from ordersByCustomerStream;

--STEP 13 INSERT ANOTHER RECORD INTO CUSTOMER TABLE
insert into customers values (1, 'customer2');


--STEP 14 INSPECT VIEW
select * from ordersByCustomer;


--STEP 16 INSPECT STREAM
select * exclude metadata$row_id from ordersByCustomerStream;


--STEP 17 DROP DATABASE
DROP DATABASE LAB_STREAMS;
