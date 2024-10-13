#!/usr/bin/env bash

export AIRFLOW_HOME=~/.local/airflow

AIRFLOW_VERSION=2.5.3
PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
# For example: https://raw.githubusercontent.com/apache/airflow/constraints-2.5.3/constraints-3.7.txt
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

CONSTRAINT_URL="http://localhost:4000/airflow-constraints-3.5.3-py3.10.txt"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# standalone will initialise the database, make a user, and start all components for you.
airflow standalone

# open localhost:8080
# account: admin
# password: (shown on the terminal)

# Enable the example_bash_operator DAG in the home page
