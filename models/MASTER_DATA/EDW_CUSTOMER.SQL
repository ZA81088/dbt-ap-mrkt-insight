{{ 
    config (materialized = 'table', schema = 'MASTER_DATA' )
}}

WITH CTE AS (
SELECT * FROM APITDBDEV.STAGING.EDW_CUSTOMER
)

SELECT * FROM CTE