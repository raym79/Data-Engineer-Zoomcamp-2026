# Module 1 Homework: Docker & SQL

## Question 1. Understanding Docker images

### Anwser
1. `docker run -it python:3.12.8 --entrypoint=bash`
2. `25.3`
    * command: `pip -V`

## Question 2. Understanding Docker networking and docker-compose

```yaml
services:
# Postgres service
  db:
    container_name: postgres
    image: postgres:17-alpine
    # Environment variables
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    # Port mapping:
    # localhost (your laptop): 5433
    # Container (Postgres): 5432
    ports:
      - '5433:5432'
    # Volume
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

# pgAdmin service
  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    # Login credentials
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    # Port mapping
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

### Anwser
- db:5432


## Prepare the Data
See [homework_ingest_data.ipynb](link)  
Note: [Green Trips Data Dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf)

## Question 3. Counting short trips

For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a `trip_distance` of less than or equal to 1 mile?

### Anwser
```
SELECT  count(*)
FROM public.green_trip_data
WHERE lpep_pickup_datetime >= '2025-11-01' and lpep_pickup_datetime < '2025-12-01'
AND trip_distance <= 1

```
- 8,007


## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Only consider trips with `trip_distance` less than 100 miles (to exclude data errors).

Use the pick up time for your calculations.

### Anwser
```
SELECT DATE(lpep_pickup_datetime)
FROM (
  SELECT lpep_pickup_datetime, trip_distance, 
  rank() OVER (ORDER BY trip_distance DESC) AS dis_rk
  FROM public.green_trip_data
  WHERE trip_distance <= 100
  ORDER BY dis_rk 
) rk
WHERE dis_rk = 1

```
- 2025-11-14

## Question 5. Biggest pickup zone

Which was the pickup zone with the largest `total_amount` (sum of all trips) on November 18th, 2025?
  
### Anwser 
```
SELECT DISTINCT tz.zone
  , DATE(gtd.lpep_pickup_datetime) AS pickup_date
  , SUM(gtd.total_amount) OVER (PARTITION BY tz.zone, DATE(gtd.lpep_pickup_datetime)) AS total_amount
FROM public.green_trip_data gtd
LEFT JOIN public.taxi_zone tz 
  ON gtd.pu_location_id  = tz.location_id 
WHERE DATE(gtd.lpep_pickup_datetime) = '2025-11-18'
ORDER BY total_amount DESC
```
- East Harlem North 


## Question 6. Largest tip

For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

Note: it's `tip` , not `trip`. We need the name of the zone, not the ID.

### Anwser 
```
SELECT DISTINCT tz1.zone AS pu_zone
  , tz1.zone AS do_zone
  , SUM(gtd.tip_amount) AS tip_amount
FROM public.green_trip_data gtd
LEFT JOIN public.taxi_zone tz1 
  ON gtd.pu_location_id = tz1.location_id 
LEFT JOIN public.taxi_zone tz2 
  ON gtd.do_location_id = tz2.location_id 
WHERE tz1.zone = 'East Harlem North'
GROUP BY 1,2
ORDER BY 3 DESC
```
- East Harlem North

## Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP/Laptop/GitHub Codespace install Terraform.
Copy the files from the course repo
[here](../../../01-docker-terraform/terraform/terraform) to your VM/Laptop/GitHub Codespace.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.


## Question 7. Terraform Workflow

Which of the following sequences, respectively, describes the workflow for:
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

### Answers:
- terraform init, terraform apply -auto-approve, terraform destroy



## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2026/homework/hw1


## Learning in Public

We encourage everyone to share what they learned. This is called "learning in public".

### Why learn in public?

- Accountability: Sharing your progress creates commitment and motivation to continue
- Feedback: The community can provide valuable suggestions and corrections
- Networking: You'll connect with like-minded people and potential collaborators
- Documentation: Your posts become a learning journal you can reference later
- Opportunities: Employers and clients often discover talent through public learning

You can read more about the benefits [here](https://alexeyondata.substack.com/p/benefits-of-learning-in-public-and).

Don't worry about being perfect. Everyone starts somewhere, and people love following genuine learning journeys!

### Example post for LinkedIn

```
🚀 Week 1 of Data Engineering Zoomcamp by @DataTalksClub complete!

Just finished Module 1 - Docker & Terraform. Learned how to:

✅ Containerize applications with Docker and Docker Compose
✅ Set up PostgreSQL databases and write SQL queries
✅ Build data pipelines to ingest NYC taxi data
✅ Provision cloud infrastructure with Terraform

Here's my homework solution: <LINK>

Following along with this amazing free course - who else is learning data engineering?

You can sign up here: https://github.com/DataTalksClub/data-engineering-zoomcamp/
```

### Example post for Twitter/X


```
🐳 Module 1 of Data Engineering Zoomcamp done!

- Docker containers
- Postgres & SQL
- Terraform & GCP
- NYC taxi data pipeline

My solution: <LINK>

Free course by @DataTalksClub: https://github.com/DataTalksClub/data-engineering-zoomcamp/
```