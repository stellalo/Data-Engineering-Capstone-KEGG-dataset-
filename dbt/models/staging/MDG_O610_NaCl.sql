{{ config(materialized='view') }}

with E_O610_NaCl_data as (
    select KEGG, Mean as E_Mean
    from {{ source('staging_MDG', 'E_O610_NaCl') }}
), 
PA_O610_NaCl_data as (
    select KEGG, Mean as PA_Mean
    from {{ source('staging_MDG', 'PA_O610_NaCl') }}
),
CN_O610_NaCl_data as (
    select KEGG, Mean AS CN_Mean
    from {{ source('staging_MDG', 'CN_O610_NaCl') }}
)
select E.KEGG, E.E_Mean, PA.PA_Mean, CN.CN_Mean,(E.E_Mean + PA.PA_Mean + CN.CN_Mean) / 3 as AVEG
from E_O610_NaCl_data E
inner join PA_O610_NaCl_data PA on E.KEGG = PA.KEGG
inner join CN_O610_NaCl_data CN on E.KEGG = CN.KEGG
ORDER BY AVEG DESC