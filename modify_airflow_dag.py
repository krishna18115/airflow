from datetime import timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator
from airflow.utils.dates import days_ago

default_args = {
    "start_date": days_ago(1),
    "retries": 3,
    "retry_delay": timedelta(minutes=10)
}

dag = DAG(
    dag_id="first_dag_airflow4",
    default_args=default_args,
    schedule_interval="*/10 * * * *",
    catchup=False
)

start = EmptyOperator(
    task_id="start",
    dag=dag
)

create_bucket = BashOperator(
    task_id="create_bucket",
    bash_command="gsutil mb gs://airflow-bucket_new",
    dag=dag
)

create_dataset = BashOperator(
    task_id="create_dataset",
    bash_command="bq mk -d airflows1_dataset",
    dag=dag
)

end = EmptyOperator(
    task_id="end",
    dag=dag
)

start >> create_bucket >> create_dataset >> end