from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
from airflow.operators.dummy import DummyOperator
from airflow.operators.empty import EmptyOperator

def push_data(ti):
    total_customers = 100
    ti.xcom_push(
    key = "customer_count",
    value = total_customers
    )
def pull_data(ti):
    count = ti.xcom_pull(
      task_ids = "push_task",
      key = "customer_count"
    )
    print(f"customer count = {count}")    

with DAG(
"xcom_examples",
start_date = datetime(2026,7,31),
schedule = '@daily',
) as dag:
    
    start = EmptyOperator(
        task_id='start_dummy'
    )

push_task = PythonOperator(
task_id = "push_task",
python_callable =push_data, 

)
pull_task = PythonOperator(
task_id = "pull_task",
python_callable =pull_data, 
)
end = EmptyOperator(
        task_id='end_dummy'
    )
start>>push_task >> pull_task >>end