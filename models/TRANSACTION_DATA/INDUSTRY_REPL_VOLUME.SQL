{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' , 
    post_hook = " {{ merge_replvolumne() }} ")
}}

SELECT COUNTRY,
       REGION,
       TIRESIZE,
       RIMSIZE,
       CONCAT(PRICE_SEGMENT,' ',RE_SEGMENT) AS CARSEGMENT, 
       'dummy' AS VERSION,
       SUM(REPL_MARKET) AS REPLMARKET,
        0::DOUBLE AS GYVOLUME,
       0::DOUBLE AS CPVOLUME,
       MEASURE_YEAR AS MEASUREYEAR
FROM {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.TRANSACTION_DATA.INDUSTRY_SALES_FRCST
GROUP BY COUNTRY,
         REGION,
         TIRESIZE,
         RIMSIZE,
         CONCAT(PRICE_SEGMENT,' ',RE_SEGMENT),
         MEASURE_YEAR