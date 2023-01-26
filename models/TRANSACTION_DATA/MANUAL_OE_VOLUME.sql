{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBPRD.STAGING.MANUAL_OE_VOLUME
)

SELECT * FROM CTE