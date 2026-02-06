/* ===================================================================================================================================
Prerequisites BigQuery Setup
=================================================================================================================================== */
-- Create an external table 
CREATE SCHEMA IF NOT EXISTS `kestra-sandbox-486403.taxi_data_hw3`
OPTIONS(location="us-west1");

CREATE OR REPLACE EXTERNAL TABLE `kestra-sandbox-486403.taxi_data_hw3.yellow_trips_external`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://kestra-sandbox-486403-hw3-2026/*.parquet']
);


SELECT *
FROM `kestra-sandbox-486403.taxi_data_hw3.yellow_trips_external`
LIMIT 10;


-- Create a regular/materialized table
CREATE OR REPLACE TABLE `kestra-sandbox-486403.taxi_data_hw3.yellow_trips`
AS
SELECT *
FROM `kestra-sandbox-486403.taxi_data_hw3.yellow_trips_external`;

/* ===================================================================================================================================
Question 1: What is count of records for the 2024 Yellow Taxi Data?
=================================================================================================================================== */
SELECT COUNT(*)
FROM kestra-sandbox-486403.taxi_data_hw3.yellow_trips;

-- Answer: 20,332,093


/* ===================================================================================================================================
Question 2: Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.

What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
=================================================================================================================================== */

SELECT DISTINCT(PULocationID)
FROM kestra-sandbox-486403.taxi_data_hw3.yellow_trips_external;

SELECT DISTINCT(PULocationID)
FROM kestra-sandbox-486403.taxi_data_hw3.yellow_trips;


-- Answer: 0 MB for the External Table and 155.12 MB for the Materialized Table



/* ===================================================================================================================================
Question 3: Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table.

Why are the estimated number of Bytes different?
=================================================================================================================================== */
SELECT PULocationID
FROM kestra-sandbox-486403.taxi_data_hw3.yellow_trips;

SELECT PULocationID, DOLocationID
FROM kestra-sandbox-486403.taxi_data_hw3.yellow_trips;


-- Answer: BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.




/* ===================================================================================================================================
Question 4: How many records have a fare_amount of 0?
=================================================================================================================================== */
SELECT COUNT(1)
FROM kestra-sandbox-486403.taxi_data_hw3.yellow_trips
WHERE fare_amount = 0 ;


-- Answer: 8333



/* ===================================================================================================================================
Question 5: What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)
=================================================================================================================================== */
-- Create a materialized table with partition
CREATE OR REPLACE TABLE `kestra-sandbox-486403.taxi_data_hw3.yellow_trips_partition`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID
AS
SELECT *
FROM `kestra-sandbox-486403.taxi_data_hw3.yellow_trips_external`;

-- Answer: Partition by tpep_dropoff_datetime and Cluster on VendorID



/* ===================================================================================================================================
Question 6: Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?
=================================================================================================================================== */

SELECT DISTINCT(VendorID)
FROM `kestra-sandbox-486403.taxi_data_hw3.yellow_trips`
WHERE DATE(tpep_dropoff_datetime) >= DATE('2024-03-01') AND DATE(tpep_dropoff_datetime) <= DATE('2024-03-15');


SELECT DISTINCT(VendorID)
FROM `kestra-sandbox-486403.taxi_data_hw3.yellow_trips_partition`
WHERE DATE(tpep_dropoff_datetime) >= DATE('2024-03-01') AND DATE(tpep_dropoff_datetime) <= DATE('2024-03-15');

-- Answer: 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table



/* ===================================================================================================================================
Question 7: Where is the data stored in the External Table you created?
=================================================================================================================================== */

-- Answer: GCP Bucket



/* ===================================================================================================================================
Question 8: It is best practice in Big Query to always cluster your data:
=================================================================================================================================== */

-- Answer: False


/* ===================================================================================================================================
Question 9: Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
=================================================================================================================================== */
SELECT count(*) FROM `kestra-sandbox-486403.taxi_data_hw3.yellow_trips_partition`;
SELECT count(*) FROM `kestra-sandbox-486403.taxi_data_hw3.yellow_trips`;
SELECT count(*) FROM `kestra-sandbox-486403.taxi_data_hw3.yellow_trips_partition`;

-- Answer: 0 byte.BigQuery keeps metadata statistics about tables, including number of rows, partition info, storage blocks.BigQuery can read the row count from metadata without scanning the actual data.

