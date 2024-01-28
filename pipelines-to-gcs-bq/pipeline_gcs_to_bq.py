from pathlib import Path
import pandas as pd
from prefect import flow,task
#from prefect_gcp.cloud_storage import GcsBucket 
from prefect_gcp import GcpCredentials 
#from google.cloud import storage
import os

@task
def get_files(folder_path):
    files = os.listdir(folder_path)
    #filter out '.DS_Store'
    files = [file for file in files if not file.startswith('.')]
    return files


# def list_files_in_folder(bucket, folder):
#     # Initialize the GCS client
#     storage_client = storage.Client()
#     # Get the bucket
#     bucket = storage_client.get_bucket(bucket)
#     # List files under the specified folder
#     blobs = bucket.list_blobs(prefix=folder)
#     # Extract file names
#     file_list = [blob.name for blob in blobs if blob.name.endswith('/') == False]
#     #print(file_list)
#     return file_list
# @task(retries=3)
# def extract_from_gcs(gcs_path:str) -> Path:
#     """Download trip data from gcs"""
#     #load an instance of a class named GcsBucket 
#     gcs_block = GcsBucket.load("kegg-gcs")
#     local_path=f"/Users/stella/Desktop/kegg-orchestration/{gcs_path}.parquet"
#     #write file to local
#     gcs_block.get_directory(from_path=gcs_path, local_path=local_path)
#     return local_path

@task(retries=3)
def read_file(path: Path) -> pd.DataFrame:
    df = pd.read_parquet(path)
    return df

@task
def parse_path(path: Path) -> str:
    table_name = path.rsplit('.', 1)[0]
    return table_name

@task
def write_bq(df:pd.DataFrame,table:str,type:str) -> None:
    """Write dataframe into BQ"""
    gcp_credentials_block = GcpCredentials.load("kegg-gcs")

    df.to_gbq(
        destination_table=f"{type}.{table}",
        project_id="kegg-data-analysis",
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500_000,
        if_exists="append"
    )

@flow
def to_bq(files:list[str],folder_path:str,type:str):
    """Main flow to load data into big query data warehouse"""
    for file in files:
        #path = extract_from_gcs(file)
        path = f'{folder_path}/{file}'
        table_name = parse_path(file)
        df = read_file(path)
        write_bq(df,table_name,type)

@flow()
def parent_flow(file_type:list[str]):
    for type in file_type:
        folder_path= f'/Users/stella/Desktop/kegg-orchestration/data/{type}'
        #files = get_files(bucket, folder)
        files = get_files(folder_path)
        to_bq(files,folder_path,type)

if __name__ == '__main__':
    type=["MeanDecreaseAccuracy","MeanDecreaseGini"]
    parent_flow(type)

    


