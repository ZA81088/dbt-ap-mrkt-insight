{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGE.TM1_SELLIN_ACTUAL
)

SELECT * FROM CTE