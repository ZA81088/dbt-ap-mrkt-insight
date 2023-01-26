{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGING.RTM_SALESORDER
)

SELECT * FROM CTE