{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGING.TECA_INDUSTRY_SALES_FRCST_CITY
)

SELECT * FROM CTE