locals{
    data_lake_bucket="kegg_data_lake"
}

variable "project" {
    description="The name of the project"
    type=string
    default="kegg-data-analysis"
 }

variable "region" {
    description="Region for GCP resources."
    default="northamerica-northeast1"
    type=string
}

variable "storage_class"{
    description="Storage class type for your bucket."
    default="STANDARD"
}

variable "BQ_DATASET"{
    description="BigQuery Dataset that raw data (from GCS) will be written to"
    type = string
    default="kegg_dataset"
}

variable "TABLE_NAME"{
    description="BigQuery Table"
    type=string
    default="kegg_data"
}
