# Airflow ETL Pipeline for HR Data

This project includes a DAG (Directed Acyclic Graph) for executing ETL (Extract, Transform, Load) operations from an Oracle database. The project uses Apache Airflow to automate these operations.

## Project Structure

```plaintext
.
├── dags
│   └── DW_HR_ETL.py
├── sql_scripts
│   ├── create_staging_tables.sql
│   ├── create_dimension_tables.sql
│   ├── SP_STG_INSERT_ETL_DEPENDENCIES.sql
│   ├── SP_STG_TRUNCATE_TABLE.sql
│   ├── SP_SYNC_STG_TABLE_STRUCTURE.sql
│   ├── SP_STG_HR.sql
│   └── SP_DIM_HR.sql
├── requirements.txt
└── README.md

dags/DW_HR_ETL.py

This file contains the Airflow DAG definition which orchestrates the ETL process using three main tasks:

    update_stg_table_structure: Updates the structure of staging tables and creates them if they don't exist.
    extract_transform_data: Extracts and transforms data from the source.
    load_data: Loads transformed data into the target data warehouse.

sql_scripts/*.sql

These files contain the SQL procedures and table creation scripts used in the ETL process:

    create_staging_tables.sql: SQL script to create staging tables.
    create_dimension_tables.sql: SQL script to create dimension tables.
    SP_STG_INSERT_ETL_DEPENDENCIES.sql: Inserts ETL dependencies.
    SP_STG_TRUNCATE_TABLE.sql: Truncates staging tables.
    SP_SYNC_STG_TABLE_STRUCTURE.sql: Synchronizes staging table structure.
    SP_STG_HR.sql: Extracts and stages HR data.
    SP_DIM_HR.sql: Loads data into the data warehouse dimension tables.

Prerequisites

    Apache Airflow
    Oracle database with necessary permissions to create procedures and execute them

Installation

    Clone the repository:

    sh

git clone https://github.com/Morelo7/Airflow-ETL-HR.git 

cd airflow-etl-hr

Install required Python packages:

sh

pip install -r requirements.txt

Setup Airflow Connections:

To connect Airflow to your Oracle databases, you need to create connections in the Airflow web interface:

    Open the Airflow web interface (typically at http://localhost:8080).
    Go to Admin -> Connections.
    Click the + button to add a new connection.
    Add a connection with the following details for the source database:
        Conn Id: Oracle_DW_Source
        Conn Type: Oracle
        Host: your_source_db_host
        Schema: your_sid or your service_name
        Login: your_db_username
        Password: your_db_password
        Port: your_db_port
    Add a connection with the following details for the target database:
        Conn Id: Oracle_DW_Target
        Conn Type: Oracle
        Host: your_target_db_host
        Schema: your_sid or your service_name
        Login: your_db_username
        Password: your_db_password
        Port: your_db_port

Deploy the DAG:

Place the DW_HR_ETL.py file in your Airflow DAGs folder.

Deploy the SQL scripts:

Execute the SQL scripts in the sql_scripts folder on your Oracle database to create the necessary tables and procedures. You can use a tool like SQL*Plus, SQL Developer, or any other Oracle client to run the scripts.

sh

    sqlplus your_db_username/your_db_password@your_db_host:your_db_port/your_db_service < sql_scripts/create_staging_tables.sql
    sqlplus your_db_username/your_db_password@your_db_host:your_db_port/your_db_service < sql_scripts/create_dimension_tables.sql
    sqlplus your_db_username/your_db_password@your_db_host:your_db_port/your_db_service < sql_scripts/STG_SP_INSERT_ETL_DEPENDENCIES.sql
    sqlplus your_db_username/your_db_password@your_db_host:your_db_port/your_db_service < sql_scripts/STG_SP_STG_TRUNCATE_TABLE.sql
    sqlplus your_db_username/your_db_password@your_db_host:your_db_port/your_db_service < sql_scripts/STG_SP_SYNC_STG_TABLE_STRUCTURE.sql
    sqlplus your_db_username/your_db_password@your_db_host:your_db_port/your_db_service < sql_scripts/STG_SP_STG_HR.sql
    sqlplus your_db_username/your_db_password@your_db_host:your_db_port/your_db_service < sql_scripts/DW_SP_DIM_HR.sql

Running the DAG

    Start Airflow:

    Make sure your Airflow services are up and running:

    sh

    airflow db init
    airflow webserver --port 8080
    airflow scheduler

    Trigger the DAG:

    In the Airflow web interface, trigger the DW_HR_ETL DAG manually or wait for it to be triggered according to its schedule.


Special thanks to all contributors and the open-source community.