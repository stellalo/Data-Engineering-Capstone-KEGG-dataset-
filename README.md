<h1>Data Engineering Capstone Project: KEGG Data Analysis</h1>

<h2>👩🏻‍💻 Database</h2>

The selected database is part of a larger dataset used in an ongoing research at the LaBella Lab (link) at the University of North Carolina Charlotte (UNC Charlotte). The database we are using contains the output files from a machine learning (ML) model trained on genomic and environmental data of 1,154 strains from 1,049 fungal species in the subphylum Saccharomycotina. As this research is ongoing, I cannot share the data files until our results are published, the estimated publication date is July 2024. 
<br />
<br />
The KEGG data file has this data structure:
* Row: each row contains a different yeast species
* Column: each column contains a different KEGG
<br />
The ML model is built using the Random Forest algorithm, we set the training set to be 90% of total data, and reselect the training/testing set and seed in each iteration, for a total of 100 iterations. There are, in total 3 different models, each using the same KEGG dataset and corresponding environmental data file. They differ in the following ways to find the optimal model with the highest accuracy:
<br/>
* copy_number —> Stored in each column is the number of copies the corresponding yeast species has of that kegg (0,1,2,3,…)
* Expression —> Stored in each column is the codon expression level the corresponding yeast species has of that kegg .
* P/A —> Stored in each column is the present (1) or absent (0) the corresponding yeast species has of that kegg.
* With each model, we run it against 4 traits: 
    * Temperature 37 —> growth at temperature 37
    * X_FC_resistance (r1) —> a type of drug resistance
    * Fluconazole_resistance (r2) —> a type of drug resistance
    * O610_NaCl —> growth in salinity 
* We take 2 output files from this ML model to perform further analysis: 
    * MeanDecreaseAccuracy —> Mean Decrease Accuracy (This shows how much our model accuracy decreases if we leave out that variable) of each KEGG, ranked from highest importance to lowest. 
    * MeanDecreaseGini —> Mean Decrease Gini (This is a measure of variable importance based on the Gini impurity index used for the calculating the splits in trees) of each KEGG, ranked from highest importance to lowest.
* See here to learn more about the ML model.

<h2>🪐 Language and Packages</h2>

- <b>R Markdown</b>

The following packages are required to run the scripts: 
```ruby
library(reshape2)
library(dplyr)
library(tidyverse)
library(randomForest)
library(caret)
library(ranger)
```
