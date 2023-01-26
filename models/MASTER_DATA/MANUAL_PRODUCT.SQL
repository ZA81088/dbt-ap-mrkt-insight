{{ 
    config (materialized = 'table', schema = 'MASTER_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBPRD.STAGING.MANUAL_PRODUCT
)

SELECT * FROM CTE