from pathlib import Path
import pandas as pd
from prefect import flow,task
from prefect_gcp.cloud_storage import GcsBucket  
from prefect.tasks import task_input_hash 
from datetime import timedelta

@task
def col_names() -> list[str]:
    """Replace the columns from 2 to 101 from random seed value to iteration number"""
    new_cols= [f'iteration_{i}' for i in range(1,101)]
    return new_cols


@task(retries=3,cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1))
def write_local(df_path:Path,cols:list[str],file_type:str) -> list[Path]:
    """Write dataframe out locally as a parquet file"""
    #Get the xslv object
    xlsv=pd.ExcelFile(df_path)
    #Create an empty list to store path names
    paths=[]
    #separate each sheet and store them as parquet individually
    for sheet in xlsv.sheet_names:
        df=pd.read_excel(df_path,sheet_name=sheet)
        #Replace the columns
        df.columns= [df.columns[0]] + cols + [df.columns[-1]]
        print(df.columns)
        parquet_path=f'data/{file_type}/{sheet}.parquet'
        local_path=f'/Users/stella/Desktop/kegg-orchestration/data/{file_type}/{sheet}.parquet'
        paths.append(parquet_path)
        df.to_parquet(local_path, compression="gzip")
    return paths

@task
def write_gcs(paths:list[Path]) -> None:
    for path in paths:
        """Upload local parquet file to gcs"""
        gcs_block = GcsBucket.load("kegg-gcs")
        gcs_block.upload_from_path(
            from_path = f"{path}",
            to_path = path
        )
    return

@flow()
def etl_web_to_gcs(type:str) -> None:
    """The Main ETL Function"""
    data_path=f"/Users/stella/Desktop/kegg-orchestration/{type}.xlsx"
    cols=col_names()
    paths=write_local(data_path,cols,type)
    write_gcs(paths)

@flow()
def parent_flow(file_type:list[str]):
    for type in file_type:
        etl_web_to_gcs(type)
    

if __name__ == '__main__':
    type=["MeanDecreaseAccuracy","MeanDecreaseGini"]
    parent_flow(type)
