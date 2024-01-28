<h1>Data Engineering Capstone Project: KEGG Data Analysis</h1>

<h2>👩🏻‍💻 Database</h2>

The selected database is part of a larger dataset used in an ongoing research at the [LaBella Lab](https://www.lablabella.com) at the University of North Carolina Charlotte (UNC Charlotte). The database we are using contains the output files from a machine learning (ML) model trained on genomic and environmental data of 1,154 strains from 1,049 fungal species in the subphylum Saccharomycotina. As this research is ongoing, the data files used in this project will not be shared until the results are published. 
<br />
<br />
<b><ins>The database has the following architecture:</ins></b>

<img width="322" alt="Screenshot 2024-01-28 at 2 50 52 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/05fe5af9-f39b-4cf6-8a82-72730e0ba3d6">

<b><ins>The KEGG data file has the following data structure: </ins></b>
* <b>Row</b>: each row contains a different yeast species
* <b>Column</b>: each column contains a different [KEGG](https://www.genome.jp/kegg/)
<br />
The ML model is built using the Random Forest algorithm, we set the training set to be 90% of total data, and reselect the training/testing set and seed in each iteration, for a total of 100 iterations. There are, in total 3 different models, each using the same KEGG dataset and corresponding environmental data file. They differ in the following ways to find the optimal model with the highest accuracy:

* <b>copy_number</b> —> Stored in each column is the number of copies the corresponding yeast species has of that kegg (0,1,2,3,…)
* <b>Expression</b> —> Stored in each column is the codon expression level the corresponding yeast species has of that kegg .
* <b>P/A</b> —> Stored in each column is the present (1) or absent (0) the corresponding yeast species has of that kegg.
* With each model, we run it against 4 traits: 
    * <b>Temperature 37</b> —> growth at temperature 37
    * <b>X_FC_resistance (r1)</b> —> a type of drug resistance
    * <b>Fluconazole_resistance (r2)</b> —> a type of drug resistance
    * <b>O610_NaCl</b> —> growth in salinity 
* We take 2 output files from this ML model to perform further analysis: 
    * <b>MeanDecreaseAccuracy (MDA) </b>—> Mean Decrease Accuracy (This shows how much our model accuracy decreases if we leave out that variable) of each KEGG, ranked from highest importance to lowest. 
    * <b>MeanDecreaseGini (MDG) </b>—> Mean Decrease Gini (This is a measure of variable importance based on the Gini impurity index used for the calculating the splits in trees) of each KEGG, ranked from highest importance to lowest.
* See [here](https://github.com/stellalo/random_forest_kegg) to learn more about the ML model.


<h2>🪐 Problem Statement</h2>

* What the most important KEGG, ranked by both MeanDecreaseAccuracy and MeanDecreaseGini, of the 4 different factors/traits used to build the model?
* What are the top 10 KEGGs of the 4 different models, ranked by MeanDecreaseAccuracy and MeanDecreaseGini?

<h2>🌒 Project Architecture & Technology Used</h2>
<img width="892" alt="Screenshot 2024-01-28 at 12 54 34 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/dde4cd24-dd94-4c9d-a31c-8989864e3e82">

<b><ins>IaC (Cloud Resources):</ins></b>
* [Terraform](https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/tree/main/terraform)

<b><ins>Batch Data Ingestion & Workflow Orchestration:</ins></b>
* Prefect:
 	* [Pipeline to Google Cloud Storage](https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/blob/main/pipelines-to-gcs-bq/pipeline_to_gcs.py)
 	<img width="520" alt="Screenshot 2023-12-27 at 3 00 21 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/0d68054d-5bba-4d18-b68e-85bde7c9c398">


	* [Pipeline to BigQuery](https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/blob/main/pipelines-to-gcs-bq/pipeline_to_bq.py)
		* Parent Flow DAG:
		￼<img width="1237" alt="Screenshot 2023-12-28 at 3 49 58 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/8a471bfd-9c1c-4ab1-8457-a627960cdee2">

		* Child Flow DAG: 
		<img width="737" alt="Screenshot 2023-12-28 at 3 50 35 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/fd79705a-7acd-46a7-b87a-52204cc9c4af">
￼
* Partition & cluster
 	* We will not be using Partitions nor clustering in this project. All our data files are significantly less than 1GB, using partitions/clusters actually incur more metadata reads & maintenance. In addition, the data won’t work well with partitions and clustering. The columns are: KEGG, iteration 1,,,, iteration 100, Mean, whereas the rows are distinctive KEGGs.

<b><ins>Data Transformation:</ins></b>
* [Dbt](https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/tree/main/dbt)
<img width="1109" alt="Screenshot 2024-01-14 at 3 21 41 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/27f3ccec-7e53-451d-84df-9c8752f4641c">


<b><ins>Data Visualization:</ins></b>
* Data Looker Studio

<h2>🌓 Data Visualization</h2>

* Top 25 KEGGs ranked by MeanDecreaseAccuracy:
<img width="880" alt="Screenshot 2024-01-28 at 4 33 14 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/cadf0c75-7f6a-458d-8ef0-bf1da3f1457e">


* Top 25 KEGGs ranked by MeanDecreaseGini:
<img width="895" alt="Screenshot 2024-01-28 at 4 33 23 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/8e2bc107-6249-4877-948d-2ddbd926f250">


* Top 10 KEGGS of all 4 traits
<img width="897" alt="Screenshot 2024-01-28 at 4 33 30 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/c7e9e85c-e795-42b3-a135-f70454d1e445">


<h2>🌔 Steps to Reproduce</h2>
<h3>Step 1: Use Terraform to create bucket in GCS, dataset & table in BigQuery.</h3>

* <b><ins>Set up GCP</ins></b>: After creating your GCP account, create or modify the following resources to enable Terraform to provision your infrastructure:
	* A GCP Project: GCP organizes resources into projects. Create one in the GCP console and keep note of the project ID.
 	* Google Compute Engine: enable google compute engine for your project in the GCP console.
  	* A GCP service account key: create a service account key to enable Terraform to access your GCP account. Add the following roles in addition to Viewer: <b>Storage Admin + Storage Object Admin + BigQuery Admin</b>
<img width="555" alt="Screenshot 2023-12-24 at 9 15 02 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/fdd039f0-3aa0-4d81-a2d7-f96025eda443">

* <b><ins>Terraform Configuration</ins></b>: Each Terraform configuration must be in its own working directory. Create a working directory for your configuration and cd into it.

```ruby
mkdir kegg-terraform
cd kegg-terraform
```

* Create a <b><ins>main.tf</ins></b> and <b><ins>variables.tf</ins></b> for your Terraform configuration:
```ruby
touch main.tf
touch variables.tf
```

* Initialize Terraform statefile
```ruby
terraform init
```

* Create Cloud Infrastructure
```ruby
terraform apply
```

<img width="451" alt="Screenshot 2023-12-24 at 1 56 47 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/e2616c67-0738-43dc-ad48-fc854a759287">
<img width="526" alt="Screenshot 2023-12-24 at 1 56 57 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/85e878a2-1731-4b42-ac7d-e7fe354d0de1">

* Result:
	* Bucket in GCS named kegg_data_lake_kegg-data-analysis is created.
	<img width="576" alt="Screenshot 2024-01-28 at 3 22 29 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/d0fd7ead-6141-43a9-9751-3a19fb805d9b">

 	* BQ dataset named kegg-dataset is created. Within this dataset, a table named kegg_data is created.
	<img width="358" alt="Screenshot 2024-01-28 at 3 27 25 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/492c8ca0-b521-479b-863f-6d2498c500ac">

<h3>Step 2: Create Python Pipeline that Uploads Data to GCS.</h3>
* Conda Setup

```ruby
conda create -n kegg python=3.9
conda activate kegg
```

* Start Prefect server/UI
```ruby
prefect server start
```
* Run the pipeline via Prefect Deployement
```ruby
Prefect deployment build ./pipeline_to_gcs.py:parent_flow -n Parameterized_KEGG_Pipeline
```
This will produce a yaml file and build a deployment. Specify path to file and flow entry point, and give this deployment a name.

```ruby
prefect deployment apply parent_flow-deployment.yaml
```
* To apply the deployment we just created, run the above command. Note that we are specifying the yaml file next to apply. 
Once the deployment is activated, go to Prefect’s UI and start a Quick/custom run. The deployment won’t run until you start an agent. 
Because this deployment has no schedule or triggering automation, you will need to use the UI or API to create runs for it. 

* Start prefect agent
```ruby
prefect agent start --pool "default-agent-pool"
```

******If you run it via deployment, you must give full path since it’s not running from your current directory (wherever that is). In addition, the agent probably doesn’t have permission to write to your local. So even if the execution was successful, the local files might not be written successfully to your local.******

* Result:
	* Data is written to local
 	* Data is written to GCS Bucket
 	<img width="564" alt="Screenshot 2024-01-28 at 3 50 41 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/280f9624-fb18-40eb-a0b3-843c8fa56885">

<h3>Step 3: Create Python Pipeline that Uploads Data to Google BigQuery</h3>

* Run the Python pipeline
```ruby
python3 pipeline_to_bq.py
```

* In pipeline_to_bq, we actually don’t need to download the data from GCS to local, since we already wrote the files to local in pipeline_to_gcs. We will therefore load get the data from local. See [here](https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/blob/main/pipelines-to-gcs-bq/pipeline_gcs_to_bq.py) for pipeline that downloads data from GCS and upload to BQ.
* Result: you will now see the files under the corresponding folder in BQ: 
<img width="275" alt="Screenshot 2023-12-28 at 3 49 40 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/083380a3-c342-4fc5-836a-b63c5e319db8">

<h3>Step 4: Transform data in BigQuery using dbt</h3>

* Setting up dbt for using BigQuery
* Clone the [dbt starter project](https://github.com/dbt-labs/dbt-starter-project)
* In dbt Development, click <b><ins>Initialize your project</ins></b> and <b><ins>Commit</ins></b> to finish setting up your project. After committing, you'll be able to create a new branch in the IDE. Create a "dev" branch for development. The main branch will be read-only after project initialization.
* Once all the dbt models are created, build the model.
```ruby
dbt build
```
* We are running "dbt build" instead of "dbt run" because the <b><ins>unique</ins></b> and <b><ins>not_null</ins></b> tests are added to MDAG_combined.sql file in Models/Core.
* Example data transformation file:
<img width="589" alt="Screenshot 2024-01-14 at 3 34 05 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/660fe8b0-aa7d-4345-b83c-cad808d182ec">
<img width="507" alt="Screenshot 2024-01-14 at 3 33 59 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/0a777682-0c92-448c-9c72-1b7e57876540">

* When you execute "dbt build", you are building a model that will transform your data without that data ever leaving your warehouse.
* Result: Your transformed data will be in Google BigQuery:

![Group 9](https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/14e83d8b-48e5-40f2-9705-68b047daa8d9)

***Not required but you can also set up deployement in dbt, this will store the resulted transformed data in your production dataset:

<img width="306" alt="Screenshot 2024-01-28 at 4 20 20 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/17b8e3c9-db75-4306-ac17-52876aeabd69">

<h3>Step 5 (FINAL STEP!): Visualize data using Google Looker Studio</h3>

* Create a report and load data from Google BQ.

* Create the data dashboards:
<img width="1328" alt="Screenshot 2024-01-28 at 4 23 08 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/e738a90c-b90f-4e4d-9d30-4c53923def6c">

All done :)
