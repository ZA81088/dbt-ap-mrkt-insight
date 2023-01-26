{{ 
    config ( materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGING.MANUAL_INDUSTRY_SIZE
)

SELECT * FROM CTE