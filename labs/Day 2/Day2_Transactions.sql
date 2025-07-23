--STEP 1 - SET CONTEXT 
use role accountadmin;
use warehouse compute_wh;

--STEP 2 - CREATE DATABASE
CREATE OR REPLACE database lab_transactions;

--STEP 3 - SET DATABASE CONTEXT 
use database lab_transactions;
use schema public;


--STEP 4 - CREATE TABLE
CREATE OR REPLACE TABLE transaction_example (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    balance DECIMAL(10, 2)
);


--STEP 5 -- BEGIN TRANSACTION BUT DON'T COMMIT
BEGIN;
INSERT INTO transaction_example VALUES (1, 'Alice', 100.00);

SELECT * FROM transaction_example;

--STEP 6 -- RUN THIS CODE BUT ON ANOTHER SESSION / WORKSHEET
Select * from LAB_TRANSACTIONS.PUBLIC.TRANSACTION_EXAMPLE;

--STEP 7 -- COMMIT TRANSACTION
COMMIT;

--STEP 8 -- Observe in this worksheet as well as the worksheet from STEP 6
SELECT * FROM transaction_example;


--STEP 9 -- OBSERVE ROLLBACK FEATURE
BEGIN;
UPDATE transaction_example SET balance = balance + 50 WHERE id = 1;
SELECT * FROM TRANSACTION_EXAMPLE;
ROLLBACK;


--STEP 10 -- ROLLBACK FEATURE CONTINUED
SELECT * FROM TRANSACTION_EXAMPLE;

