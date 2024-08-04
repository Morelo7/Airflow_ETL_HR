from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.oracle.hooks.oracle import OracleHook
from datetime import datetime, timedelta

def update_stg_table_structure(**kwargs):
    conn_id = 'Oracle_DW_Source'
    oracle_hook = OracleHook(oracle_conn_id=conn_id)
    connection = oracle_hook.get_conn()
    cursor = connection.cursor()
    cursor.callproc('STG.SP_STG_INSERT_ETL_DEPENDENCIES',['SP_STG_HR'])
    cursor.execute("SELECT D.REFERENCED_OWNER OWNER_NAME,D.REFERENCED_NAME TABLE_NAME FROM STG.TBL_ETL_DEPENDENCIES D WHERE REFERENCED_OWNER='HR'")
    data = cursor.fetchall()
    
    for row in data:
        owner_name = row[0]
        table_name = row[1]
        table_name_STG = 'STG_' + row[1]
 
        cursor.callproc('STG.SP_SYNC_STG_TABLE_STRUCTURE', [owner_name,table_name, 'STG',table_name_STG])
    
    connection.commit()
    cursor.close()
    connection.close()

def extract_transform_data(**kwargs):
    conn_id = 'Oracle_DW_Source'
    oracle_hook = OracleHook(oracle_conn_id=conn_id)
    connection = oracle_hook.get_conn()
    cursor = connection.cursor()
    cursor.callproc('STG.SP_STG_HR')
    #data = cursor.fetchall()
    connection.commit()
    cursor.close()
    connection.close()

def load_data(**kwargs):
    #ti = kwargs['ti']
    #data = ti.xcom_pull(task_ids='transform_data')
    
    conn_id = 'Oracle_DW_Target'
    oracle_hook = OracleHook(oracle_conn_id=conn_id)
    connection = oracle_hook.get_conn()
    cursor = connection.cursor()
    
    cursor.callproc('DW.SP_DIM_HR')
    #data = cursor.fetchall()
    connection.commit()
    cursor.close()
    connection.close()    
    
      
# Define the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 7, 27),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(days=1),
}

dag = DAG(
    'DW_HR_ETL',
    default_args=default_args,
    description='A ETL DAG to read from Oracle, transform data, and write to Dimensions tables in Oracle',
    schedule=timedelta(days=1),
)

# Define tasks
update_stg_table_structure_task = PythonOperator(
    task_id='update_stg_table_structure',
    python_callable=update_stg_table_structure,
    retries=3,  
    retry_delay=timedelta(minutes=1),
    dag=dag,  
)

extract_transform_task = PythonOperator(
    task_id='extract_transform_data',
    python_callable=extract_transform_data,
    retries=3,  
    retry_delay=timedelta(minutes=1),
    dag=dag,
)

load_task = PythonOperator(
    task_id='load_data',
    python_callable=load_data,
    retries=3,  
    retry_delay=timedelta(minutes=1),
    dag=dag
)

update_stg_table_structure_task >> extract_transform_task >> load_task