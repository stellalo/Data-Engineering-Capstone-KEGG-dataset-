{{ config(materialized='table') }}

with NaCl_MDA as (
    select KEGG as KEGG_MDA, AVEG as MDA from {{ref ('MDA_O610_NaCl')}}
),
NaCl_MDG as (
    select KEGG as KEGG_MDG, AVEG as MDG from {{ref ('MDG_O610_NaCl')}}
)
SELECT MDA.KEGG_MDA As KEGG, MDA.MDA, MDG.MDG
from NaCl_MDA MDA 
inner join NaCl_MDG MDG on MDA.KEGG_MDA = MDG.KEGG_MDG
