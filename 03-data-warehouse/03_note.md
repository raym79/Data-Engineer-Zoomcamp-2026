# Data Warehouse and BigQuery

## 1.Data Warehouse and BigQuery
### 1.1 OLTP (Online Transaction Processing) vs OLAP (Online Analytical Processing) 

|                     | OLTP                                                                                              | OLAP                                                                              |
|---------------------|---------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| Purpose             | Control and run essential business operations in real time                                        | Plan, solve problems, support decisions, discover hidden insights                 |
| Data updates        | Short, fast updates initiated by user                                                             | Data periodically refreshed with scheduled, long-running batch jobs               |
| Database design     | Normalized databases for efficiency                                                               | Denormalized databases for analysis                                               |
| Space requirements  | Generally small if historical data is archived                                                    | Generally large due to aggregating large datasets                                 |
| Backup and recovery | Regular backups required to ensure business continuity and meet legal and governance requirements | Lost data can be reloaded from OLTP database as needed in lieu of regular backups |
| Productivity        | Increases productivity of end users                                                               | Increases productivity of business managers, data analysts, and executives        |
| Data view           | Lists day-to-day business transactions                                                            | Multi-dimensional view of enterprise data                                         |
| User examples       | Customer-facing personnel, clerks, online shoppers                                                | Knowledge workers such as data analysts, business analysts, and executives        |

### 1.2 BigQuery
- Serverless data warehouse 
    - There are no servers to manage or database software to install
- Software as well as infrastructure including 
    - scalability and high-availability
- Built-in features like 
    - machine learning
    - geospatial analysis
    - business intelligence
- BigQuery maximizes flexibility by separating the compute engine that analyzes your data from your storage


## 2. Partitioning and clustering
### 2.1 Partition
- Time-unit column
- Ingestion time (_PARTITIONTIME)
- Integer range partitioning
- When using Time unit or ingestion time
    - Daily (Default)
    - Hourly
    - Monthly or yearly
- Number of partitions limit is 4000

### 2.2 Clustering
- Columns you specify are used to colocate related data
- Order of the column is important
- The order of the specified columns determines the sort order of the data.
- Clustering improves
    - Filter queries
    - Aggregate queries
- Table with data size < 1 GB, don’t show significant improvement with partitioning and clustering
- You can specify up to four clustering columns

### 2.3 Clustering vs Partition
| Clustering                                                                           | Partitioning                                                        |
|--------------------------------------------------------------------------------------|---------------------------------------------------------------------|
| Cost benefit unknown                                                                 | Cost known upfront                                                  |
| Short, fast updates initiated by user                                                | Data periodically refreshed with scheduled, long-running batch jobs |
| Your queries commonly use filters or aggregation against multiple particular columns | Filter or aggregate on single column                                |
| The cardinality of the number of values in a column or group of columns is large     |                                                                     |

### 2.4 Clustering over paritioning
|        Feature        |          Partitioning          |             Clustering            |
|:---------------------:|:------------------------------:|:---------------------------------:|
| How data is organized | Split into separate partitions | Sorted within each partition      |
| Main use case         | Time-based filtering           | High-cardinality column filtering |
| Required filter       | Yes (recommended)              | Not required                      |
| Storage layout        | Separate physical partitions   | Sorted blocks inside partitions   |
| Best for              | Date/time filters              | ID, location, customer, etc.      |
### 2.5 Automatic reclustering

Partitioning reduces which partitions are scanned.
Clustering reduces which data blocks inside partitions are scanned.
Automatic reclustering keeps clustering effective over time.

## 3. Best practices
### 3.1 Cost reduction
- Avoid SELECT *
- Price your queries before running them
- Use clustered or partitioned tables
- Use streaming inserts with caution
- Materialize query results in stages

### 3.2 Query performance
- Filter on partitioned columns
- Denormalizing data
- Use nested or repeated columns
- Use external data sources appropriately
- Don't use it, in case u want a high query performance
- Reduce data before using a JOIN
- Do not treat WITH clauses as prepared statements
- Avoid oversharding tables

### 3.3 Query performance
- Avoid JavaScript user-defined functions
- Use approximate aggregation functions (HyperLogLog++)
- Order Last, for query operations to maximize performance
- Optimize your join patterns
  - As a best practice, place the table with the largest number of rows first, followed by the table with the fewest rows, and then place the remaining tables by decreasing size.



## 4. Internals of BigQuery