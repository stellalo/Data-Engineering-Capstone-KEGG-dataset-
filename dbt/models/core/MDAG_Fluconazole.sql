{{ config(materialized='table') }}

with F_MDA as (
    select KEGG as KEGG_MDA, AVEG as MDA from {{ref ('MDA_Fluconazole_Resistance')}}
),
F_MDG as (
    select KEGG as KEGG_MDG, AVEG as MDG from {{ref ('MDG_Fluconazole_Resistance')}}
)
SELECT MDA.KEGG_MDA As KEGG, MDA.MDA, MDG.MDG
from F_MDA MDA 
inner join F_MDG MDG on MDA.KEGG_MDA = MDG.KEGG_MDG
