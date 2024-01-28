from pathlib import Path
import pandas as pd
from prefect import flow,task
from prefect_gcp.cloud_storage import GcsBucket 
from prefect_gcp import GcpCredentials 
from google.cloud import storage
import os

@task 
def get_files(folder_path):
    files = os.listdir(folder_path)
    #filter out '.DS_Store'
    files = [file for file in files if not file.startswith('.')]
    return files

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
        path = f'{folder_path}/{file}'
        table_name = parse_path(file)
        df = read_file(path)
        write_bq(df,table_name,type)

@flow()
def parent_flow(file_type:list[str]):
    for type in file_type:
        folder_path= f'kegg-orchestration/data/{type}'
        files = get_files(folder_path)
        to_bq(files,folder_path,type)

if __name__ == '__main__':
    type=["MeanDecreaseAccuracy","MeanDecreaseGini"]
    parent_flow(type)

    


