{{ 
    config (materialized = 'table', schema = 'INT_MASTER_DAT' )
}}

WITH CTE AS (
SELECT * FROM APITDBDEV.STAGING.RTM_MASTER_CUSTOMER
)

SELECT * FROM CTE