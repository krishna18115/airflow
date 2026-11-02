from datetime import timedelta

from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.empty import EmptyOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator

# ------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------
PROJECT_ID = "aratikatla2001"
DATASET_ID = "airflows_dataset"      # Existing Dataset

default_args = {
    "owner": "airflow",
    "start_date": days_ago(1),
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}

with DAG(
    dag_id="emp_airflow",
    default_args=default_args,
    schedule_interval="*/10 * * * *",
    catchup=False,
    tags=["BigQuery", "Employee"],
) as dag:

    start = EmptyOperator(
        task_id="start"
    )

    # --------------------------------------------------------------
    # Create Employee Table
    # --------------------------------------------------------------
    create_table = BigQueryInsertJobOperator(
        task_id="create_employee_table",
        configuration={
            "query": {
                "query": f"""
                CREATE TABLE IF NOT EXISTS
                `{PROJECT_ID}.{DATASET_ID}.employees`
                (
                    empID INT64,
                    empname STRING,
                    location STRING,
                    phone STRING,
                    department STRING
                );
                """,
                "useLegacySql": False,
            }
        },
        location="US",      # Change to us-central1 if your dataset is regional
    )

    # --------------------------------------------------------------
    # Insert Employee Records
    # --------------------------------------------------------------
    insert_data = BigQueryInsertJobOperator(
        task_id="insert_employee_data",
        configuration={
            "query": {
                "query": f"""
                INSERT INTO `{PROJECT_ID}.{DATASET_ID}.employees`
                (empID, empname, location, phone, department)

                VALUES
                (101,'Krishna','Hyderabad','9876543210','IT'),
                (102,'Ravi','Chennai','9876543211','HR'),
                (103,'Sita','Hyderabad','9876543212','IT'),
                (104,'Anil','Bangalore','9876543213','Finance'),
                (105,'Priya','Chennai','9876543214','HR'),
                (106,'Rahul','Pune','9876543215','IT');
                """,
                "useLegacySql": False,
            }
        },
        location="US",
    )

    # --------------------------------------------------------------
    # Create Department View
    # --------------------------------------------------------------
    create_view = BigQueryInsertJobOperator(
        task_id="create_department_view",
        configuration={
            "query": {
                "query": f"""
                CREATE OR REPLACE VIEW
                `{PROJECT_ID}.{DATASET_ID}.vw_department_count`
                AS

                SELECT
                    department,
                    COUNT(*) AS employee_count
                FROM `{PROJECT_ID}.{DATASET_ID}.employees`
                GROUP BY department;
                """,
                "useLegacySql": False,
            }
        },
        location="US",
    )

    end = EmptyOperator(
        task_id="end"
    )

    # DAG Flow
    start >> create_table >> insert_data >> create_view >> end
    
    
    
    
    #select * from `aratikatla2001.airflows_dataset.vw_department_count`