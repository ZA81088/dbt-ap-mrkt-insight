{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGING.REPL_VOLUME
)

SELECT * FROM CTE