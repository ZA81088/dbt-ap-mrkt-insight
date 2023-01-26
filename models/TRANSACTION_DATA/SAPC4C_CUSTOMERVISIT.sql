{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGING.SAPC4C_CUSTOMERVISIT
)

SELECT * FROM CTE