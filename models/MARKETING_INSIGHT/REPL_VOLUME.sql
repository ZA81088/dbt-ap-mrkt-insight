{{ 
    config (materialized = 'table', schema = 'MARKETING_INSIGHT' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBPRD.STAGING.REPL_VOLUME
)

SELECT * FROM CTE