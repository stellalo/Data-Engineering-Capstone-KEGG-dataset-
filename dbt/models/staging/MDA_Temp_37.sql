{{ config(materialized='view') }}

with E_Temp_37_data as (
    select KEGG, Mean as E_Mean
    from {{ source('staging', 'E_Temp_37') }}
), 
PA_Temp_37_data as (
    select KEGG, Mean as PA_Mean
    from {{ source('staging', 'PA_Temp_37') }}
),
CN_Temp_37_data as (
    select KEGG, Mean AS CN_Mean
    from {{ source('staging', 'CN_Temp_37') }}
)
select E.KEGG, E.E_Mean, PA.PA_Mean, CN.CN_Mean,(E.E_Mean + PA.PA_Mean + CN.CN_Mean) / 3 as AVEG
from E_Temp_37_data E
inner join PA_Temp_37_data PA on E.KEGG = PA.KEGG
inner join CN_Temp_37_data CN on E.KEGG = CN.KEGG
ORDER BY AVEG DESC

-- from (
--     select KEGG, E_Mean from E_Temp_37_data
--     union all
--     select KEGG, PA_Mean from PA_Temp_37_data
--     union all
--     select KEGG, CN_Mean from CN_Temp_37_data
-- ) combined_data
-- group by KEGG;

-- select * from E_Temp_37_data INTERSECT DISTINCT select * from PA_Temp_37_data  INTERSECT DISTINCT select * from CN_Temp_37_data

-- select * from {{ source('staging', 'E_Temp_37') }}

-- select
--   KEGG,
--   Mean
--   from {{ source('staging', 'E_Temp_37') }}




