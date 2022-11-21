{{ 
    config (materialized = 'table', schema = 'INT_TRANSACTION_DAT' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGING.RTM_MASTER_LEADTIME
)

SELECT * FROM CTE