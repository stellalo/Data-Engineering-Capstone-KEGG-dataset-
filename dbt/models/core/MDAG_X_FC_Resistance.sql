{{ config(materialized='table') }}

with XFC_MDA as (
    select KEGG as KEGG_MDA, AVEG as MDA from {{ref ('MDA_X_FC_Resistance')}}
),
XFC_MDG as (
    select KEGG as KEGG_MDG, AVEG as MDG from {{ref ('MDG_X_FC_Resistance')}}
)
SELECT MDA.KEGG_MDA As KEGG, MDA.MDA, MDG.MDG
from XFC_MDA MDA 
inner join XFC_MDG MDG on MDA.KEGG_MDA = MDG.KEGG_MDG
