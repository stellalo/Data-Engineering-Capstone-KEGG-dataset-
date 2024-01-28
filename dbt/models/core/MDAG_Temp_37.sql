{{ config(materialized='table') }}

with T37_MDA as (
    select KEGG as KEGG_MDA, AVEG as MDA from {{ref ('MDA_Temp_37')}}
),
T37_MDG as (
    select KEGG as KEGG_MDG, AVEG as MDG from {{ref ('MDG_Temp_37')}}
)
SELECT MDA.KEGG_MDA As KEGG, MDA.MDA, MDG.MDG
from T37_MDA MDA 
inner join T37_MDG MDG on MDA.KEGG_MDA = MDG.KEGG_MDG
