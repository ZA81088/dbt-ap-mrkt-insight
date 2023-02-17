{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
     {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.STAGING.TECA_INDUSTRY_SALES_FRCST
)

SELECT * FROM CTE