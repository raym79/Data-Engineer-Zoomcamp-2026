# 01-docker-terraform
1. docker
    * check docker if install properly
2. python -V
    * check python version
    * Note: -V and -v are different! 
    * Command	Meaning	What happens
    * python3 -v: verbose mode; Prints every module imported during startup and then starts the REPL
    * python3 -V: version; Prints Python version and exits
    * ctrl+D to exit verbose mode
3. ``` PS1="> " ```
    * to changes terminal prompt to simply '> '
    * apply to new terminal: ``` echo 'PS1="> "' > ~/.bashrc ```
4. docker run hello-world
    * see 'Hello from Docker!' meaning docker is runnning properly
5. docker run xxxx
    * run docker image.
    * e.g.: docker run ubuntu
6. docker run -it  ubuntu
    * root@2c6193587d2a:/# 
    * -it: interactive terminal 
once we see 'root@xxxx:', we are inside of image
7. inside image, type 'python3' to check if we install image.
    * apt update
    * apt install python3
    * but we exit and open a new image, python will not be there.
    * so we do this:
8. docker run -it python:3.13.11
    * this is a python image. 
    * (installation might take a bit while, can use docker run -it python:3.13.11-slim instead)
9. docker run -it --entrypoint=bash  python:3.13.11
    * “Start a Python 3.13.11 container and drop me directly into a Bash shell instead of running Python.”
10. Bash
    1. Why Bash Matters in Docker: Docker containers start with a process. Every container runs ONE main process.
        * Example: ``` docker run python:3.13.11 ```
            * Main process: ``` python3 ```
            * When you override: ``` --entrypoint=bash ```
            * Main process becomes: ``` bash ```
        * That means:
            * Bash is PID 1
            * Bash controls everything in the container
            * When Bash exits → container stops
    2. Why Engineers Use Bash Instead of Python REPL
        * Without Bash, You can’t:
            * Inspect files
            * Run ```ls```
            * Check environment variables
            * Install packages
            * Debug
        * With Bash, You can:
            * ``` ls ```
            * ``` env ```
            * ``` cat /etc/os-release ```
            * ``` pip install something ```
        * This is mandatory for debugging real systems.
    3. Key: 
        * Bash is the operating layer
        * Python is the application layer
        * SQL is the data layer
11. echo 123 > file
    * Write the text 123 into a file named file
    * '>' overwrite
    * '>>' append 
12. docker ps -a (docker ps -aq: no headers, etc.)
    * List all Docker containers on your machine — running and stopped
13. docker ps -aq 
14. Volume
    * What Is a Volume?
        * A Docker volume is a way to store data outside of a container, so that:
            * Data persists after the container stops
            * Data can be shared between containers
            * Data can be mounted into containers
        * > “A folder on the host machine that the container can see.”
    * Example:
        ```
        docker run -it \
        --rm \
        -v $(pwd)/test:/app/test \
        --entrypoint=bash \
        python:3.9.16-slim
        ```
        * > Start a lightweight Python 3.9 container, mount a specific host folder into it, and drop me into a Bash shell so I can explore and debug interactively.
        * notes
            * $(pwd): current working directory
            * A:B -> mapping A to B 
            * after running command above, we are inside the container
            * we can see the all the file in app/test/
            * we can also execute script.py to check the files
            * [add image '01-docker-volume']

# 02-virtual-environment
1. virtual environment
    * initiate a virtual environment
        * ```uv init --python 3.13```
    * add dependencies
        * ``` uv add pandas, pyarrow ```
    * ```.gitignore``` config

# 03-Dockerizing the Pipeline
> Create custom Docker image with a Dockerfile
1. Dockerfile:
    * A Dockerfile is a recipe that tells Docker how to build an image
    * build:
        * ``` docker build -t test:pandas . ```
    * run:
        * ``` docker run -it --entrypoint=bash --rm test:pandas ```
    * inside container after run:
        * we can run ``` python pipeline.py 12 ``` to get proper result
    * extra step:
        * we can also change the entry point 
        * ENTRYPOINT = what this container is
        * Now we can directly run with
            * ``` docker build -t test:pandas .```
            * ``` docker run -it --rm test:pandas 12 ``` 
2. Dockerfile with uv
    * copy uv path
    * copy dependency metadata
    * Install dependencies

# 04-postgres-docker
1. create folder for Postgres to store data in
``` 
docker run -it --rm \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v ny_taxi_postgres_data:/var/lib/postgresql \
  -p 5432:5432 \
  postgres:18
```

2. connect to PostgreSQL
    * log into database with pgcli
    * add dev  dev dependency ``` uv add --dev pgcli ```
        * only need for development, we need pgcli in dev environment
    * run pgcli
        * ``` uv run pgcli -h localhost -p 5432 -u root -d ny_taxi ```
        * pswd is 'root' we created last step
    * now we want to get csv data with NY_taxi dataset and put them on our Postgres, we need python via jupyter notebook -> next section

# 05-data-ingestion.md
1. create jupyter notebook, use token to login on web  
    ` uv add --dev jupyter `
    ` uv run jupyter notebook `
2. our goal is to put this [yellow_tripdata_2021-01.csv.gz](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz) data in cvs file to our Postgres db
3. we use pandas on jupyter notebook to process data  
check jupyter notebook for more details  
cont. at 1:22
4. At end of this section, we have a jupyter notebook. Next, we will convert it into a Python script. 

# 06-ingestion-script
1. convert jupter notebook to script using `uv run jupyter nbconvert --to=script notebook.ipynb`
2. rename `mv notebook.py ingest_data.py`
3. optimize data ingestion in `ingest_data.py`
    * run `uv run python ingest_data.py` command, data successfully insert into target table
4. next, we want to use command line to input parameters  
    * For example, specify year = 2022, month = 7, etc. 
5. we need to use click, check code in scipt
6. use command to run the script  
``` 
uv run python ingest_data.py \
  --pg-user=root \
  --pg-pass=root \
  --pg-host=localhost \
  --pg-port=5432 \
  --pg-db=ny_taxi \
  --year=2021 \
  --month=1 \
  --target-table=yellow_taxi_trips
```