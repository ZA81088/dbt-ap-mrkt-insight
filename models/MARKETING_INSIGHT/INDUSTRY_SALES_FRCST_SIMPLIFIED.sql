{{ 
    config (materialized = 'view', schema = 'MARKETING_INSIGHT' )
}}

WITH CTE AS (
SELECT 
       REGION,
       COUNTRY,
       MARKET,
       sales_group AS OEMGroup,
       sales_brand AS Brand,
       sales_nameplate AS Model,
       CONCAT(price_segment,' ', oe_segment) AS OESegment,
       CONCAT(price_segment,' ', re_segment) AS RESegment,
       ROF,
       OE_ORIGIN AS OEOrigin,
       TIRESIZE,
       RIMSIZE,
       CONCAT(RIMSIZE, '"') AS RIMSIZEINCH, 
       CASE WHEN RIMSIZE >= 17 THEN '17+'
            ELSE '16-' END AS RimGroup,
       SELLING_PRICE_10K_RMB_MEDIAN AS SellingPrice10KRMB,
       //CASE WHEN SELLING_PRICE_10K_RMB_MEDIAN <= 15 THEN '150,000 AND BELOW'
       //     WHEN 15 < SELLING_PRICE_10K_RMB_MEDIAN <= 30 THEN '150,000 - 30,000'
       //     WHEN 30 < SELLING_PRICE_10K_RMB_MEDIAN <= 50 THEN '300,000 - 50,000'
       //     WHEN 50 < SELLING_PRICE_10K_RMB_MEDIAN <= 100 THEN '500,000 - 100,000'
       //     WHEN 100 < SELLING_PRICE_10K_RMB_MEDIAN <= 200 THEN '1000,000 - 200,000'
       //     WHEN 200 < SELLING_PRICE_10K_RMB_MEDIAN <= 300 THEN '2000,000 - 300,000'
       //     WHEN SELLING_PRICE_10K_RMB_MEDIAN > 300 THEN '3000,000 ABOVE'
       //     END AS CarValue,
       FUEL_TYPE AS FuelType,
       MEASURE_YEAR AS MeasureYear,
       trim_sales AS NewCarSales,
       repl_market AS ReplacementMarket,
       oe_market AS OEMarket,
       car_parc_scrap_pct AS CarParc
       //LAG(car_parc_scrap_pct, 1, NULL) OVER (PARTITION BY INDUSTRY_SALES_FRCST_TABLE_ID ORDER BY MEASURE_YEAR) AS PreviousYearCarParc,
       //LEAD(car_parc_scrap_pct, 4, NULL) OVER (PARTITION BY INDUSTRY_SALES_FRCST_TABLE_ID ORDER BY MEASURE_YEAR) AS FutureFiveYearsCarParc
FROM APITDBDEV.TRANSACTION_DATA.INDUSTRY_SALES_FRCST
)
SELECT Region,
       Country,
       Market,
       OEMGroup,
       Brand,
       Model,
       OESegment,
       RESegment,
       ROF,
       OEOrigin,
       TIRESIZE,
       RIMSIZE,
       RIMSIZEINCH,
       RimGroup,
       SellingPrice10KRMB,
       //CarValue,
       FuelType,
       MeasureYear,
       NewCarSales,
       ReplacementMarket,
       OEMarket,
       CarParc
       //PreviousYearCarParc,
       //FutureFiveYearsCarParc,
       //CASE WHEN PreviousYearCarParc IN (NULL, 0) THEN NULL
       //     ELSE TO_DECIMAL((CarParc - PreviousYearCarParc)/PreviousYearCarParc, 10,4) END AS CarParcGR,
       //CASE WHEN CarParc IN (NULL,0) THEN NULL
       //     ELSE TO_DECIMAL(POW(FutureFiveYearsCarParc/CarParc,0.2), 6,4) END AS CarParcCAGR
       //     ELSE -TO_DECIMAL(POW(PreviousFiveYearsCarParc - CarParc,0.2), 10,4) END AS CarParcCAGR
FROM CTE
