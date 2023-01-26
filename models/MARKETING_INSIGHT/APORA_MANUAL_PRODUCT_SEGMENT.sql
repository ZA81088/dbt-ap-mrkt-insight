{{ 
    config (materialized = 'table', schema = 'MARKETING_INSIGHT' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBPRD.STAGING.MANUAL_PRODUCT_SEGMENT
)

SELECT * FROM CTE