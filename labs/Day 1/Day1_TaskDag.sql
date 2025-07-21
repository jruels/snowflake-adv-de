USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DAY1;
USE SCHEMA RAW;

CREATE TASK task_root
  SCHEDULE = '1 MINUTE'
  AS SELECT 1;

CREATE TASK task_a
  AFTER task_root
  AS SELECT 1;

CREATE TASK task_b
  AFTER task_root
  AS SELECT 1;

CREATE TASK task_c
  AFTER task_a, task_b
  AS SELECT 1;


--Task Dependants

SELECT *
FROM TABLE(INFORMATION_SCHEMA.TASK_DEPENDENTS(TASK_NAME => 'DAY1.RAW.task_root', recursive => false)
);


/*===================Important=========

1. SUSPEND_TASK_AFTER_NUM_FAILURES
2. ALLOW_OVERLAPPING_EXECUTION
3. DAGs limited to 1000 tasks. A single task can have 100 predecessors and 100 child tasks

======================================*/