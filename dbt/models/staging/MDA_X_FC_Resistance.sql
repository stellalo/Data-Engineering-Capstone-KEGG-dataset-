{{ config(materialized='view') }}

with E_X_FC_Resistance_data as (
    select KEGG, Mean as E_Mean
    from {{ source('staging', 'E_X_FC_Resistance') }}
), 
PA_X_FC_Resistance_data as (
    select KEGG, Mean as PA_Mean
    from {{ source('staging', 'PA_X_FC_Resistance') }}
),
CN_X_FC_Resistance_data as (
    select KEGG, Mean AS CN_Mean
    from {{ source('staging', 'CN_X_FC_Resistance') }}
)
select E.KEGG, E.E_Mean, PA.PA_Mean, CN.CN_Mean,(E.E_Mean + PA.PA_Mean + CN.CN_Mean) / 3 as AVEG
from E_X_FC_Resistance_data E
inner join PA_X_FC_Resistance_data PA on E.KEGG = PA.KEGG
inner join CN_X_FC_Resistance_data CN on E.KEGG = CN.KEGG
ORDER BY AVEG DESC