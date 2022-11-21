{{ 
    config (materialized = 'table', schema = 'INT_MASTER_DAT' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGING.EDW_MASTER_PRODUCT
)

SELECT * FROM CTE