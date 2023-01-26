{{ 
    config (alias = 'EDW_MASTER_CUSTOMER' , materialized = 'table', schema = 'MARKETING_INSIGHT' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBPRD.INT_MASTER_DAT.EDW_MASTER_CUSTOMER
)

SELECT * FROM CTE