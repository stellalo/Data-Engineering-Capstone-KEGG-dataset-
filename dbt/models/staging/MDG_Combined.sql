{{ config(materialized='view') }}

with T37_data as (
    select KEGG as KEGG_temp, AVEG as Mean_temp from {{ref ('MDG_Temp_37')}}
),
XFC_data as (
    select KEGG as KEGG_XFC, AVEG as Mean_XFC from {{ref ('MDG_X_FC_Resistance')}}
),
Fluconazole_data as (
    select KEGG as KEGG_Fluconazole, AVEG as Mean_Fluconazole  from {{ref ('MDG_Fluconazole_Resistance')}}
),
NaCl_data as (
    select KEGG as KEGG_NaCl, AVEG as Mean_NaCl  from {{ref ('MDG_O610_NaCl')}}
)
SELECT T.KEGG_temp As KEGG, T.Mean_temp, XFC.Mean_XFC, F.Mean_Fluconazole, N.Mean_NaCl, 
(T.Mean_temp + XFC.Mean_XFC + F.Mean_Fluconazole + N.Mean_NaCl) / 4 as AVEG
from T37_data T 
inner join XFC_data XFC on T.KEGG_temp = XFC.KEGG_XFC
inner join Fluconazole_data F on T.KEGG_temp = F.KEGG_Fluconazole
inner join NaCl_data N on T.KEGG_temp = N.KEGG_NaCl
ORDER BY AVEG DESC