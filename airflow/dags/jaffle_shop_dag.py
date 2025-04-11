from airflow import DAG
from airflow.providers.google.cloud.operators.kubernetes_engine import GKEStartPodOperator
import pendulum
from datetime import timedelta
import os

# Default arguments for the DAG
default_args = {
    "owner": "standupfree",
    "depends_on_past": False,
    "email_on_failure": True,
    "email": ["standupfree.contact@gmail.com"],
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

# Define your Docker image and GKE settings
PROJECT_ID = "ae-bootcamp-standupfree"
REGION = "us"
REPOSITORY = "dbt-images-prod"  # or dev/preprod depending on the DAG
IMAGE_NAME = "dbt-jaffle-shop"
DOCKER_IMAGE_TAG = "latest"  # or specify a version like "1.0.0"

IMAGE_URI = f"{REGION}-docker.pkg.dev/{PROJECT_ID}/{REPOSITORY}/{IMAGE_NAME}:{DOCKER_IMAGE_TAG}"

# Define the DAG
with DAG(
    dag_id="dbt_jaffle_shop_dag",
    default_args=default_args,
    description="Run dbt jaffle shop image on GKE",
    schedule="0 5 * * *",  # Runs everyday at 5am
    start_date=pendulum.today('UTC').add(days=-1),
    catchup=False,
    tags=["dbt", "jaffle_shop" , "daily" , "ae_bootcamp", "standupfree"],
) as dag:

    run_dbt = GKEStartPodOperator(
    		task_id="dbt_jaffle_shop_dag",
		project_id="ae-bootcamp-standupfree",
		service_account_name="k8s-dbt-job",
    		location="us-central1",
    		cluster_name="autopilot-cluster-1",
   	 	namespace="default",
		do_xcom_push=True,
    		image=IMAGE_URI,
    		cmds=["dbt", "build", "--target", "prod"],
    		name="dbt_jaffle_shop_job",
		in_cluster=False,
		on_finish_action="delete_pod",
    )

    run_dbt

