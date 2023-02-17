{{ 
    config (materialized = 'table', schema = 'MASTER_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.STAGING.MANUAL_PRODUCT
)

SELECT * FROM CTE