USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY2;
USE SCHEMA RAW;

/*=================Tabular UDF==============

A tabular UDF can return a set of rows. 
Accept N number of parameters 
Returns a table

Can be defined using SQL, Java, Javascript, and Python (not Scala)

==========================================*/

--Create a orders table
create or replace table orders (
    product_id varchar, 
    quantity_sold numeric(11, 2)
    );

--Insert the values
insert into orders (product_id, quantity_sold) values 
    ('compostable bags', 2000),
    ('re-usable cups',  1000);


--Create Tabular UDF  
create or replace function orders_for_product(PROD_ID varchar)
returns table (Product_ID varchar, Quantity_Sold numeric(11, 2))
as
$$
    select product_ID, quantity_sold 
    from orders 
    where product_ID = PROD_ID
$$;


--Syntax to call a a table function is differnt than a Scalar UDF
select 
    *
from table(orders_for_product('compostable bags'));