{{ 
    config (materialized = 'view', schema = 'MARKETING_INSIGHT' )
}}

WITH CTE AS (
    SELECT COUNTRY,
           REGION,
           CARBRAND,
           CARMODEL,
           FUELTYPE,
            TIRESIZE,
            RIMSIZE,
            CONCAT(RIMSIZE,'"') AS RIM,
            CASE WHEN RIMSIZE >=18 THEN '18+'
                 ELSE '17-' END AS RIMGROUP,
            ROF,
            CARSEGMENT,
            OEORIGIN,
            OEMARKET,
            GYVOLUME,
            CASE WHEN YEAR(MEASUREYEAR)<2021 THEN 0
                 ELSE CPVOLUME END AS CPVOLUME,
            MEASUREYEAR
    FROM APITDBPRD.MARKETING_INSIGHT.OE_VOLUME
    WHERE MEASUREYEAR <= (
        SELECT MAX(VOLUME_YEAR)
        FROM APITDBPRD.STAGING.APORA_OE_VOLUME
        WHERE TYRE_BRAND = 'Goodyear')
    AND MEASUREYEAR >= (
        SELECT MIN(MEASURE_YEAR)
        FROM APITDBPRD.STAGING.APORA_INDUSTRY_SALES_FRCST
    )
)   
SELECT * FROM CTE