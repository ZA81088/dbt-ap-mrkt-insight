{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' , 
    post_hook = " {{ merge_oevolumne() }} ")
}}


SELECT COUNTRY,
       REGION,
       SALES_BRAND AS CARBRAND,
       SALES_NAMEPLATE AS CARMODEL,
       FUEL_TYPE AS FUELTYPE,
       TIRESIZE,
       RIMSIZE,
       ROF,
       CONCAT(PRICE_SEGMENT,' ',OE_SEGMENT) AS CarSegment, 
       OE_ORIGIN AS OEORIGIN,
       SUM(OE_MARKET) OEMARKET,
       0::DOUBLE AS GYVOLUME,
       0::DOUBLE AS CPVOLUME,
       MEASURE_YEAR AS MeasureYear
FROM {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.TRANSACTION_DATA.INDUSTRY_SALES_FRCST
GROUP BY COUNTRY,
         REGION,
         SALES_BRAND,
         SALES_NAMEPLATE,
         FUEL_TYPE,
         TIRESIZE,
         RIMSIZE,
         ROF,
         CONCAT(PRICE_SEGMENT,' ',OE_SEGMENT),
         OE_ORIGIN,
         MEASURE_YEAR
