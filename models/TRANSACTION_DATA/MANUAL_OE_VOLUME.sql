{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
     {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.STAGING.MANUAL_OE_VOLUME
)

SELECT * FROM CTE