<h1>Data Engineering Capstone Project: KEGG Data Analysis</h1>

<h2>👩🏻‍💻 Database</h2>

The selected database is part of a larger dataset used in an ongoing research at the LaBella Lab (link) at the University of North Carolina Charlotte (UNC Charlotte). The database we are using contains the output files from a machine learning (ML) model trained on genomic and environmental data of 1,154 strains from 1,049 fungal species in the subphylum Saccharomycotina. As this research is ongoing, I cannot share the data files until our results are published, the estimated publication date is July 2024. 
<br />
The KEGG data file has this data structure:
* Row: each row contains a different yeast species
* Column: each column contains a different KEGG

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
