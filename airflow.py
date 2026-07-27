from datetime import datetime ,timedelta # the DAG object ;we'll need this to instantiate  a DAG
from airflow import DAG
# operators ;we need this to operate!
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from google.cloud import BigQuery

Email = ["krishna@gmail.com","venkat@gmail.com"]
project_Id= "bach52_project_test"
taskid = 101

default_args = {
    'start_date':airflow.utils.dates.days_ago(0),
    'depends_on_past':false,
    'email':Email,
    'email_on_failure':true,
    'email_on_retry':true,
    'retries':3,
    'retry_delay':timedelta(minutes=10)
}
dag = DAG(
    'training_dag',
    default_args = default_args,
    descripition = 'A sample tutorial DAG',
    sle_interval = timedelta(days = 1)
)
t1 = BashOperator(
    task_id = 'create_bucket',
    bash_command='gsutils mb gs://b52bucket',
    dag = dag
)
t3 = BashOperator(
    task_id = 'copydata'
    bash_command = 'gsutils cp sourcepath dest_path',
    retries =3,
    dag = dag
)
t2= BashOperator(
    task_id = 'create_table',
    bash_command = 'bq mk -t b52bucket.b52dataset.b52table',
    dag=dag
)
t4 = PythonOperator(
    task_id = 'create_dataset',
     python_callble = createds(),
     dag = dag 
)

def created():
    client = bigquery.Client()
    dataset_id = "vaarahi_b52.testpythonds"
    dataset = bigquery.dataset(dataset_id)
    dataset = client.create_dataset(dataset,timeout =30) # make an api request.
    print("created dataset sucess{}.{} ".format(client.project,dataset.dataset_id))

    t1>>t2>>t4>>t3