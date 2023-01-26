{{ 
    config (materialized = 'table', schema = 'MASTER_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGING.MANUAL_PRODUCT_SEGMENT
)

SELECT * FROM CTE