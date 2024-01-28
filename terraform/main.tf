terraform {
  backend "local" {}
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

#Data lake bucket
resource "google_storage_bucket" "data-lake-bucket"{
    name="${local.data_lake_bucket}_${var.project}"  #concatenating DL bucket & project name
    location=var.region

    #optional but recommended setting
    storage_class=var.storage_class
    uniform_bucket_level_access=true 

    versioning{
        enabled=true
    }

    lifecycle_rule{
        action{
            type="Delete"
        }
        condition{
            age="30" #days
        }
    }
    force_destroy=true
}

//In Process
//
#DWH
resource "google_bigquery_dataset" "dataset"{
    dataset_id = var.BQ_DATASET
    project = var.project
    location = var.region
}

resource "google_bigquery_table" "table"{
    dataset_id = google_bigquery_dataset.dataset.dataset_id
    project = var.project
    table_id = var.TABLE_NAME
}
