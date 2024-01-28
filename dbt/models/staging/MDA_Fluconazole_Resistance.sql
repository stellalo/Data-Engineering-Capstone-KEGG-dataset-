{{ config(materialized='view') }}

with E_Fluconazole_Resistance_data as (
    select KEGG, Mean as E_Mean
    from {{ source('staging', 'E_Fluconazole_Resistan') }}
), 
PA_Fluconazole_Resistance_data as (
    select KEGG, Mean as PA_Mean
    from {{ source('staging', 'PA_Fluconazole_Resistance') }}
),
CN_Fluconazole_Resistance_data as (
    select KEGG, Mean AS CN_Mean
    from {{ source('staging', 'CN_Fluconazole_Resistan') }}
)
select E.KEGG, E.E_Mean, PA.PA_Mean, CN.CN_Mean,(E.E_Mean + PA.PA_Mean + CN.CN_Mean) / 3 as AVEG
from E_Fluconazole_Resistance_data E
inner join PA_Fluconazole_Resistance_data PA on E.KEGG = PA.KEGG
inner join CN_Fluconazole_Resistance_data CN on E.KEGG = CN.KEGG
ORDER BY AVEG DESC