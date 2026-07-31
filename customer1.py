from datetime import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator

from airflow.providers.google.cloud.operators.bigquery import (
    BigQueryCreateEmptyDatasetOperator,
    BigQueryInsertJobOperator
)

from airflow.providers.google.cloud.transfers.gcs_to_bigquery import (
    GCSToBigQueryOperator
)

# -----------------------------------------------------
# Configuration
# -----------------------------------------------------

PROJECT_ID = "aratikatla2001"
REGION = "US"

BUCKET_NAME = "krishna_practice"

DATASET = "b52_customer"

STAGE_TABLE = "b52_stg_customer"
HIST_TABLE = "b52_hist_customer"
AUDIT_TABLE = "b52_audit_customer"

default_args = {
    "owner": "krishna",
    "start_date": datetime(2026, 7, 1)
}

with DAG(
    dag_id="b52_cust1_pipeline",
    default_args=default_args,
    schedule="*/10 * * * *",   # Every 10 minutes
    catchup=False,
    max_active_runs=1,
    tags=["customer", "gcp", "bigquery"]
) as dag:

    #------------------------------------------------

    start = EmptyOperator(
        task_id="start"
    )

    #------------------------------------------------
    # Dataset
    #------------------------------------------------

    create_dataset = BigQueryCreateEmptyDatasetOperator(
        task_id="create_dataset",
        project_id=PROJECT_ID,
        dataset_id=DATASET,
        location=REGION
    )

    #------------------------------------------------
    # Audit Table
    #------------------------------------------------

    create_audit = BigQueryInsertJobOperator(

        task_id="create_audit_table",

        configuration={
            "query": {
                "query": f"""

                CREATE TABLE IF NOT EXISTS
                `{PROJECT_ID}.{DATASET}.{AUDIT_TABLE}`

                (

                file_name STRING,
                load_date TIMESTAMP,
                total_records INT64,
                status STRING

                )

                """,

                "useLegacySql": False

            }

        }

    )

    #------------------------------------------------
    # Stage Table
    #------------------------------------------------

    create_stage = BigQueryInsertJobOperator(

        task_id="create_stage_table",

        configuration={

            "query": {

                "query": f"""

                CREATE TABLE IF NOT EXISTS
                `{PROJECT_ID}.{DATASET}.{STAGE_TABLE}`

                (

                customer_key STRING,
                customer_id STRING,
                customer_number STRING,
                first_name STRING,
                last_name STRING,
                country STRING,
                marital_status STRING,
                gender STRING,
                birthdate STRING,
                create_date STRING

                )

                """,

                "useLegacySql": False

            }

        }

    )

    #------------------------------------------------
    # Load Stage
    #------------------------------------------------

    load_stage = GCSToBigQueryOperator(

        task_id="load_stage",

        bucket=BUCKET_NAME,

        source_objects=['Gold_customers.csv'],
       

        destination_project_dataset_table=
        f"{PROJECT_ID}.{DATASET}.{STAGE_TABLE}",

        source_format="CSV",

        skip_leading_rows=1,

        write_disposition="WRITE_TRUNCATE",

        autodetect=False,
        force_rerun=True,

        schema_fields=[

            {"name":"customer_key","type":"STRING"},
            {"name":"customer_id","type":"STRING"},
            {"name":"customer_number","type":"STRING"},
            {"name":"first_name","type":"STRING"},
            {"name":"last_name","type":"STRING"},
            {"name":"country","type":"STRING"},
            {"name":"marital_status","type":"STRING"},
            {"name":"gender","type":"STRING"},
            {"name":"birthdate","type":"STRING"},
            {"name":"create_date","type":"STRING"}

        ]

    )

    #------------------------------------------------
    # History Table
    #------------------------------------------------

    hist_load = BigQueryInsertJobOperator(

        task_id="history_load",

        configuration={

            "query": {

                "query": f"""

                CREATE OR REPLACE TABLE
                `{PROJECT_ID}.{DATASET}.{HIST_TABLE}`

                AS

                SELECT

                    customer_key,
                    customer_id,
                    customer_number,

                    UPPER(first_name) AS first_name,

                    UPPER(last_name) AS last_name,

                    UPPER(country) AS country,

                    UPPER(marital_status) AS marital_status,

                    gender,

                    birthdate,

                    create_date,

                    CURRENT_TIMESTAMP() AS load_date

                FROM
                `{PROJECT_ID}.{DATASET}.{STAGE_TABLE}`

                """,

                "useLegacySql": False

            }

        }

    )

    #------------------------------------------------
    # Country View
    #------------------------------------------------

    country_view = BigQueryInsertJobOperator(

        task_id="country_view",

        configuration={

            "query": {

                "query": f"""

                CREATE OR REPLACE VIEW
                `{PROJECT_ID}.{DATASET}.v_country`

                AS

                SELECT

                    country,

                    COUNT(*) AS total_customers

                FROM
                `{PROJECT_ID}.{DATASET}.{HIST_TABLE}`

                GROUP BY country

                """,

                "useLegacySql": False

            }

        }

    )

    #------------------------------------------------
    # Marital Status View
    #------------------------------------------------

    marital_view = BigQueryInsertJobOperator(

        task_id="marital_status_view",

        configuration={

            "query": {

                "query": f"""

                CREATE OR REPLACE VIEW
                `{PROJECT_ID}.{DATASET}.v_marital_status`

                AS

                SELECT

                    marital_status,

                    COUNT(*) AS total_customers

                FROM
                `{PROJECT_ID}.{DATASET}.{HIST_TABLE}`

                GROUP BY marital_status

                """,

                "useLegacySql": False

            }

        }

    )

    #------------------------------------------------
    # Audit Insert
    #------------------------------------------------

    audit_insert = BigQueryInsertJobOperator(

        task_id="audit_insert",

        configuration={

            "query": {

                "query": f"""

                INSERT INTO
                `{PROJECT_ID}.{DATASET}.{AUDIT_TABLE}`

                SELECT

                'Gold_customers.csv',

                CURRENT_TIMESTAMP(),

                COUNT(*),

                'SUCCESS'

                FROM
                `{PROJECT_ID}.{DATASET}.{STAGE_TABLE}`

                """,

                "useLegacySql": False

            }

        }

    )

    #------------------------------------------------

    end = EmptyOperator(
        task_id="end"
    )

    #------------------------------------------------

    (
        start
        >> create_dataset
        >> create_audit
        >> create_stage
        >> load_stage
        >> hist_load
        >> [country_view, marital_view]
        >> audit_insert
        >> end
    )