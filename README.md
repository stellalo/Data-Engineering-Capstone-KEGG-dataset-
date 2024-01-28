<h1>Data Engineering Capstone Project: KEGG Data Analysis</h1>

<h2>👩🏻‍💻 Database</h2>

The selected database is part of a larger dataset used in an ongoing research at the LaBella Lab (link) at the University of North Carolina Charlotte (UNC Charlotte). The database we are using contains the output files from a machine learning (ML) model trained on genomic and environmental data of 1,154 strains from 1,049 fungal species in the subphylum Saccharomycotina. As this research is ongoing, I cannot share the data files until our results are published, the estimated publication date is July 2024. 
<br />
<br />
<b><ins>The database has the following architecture:</ins></b>

<img width="322" alt="Screenshot 2024-01-28 at 2 50 52 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/05fe5af9-f39b-4cf6-8a82-72730e0ba3d6">

<b><ins>The KEGG data file has this data structure: </ins></b>
* <b>Row</b>: each row contains a different yeast species
* <b>Column</b>: each column contains a different KEGG
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
* Partition & cluster.
 	*We will not be using Partitions nor clustering in this project. All our data files are significantly less than 1GB, using partitions/clusters actually incur more metadata reads & maintenance. In addition, the data won’t work well with partitions and clustering. The columns are: KEGG, iteration 1,,,, iteration 100, Mean, whereas the rows are distinctive KEGGs.

<b><ins>Data Transformation:</ins></b>
* [Dbt](https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/tree/main/dbt)
<img width="1109" alt="Screenshot 2024-01-14 at 3 21 41 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/27f3ccec-7e53-451d-84df-9c8752f4641c">


<b><ins>Data Visualization:</ins></b>
* Data Looker Studio

<h2>🌓 Data Visualization</h2>

* Top 25 KEGGs ranked by MeanDecreaseAccuracy:
    * Temp_37:
    
    <img width="423" alt="Screenshot 2024-01-28 at 1 05 29 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/4a12b516-141b-4167-a34c-5896351512a1">

    * X_FC_Resistance:
    <img width="429" alt="Screenshot 2024-01-28 at 1 05 34 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/fb792d56-86d9-4454-b1d6-0927ca8e4905">

    * Fluconazole_Resistance:
    <img width="433" alt="Screenshot 2024-01-28 at 1 05 40 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/c92cecdd-14f4-437b-b8f5-f7c4367ce33e">

    * O610_NaCl:
    <img width="423" alt="Screenshot 2024-01-28 at 1 05 45 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/4acde7b6-d182-4443-98fd-0d2b324c0192">

* Top 25 KEGGs ranked by MeanDecreaseGini:
    * Temp_37:
    <img width="434" alt="Screenshot 2024-01-28 at 1 05 50 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/749d3152-826e-4b46-90e7-c53803bdc266">

    * X_FC_Resistance:
    <img width="422" alt="Screenshot 2024-01-28 at 1 06 01 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/d4edf6ff-1c11-4528-9630-f63b27808ca3">

    * Fluconazole_Resistance:
    <img width="422" alt="Screenshot 2024-01-28 at 1 06 09 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/052c5e66-8fdf-40b7-9878-4debcfccb99a">

    * O610_NaCl:
    <img width="416" alt="Screenshot 2024-01-28 at 1 06 18 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/1b16f9d3-127b-47a4-a270-c78862ec64c0">

* Top 10 KEGGS of all 4 traits
    * Sorted by MDA:
    <img width="452" alt="Screenshot 2024-01-28 at 1 06 30 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/fb4218bc-2cec-4fac-9682-6492030fc8dd">

    * Sorted by MDG: 
    <img width="452" alt="Screenshot 2024-01-28 at 1 06 38 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/7c1560eb-3fc3-4902-8b73-630f1a685bfb">

<h2>🌔 Steps to Reproduce</h2>

```ruby
library(reshape2)
library(dplyr)
library(tidyverse)
library(randomForest)
library(caret)
library(ranger)
```
