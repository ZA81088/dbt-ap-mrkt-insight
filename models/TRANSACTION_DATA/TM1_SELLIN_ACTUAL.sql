{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
     {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.STAGE.TM1_SELLIN_ACTUAL
)

SELECT * FROM CTE