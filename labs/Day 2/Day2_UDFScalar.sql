USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY2;
USE SCHEMA RAW;


CREATE FUNCTION area_of_circle(radius FLOAT) ---Accepts N number of Parameters
  RETURNS FLOAT -- Returns only one value
  AS
  $$
    pi() * radius * radius 
  $$;


--Scalar functions needs to be called as part of SQL 
SELECT area_of_circle(5);


/*=======================Scalar with SQL==================

We could also call the UDF for each record in your table
to calculate (For example profit for each order)

========================================================*/

CREATE OR REPLACE TABLE sales (
    sale_id INT,
    revenue NUMBER(10,2),
    cost NUMBER(10,2)
);

--Insert Values

INSERT INTO sales (sale_id, revenue, cost) VALUES
    (1, 1000.00, 700.00),
    (2, 1500.50, 900.25),
    (3, 2000.00, 1200.00),
    (4, 500.00, 300.00),
    (5, 2500.00, 1800.00);

--Write a Scalar UDF
CREATE OR REPLACE FUNCTION calculate_profit(revenue NUMBER, cost NUMBER)
RETURNS NUMBER
AS
$$
    revenue - cost
$$;


SELECT 
    sale_id,
    revenue,
    cost,
    calculate_profit(revenue, cost) AS profit
FROM sales;

