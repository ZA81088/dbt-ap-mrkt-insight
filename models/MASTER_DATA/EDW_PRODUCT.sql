{{ 
    config (materialized = 'table', schema = 'MASTER_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGING.EDW_PRODUCT
)

SELECT * FROM CTE