{{ 
    config (materialized = 'table', schema = 'MASTER_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.STAGING.EDW_PRODUCT
)

SELECT * FROM CTE