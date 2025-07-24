--STEP 1 SET CONTEXT
USE ROLE ACCOUNTADMIN; 
USE WAREHOUSE COMPUTE_WH;


--STEP 2 See what queries are eligible for query accelearation - we probably won't have any in our trial account
SELECT query_id,
       query_text,
       start_time,
       end_time,
       warehouse_name,
       warehouse_size,
       eligible_query_acceleration_time,
       upper_limit_scale_factor,
       DATEDIFF(second, start_time, end_time) AS total_duration,
       eligible_query_acceleration_time / NULLIF(DATEDIFF(second, start_time,
end_time), 0) AS eligible_time_ratio
FROM
    SNOWFLAKE.ACCOUNT_USAGE.QUERY_ACCELERATION_ELIGIBLE
WHERE
    start_time >= DATEADD(day, -30, CURRENT_TIMESTAMP())
    AND eligible_time_ratio <= 1.0
    AND total_duration BETWEEN 3 * 60 and 5 * 60
ORDER BY (eligible_time_ratio, upper_limit_scale_factor) DESC NULLS LAST
LIMIT 100;



--STEP 3 (DON'T NEED TO RUN THIS YET) -- this will be the sample query we will use for query acceleartion
SELECT d.d_year as "Year",
       i.i_brand_id as "Brand ID",
       i.i_brand as "Brand",
       SUM(ss_net_profit) as "Profit"
FROM   snowflake_sample_data.tpcds_sf10tcl.date_dim    d,
       snowflake_sample_data.tpcds_sf10tcl.store_sales s,
       snowflake_sample_data.tpcds_sf10tcl.item        i
WHERE  d.d_date_sk = s.ss_sold_date_sk
  AND s.ss_item_sk = i.i_item_sk
  AND i.i_manufact_id = 939
  AND d.d_moy = 12
GROUP BY d.d_year,
         i.i_brand,
         i.i_brand_id
ORDER BY 1, 4, 2
LIMIT 200;


--STEP 4 Create warehouses 
CREATE OR REPLACE WAREHOUSE noqas_wh WITH
  WAREHOUSE_SIZE='X-Small'
  ENABLE_QUERY_ACCELERATION = false
  INITIALLY_SUSPENDED = true
  AUTO_SUSPEND = 60;

  
CREATE OR REPLACE WAREHOUSE qas_wh WITH
  WAREHOUSE_SIZE='X-Small'
  ENABLE_QUERY_ACCELERATION = true
  QUERY_ACCELERATION_MAX_SCALE_FACTOR = 64
  INITIALLY_SUSPENDED = true
  AUTO_SUSPEND = 60;


-- STEP 5 -- NO QAS  
USE SCHEMA snowflake_sample_data.tpcds_sf10tcl;

USE WAREHOUSE noqas_wh;

--this query will take some time to run
SELECT d.d_year as "Year",
       i.i_brand_id as "Brand ID",
       i.i_brand as "Brand",
       SUM(ss_net_profit) as "Profit"
FROM   snowflake_sample_data.tpcds_sf10tcl.date_dim    d,
       snowflake_sample_data.tpcds_sf10tcl.store_sales s,
       snowflake_sample_data.tpcds_sf10tcl.item        i
WHERE  d.d_date_sk = s.ss_sold_date_sk
  AND s.ss_item_sk = i.i_item_sk
  AND i.i_manufact_id = 939
  AND d.d_moy = 12
GROUP BY d.d_year,
         i.i_brand,
         i.i_brand_id
ORDER BY 1, 4, 2
LIMIT 200;


--STEP 6 --RECORDS QUERY_ID
 SELECT LAST_QUERY_ID();
--01b00ced-0001-74f3-0002-cb860002136a


--STEP 7 - DISABLE CACHED RESULT IN CURRENT SESSION, OTHERWISE SNOWFLAKE WILL JUST USE CACHED RESULTS
alter session set USE_CACHED_RESULT = FALSE;


--STEP 8 -- USE QAS
USE WAREHOUSE QAS_WH;

  SELECT d.d_year as "Year",
       i.i_brand_id as "Brand ID",
       i.i_brand as "Brand",
       SUM(ss_net_profit) as "Profit"
FROM   snowflake_sample_data.tpcds_sf10tcl.date_dim    d,
       snowflake_sample_data.tpcds_sf10tcl.store_sales s,
       snowflake_sample_data.tpcds_sf10tcl.item        i
WHERE  d.d_date_sk = s.ss_sold_date_sk
  AND s.ss_item_sk = i.i_item_sk
  AND i.i_manufact_id = 939
  AND d.d_moy = 12
GROUP BY d.d_year,
         i.i_brand,
         i.i_brand_id
ORDER BY 1, 4, 2
LIMIT 200;


--STEP 9 -- RECORD QUERY_ID
SELECT LAST_QUERY_ID();
--01b00cff-0001-74f3-0002-cb860002143a


--STEP 10 -- SEE TOTAL ELAPSED TIME BETWEEN 2 QUERIES
SELECT query_id,
       query_text,
       warehouse_name,
       total_elapsed_time
FROM TABLE(snowflake.information_schema.query_history())
WHERE query_id IN ('01b00ced-0001-74f3-0002-cb860002136a', '01b00cff-0001-74f3-0002-cb860002143a')
ORDER BY start_time;



--STEP 11 -- See warehouse metering history for NOQAS_WH
SELECT start_time,
       end_time,
       warehouse_name,
       credits_used,
       credits_used_compute,
       credits_used_cloud_services,
       (credits_used + credits_used_compute + credits_used_cloud_services)
AS credits_used_total
  FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.WAREHOUSE_METERING_HISTORY(
    DATE_RANGE_START => DATEADD('days', -1, CURRENT_DATE()),
    WAREHOUSE_NAME => 'NOQAS_WH'
  ));


--STEP 12 -- WEE WAREHOUSE METERING HISTORY FOR QAS_WH
  SELECT start_time,
       end_time,
       warehouse_name,
       credits_used,
       credits_used_compute,
       credits_used_cloud_services,
       (credits_used + credits_used_compute + credits_used_cloud_services)
AS credits_used_total
  FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.WAREHOUSE_METERING_HISTORY(
    DATE_RANGE_START => DATEADD('days', -1, CURRENT_DATE()),
    WAREHOUSE_NAME => 'QAS_WH'
  ));


--STEP 13 -- SEE QAH HISTORY FOR QAS_WH
SELECT start_time,
         end_time,
         warehouse_name,
         credits_used,
         num_files_scanned,
         num_bytes_scanned
    FROM TABLE(SNOWFLAKE.INFORMATION_SCHEMA.QUERY_ACCELERATION_HISTORY(
      DATE_RANGE_START => DATEADD('days', -1, CURRENT_DATE()),
      WAREHOUSE_NAME => 'QAS_WH'
));


--DROP WAREHOUSES
DROP WAREHOUSE noqas_wh;
DROP WAREHOUSE qas_wh;
