{{ 
    config (materialized = 'table', schema = 'MASTER_DATA' )
}}

WITH CTE AS (
SELECT * FROM APITDBPRD.STAGING.EDW_MATERIALSALES
)

SELECT * FROM CTE