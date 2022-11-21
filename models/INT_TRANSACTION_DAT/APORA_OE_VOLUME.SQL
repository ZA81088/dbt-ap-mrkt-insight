{{ 
    config (materialized = 'table', schema = 'INT_TRANSACTION_DAT' )
}}

WITH CTE AS (
SELECT * FROM APITDBDEV.STAGING.APORA_OE_VOLUME
)

SELECT * FROM CTE