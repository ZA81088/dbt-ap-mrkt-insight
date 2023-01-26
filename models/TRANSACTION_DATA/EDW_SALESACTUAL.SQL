{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM APITDBDEV.STAGING.EDW_SALESACTUAL
)

SELECT * FROM CTE