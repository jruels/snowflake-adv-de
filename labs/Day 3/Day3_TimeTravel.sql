USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY3;
USE SCHEMA RAW;



select current_timestamp();--2025-07-23 18:19:31.314 -0700

-- Create a sales table
CREATE OR REPLACE TABLE product_sales (
    order_id INT,
    product_name STRING,
    quantity INT,
    price DECIMAL,
    order_date DATE
);

-- Insert some sample data into the sales table
INSERT INTO product_sales (order_id, product_name, quantity, price, order_date) VALUES
(1, 'Laptop', 2, 1000, '2025-05-01'),
(2, 'Smartphone', 5, 500, '2025-05-02'),
(3, 'Tablet', 3, 300, '2025-05-03'),
(4, 'Headphones', 10, 150, '2025-05-04');

SELECT * FROM product_sales;


-- Update some records
UPDATE product_sales
SET quantity = quantity + 3
WHERE product_name = 'Smartphone';

UPDATE product_sales
SET quantity = quantity + 2
WHERE product_name = 'Tablet';

-- Delete a record
DELETE FROM product_sales
WHERE product_name = 'Headphones';

SELECT * FROM product_sales;

/*

To configure the time travel retention parameter, we can use the below command

30 Pounds / TB

*/

ALTER TABLE <table_name> SET DATA_RETENTION_TIME_IN_DAYS = <number_of_days>;


-- please make sure the timezone is same as the your account timezone by using timestamp_ltz fucntion
-- AT command is inclusive
SELECT * 
FROM product_sales 
AT (TIMESTAMP => '2025-07-23 17:21:00 -0700'); 2025-07-23 18:12:55.529



-- BEFORE command is not inclusive of the timestamp point
SELECT * 
FROM product_sales 
BEFORE (TIMESTAMP => '2025-05-20 12:37:00'::TIMESTAMP_LTZ);


--If you want to see the changes 2 mins ago
SELECT * 
FROM product_sales
AT (offset => -60*2);


--UNDROP Commands
drop table product_sales;

--Check the data in the table
select * from product_sales;

--Run the undrop command (This can be done for Database, schema and other objects as well)
undrop table product_sales;

--Check the data now
select * from product_sales;

SELECT * 
FROM product_sales
AT (offset => -60*18);
