{{ 
    config (materialized = 'table', schema = 'EXT_INDUSTRY_DAT' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBDEV.STAGING.APORA_INDUSTRY_SALES_FRCST
)

SELECT * FROM CTE