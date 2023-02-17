{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.STAGING.EDW_SALESACTUAL
)

SELECT * FROM CTE