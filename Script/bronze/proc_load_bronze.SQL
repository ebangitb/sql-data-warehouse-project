/*

 Stored Procedure: Load Bronze Layer (Source -> Bronze)
  -Script Purpose: This stored procedure loads data into the bronze schema from external CSV files.
  -It performs the following actions:
    -Truncates the bronze table before loading data
    - Uses the 'Bulk Insert' command to load data from CSV files to bronze table.
Parameters
  This stored procedures does not accept any parameters or return any values

Usage Example:
  EXEC bronze.load_bronze

  */

-- Save frequently used SQL code in stored procedures in the database. Create a stored procedure
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

--Track ETL duration. Add start time and end time for loading ETL for the overall bronze layer
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME

-- Add TRY and CATCH to handle errors, data integrity, easier debugging, and issue logging
BEGIN TRY

--set start time for loading the whole bronze layer
SET @batch_start_time = GETDATE()

--Add print to track execution, debug issues, and understand its flow
PRINT '================================================';
PRINT 'Loading Bronze Layer';
PRINT '================================================'

PRINT '------------------------------------------------';
PRINT 'Loading CRM Tables';
PRINT '------------------------------------------------';

--Set start time and end time for the ETL
SET @start_time = GETDATE();

--Make the table empty by truncating first, before doing the bulk insert. It means SQL will first make the table empty
PRINT '>> Truncating Table: bronze.crm_cust_info';

TRUNCATE TABLE bronze.crm_cust_info;

--Insert the files from your file path on your computer
PRINT '>> Inserting Data Into: bronze.crm_cust_info';

BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\Koko\OneDrive\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
--Set end time for the ETL
SET @end_time = GETDATE();
--Print the duration
PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '>> -------------';


--Set start time and end time for the ETL
SET @start_time = GETDATE();

PRINT '>> Truncating Table: bronze.crm_prd_info';
TRUNCATE TABLE bronze.crm_prd_info;

PRINT '>> Inserting Data Into: bronze.crm_prd_info';
BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\Koko\OneDrive\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
--Set end time for the ETL
SET @end_time = GETDATE();
--Print the duration
PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '>> -------------';

--Set start time and end time for the ETL
SET @start_time = GETDATE();

PRINT '>> Truncating Table: bronze.crm_sales_details';
TRUNCATE TABLE bronze.crm_sales_details;

PRINT '>> Inserting Data Into: bronze.crm_sales_details';
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\Koko\OneDrive\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
--Set end time for the ETL
SET @end_time = GETDATE();
--Print the duration
PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '>> -------------';

PRINT '------------------------------------------------';
PRINT 'Loading ERP Tables';
PRINT '------------------------------------------------';


--Set start time and end time for the ETL
SET @start_time = GETDATE();

PRINT '>> Truncating Table: bronze.erp_cust_az12';
TRUNCATE TABLE bronze.erp_cust_az12;

PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\Koko\OneDrive\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
--Set end time for the ETL
SET @end_time = GETDATE();
--Print the duration
PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '>> -------------';

--Set start time and end time for the ETL
SET @start_time = GETDATE();

PRINT '>> Truncating Table: bronze.erp_loc_a101';
TRUNCATE TABLE bronze.erp_loc_a101;

PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\Koko\OneDrive\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
--Set end time for the ETL
SET @end_time = GETDATE();
--Print the duration
PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '>> -------------';

--Set start time and end time for the ETL
SET @start_time = GETDATE();

PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\Koko\OneDrive\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK
);
--Set end time for the ETL
SET @end_time = GETDATE();
--Print the duration it ended
PRINT '>> Load Duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
PRINT '>> -------------';

--Print the duration it ended to build the whole bronze layer
SET @batch_end_time = GETDATE();
PRINT '-----------------------------------';
PRINT 'Loading Bronze Layer is Completed'
PRINT ' - Total Load Duration: ' + CAST (DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
PRINT '-----------------------------------';

-- End the debugging and error catching
END TRY
BEGIN CATCH
-- Add a message if there's an error
PRINT'======================================='
PRINT'ERROR OCCURRED DURING BRONZE LAYER'
PRINT'Error Message' + ERROR_MESSAGE();
PRINT'Error Message' + CAST  (ERROR_NUMBER() AS NVARCHAR);
PRINT'Error Message' + CAST  (ERROR_STATE() AS NVARCHAR);
PRINT'======================================='
END CATCH
-- End the procedure
END


