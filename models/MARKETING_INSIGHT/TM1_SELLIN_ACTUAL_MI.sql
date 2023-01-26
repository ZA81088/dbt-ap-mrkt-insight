{{ 
    config (alias= 'TM1_SELLIN_ACTUAL' , materialized = 'table', schema = 'MARKETING_INSIGHT' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBPRD.INT_TRANSACTION_DAT.TM1_SELLIN_ACTUAL
)

SELECT * FROM CTE