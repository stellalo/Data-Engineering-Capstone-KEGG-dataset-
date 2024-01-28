{{ config(materialized='table') }}

with T37 as (
    select KEGG as KEGG_Temp_37, MDA as MDA_Temp_37, MDG as MDG_Temp_37 from {{ref ('MDAG_Temp_37')}}
),
XFC as (
    select KEGG as KEGG_XFC, MDA as MDA_XFC, MDG as MDG_XFC from {{ref ('MDAG_X_FC_Resistance')}}
),
Fluconazole as (
    select KEGG as KEGG_Fluconazole, MDA as MDA_Fluconazole, MDG as MDG_Fluconazole from {{ref ('MDAG_Fluconazole')}}
),
NaCl as (
    select KEGG as KEGG_O610_NaCl, MDA as MDA_O610_NaCl, MDG as MDG_O610_NaCl from {{ref ('MDAG_O610_NaCl')}}
)
SELECT T37.KEGG_Temp_37 As KEGG, T37.MDA_Temp_37, T37.MDG_Temp_37, 
XFC.MDA_XFC, XFC.MDG_XFC, F.MDA_Fluconazole, F.MDG_Fluconazole, N.MDA_O610_NaCl,N.MDG_O610_NaCl
from T37
inner join XFC on T37.KEGG_temp_37 = XFC.KEGG_XFC
inner join Fluconazole F on T37.KEGG_temp_37 = F.KEGG_Fluconazole
inner join NaCl N on T37.KEGG_temp_37 = N.KEGG_O610_NaCl