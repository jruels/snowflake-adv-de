/*===============================Best Practices==================

● Target file size for optimal load: 100-250 MB compressed.
● Avoid loading files >100 GB.
● For very large files, consider the ON_ERROR = CONTINUE|SKIP|ABORT copy option.
● Default encoding: UTF-8 (others supported).
● Fields with delimiters or carriage returns should be enclosed in quotes.
● CSV: TRIM_SPACE option trims leading spaces and considers quotation marks.
● Organizing by path enables executing concurrent COPY statements on subsets for parallel operations.
    Examples of structured paths:
    Canada/Ontario/Toronto/2016/07/10/05/
    United_States/California/Los_Angeles/2016/06/01/11/
● Load files into Snowflake tables by specifying the exact path.

● Removing:
    ● Remove loaded staged files to prevent duplication.
    ● Caution: Ensure data is loaded successfully before removal. Use COPY_HISTORY to confirm.
    Use PURGE copy option during load.
    Use REMOVE command after successful load.

Understanding Load Metadata and Loading Older Files
● Snowflake maintains detailed metadata for each table with data load info.
● Load metadata expires after 64 days.
● Files with LAST_MODIFIED date older than 64 days may be skipped.

Handling Files with Expired Metadata
● LOAD_UNCERTAIN_FILES Option: Load files with expired metadata without duplicating.
● FORCE Option: Loads all files, potentially causing duplication.

Working with JSON and CSV Data
● VARIANT data type has a 16 MB size limit per row. --Now recently increased to 128MB
● Recommended: Use STRIP_OUTER_ARRAY file format option for JSON loading.
● JSON: Use STRIP_NULL_VALUES to avoid storing 'null' as strings.

================================================================*/