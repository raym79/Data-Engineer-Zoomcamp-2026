# # 1. Docerfile for a simple data pipeline using Python with pandas and pyarrow
# FROM python:3.13.11-slim

# RUN pip install pandas pyarrow

# WORKDIR /code
# # copy the script to the container. 1st name is source file, 2nd is destination
# COPY pipeline.py .
# # define what to do first when the container runs
# # in this example, we will just run the script
# ENTRYPOINT [ "python", "pipeline.py" ]

# 2. Dockerfile with uv 
FROM python:3.13.11-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

WORKDIR /code
ENV PATH="/code/.venv/bin:$PATH"

COPY pyproject.toml .python-version uv.lock ./
RUN uv sync --locked 

# COPY pipeline.py .
COPY ingest_data.py .

# ENTRYPOINT ["python", "pipeline.py" ]
ENTRYPOINT ["uv", "run", "python", "ingest_data.py" ]