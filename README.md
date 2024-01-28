<h1>Data Engineering Capstone Project: KEGG Data Analysis</h1>

<h2>👩🏻‍💻 Database</h2>

The selected database is part of a larger dataset used in an ongoing research at the LaBella Lab (link) at the University of North Carolina Charlotte (UNC Charlotte). The database we are using contains the output files from a machine learning (ML) model trained on genomic and environmental data of 1,154 strains from 1,049 fungal species in the subphylum Saccharomycotina. As this research is ongoing, I cannot share the data files until our results are published, the estimated publication date is July 2024. 
<br />
The KEGG data file has this data structure:
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
    * MeanDecreaseAccuracy —> Mean Decrease Accuracy (This shows how much our model accuracy decreases if we leave out that variable) of each KEGG, ranked from highest importance to lowest. 
    * MeanDecreaseGini —> Mean Decrease Gini (This is a measure of variable importance based on the Gini impurity index used for the calculating the splits in trees) of each KEGG, ranked from highest importance to lowest.
* See [here](https://github.com/stellalo/random_forest_kegg) to learn more about the ML model.


<h2>🪐 Problem Statement</h2>

* What the most important KEGG, ranked by both MeanDecreaseAccuracy and MeanDecreaseGini, of the 4 different factors/traits used to build the model?
* What are the top 10 KEGGs of the 4 different models, ranked by MeanDecreaseAccuracy and MeanDecreaseGini?

<h2>🌒 Project Architecture & Technology Used</h2>
<img width="892" alt="Screenshot 2024-01-28 at 12 54 34 PM" src="https://github.com/stellalo/Data-Engineering-Capstone-KEGG-dataset-/assets/89308696/dde4cd24-dd94-4c9d-a31c-8989864e3e82">

<b><ins>IaC (Cloud Resources):</ins></b>
* Terraform
    * Link to code/folder
Batch Data Ingestion & Workflow Orchestration
* Prefect:8
    * Data lake —> To GCS —> Link to first pipeline. 
￼
    * Data Warehouse —> To BQ —> Link to 2nd pipeline
        * Parent Flow DAG:
￼
			to_bq DAG:
￼
    * *partition & cluster not used in this project. Explain!
Data Transformation
* Dbt
    * Link to code/folder/repo
￼
Data Visualization
* Data Looker Studio
    * Link to dashboard?

```ruby
library(reshape2)
library(dplyr)
library(tidyverse)
library(randomForest)
library(caret)
library(ranger)
```
