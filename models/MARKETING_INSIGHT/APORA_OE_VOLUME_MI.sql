{{ 
    config (alias= 'APORA_OE_VOLUME' , materialized = 'table', schema = 'MARKETING_INSIGHT' )
}}

WITH CTE AS (
SELECT * FROM 
    APITDBPRD.EXT_INDUSTRY_DAT.APORA_OE_VOLUME
)

SELECT * FROM CTE