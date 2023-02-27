{{ 
    config (materialized = 'view', schema = 'MARKETING_INSIGHT' )
}}

WITH CTE AS (
SELECT INDUSTRY_SALES_FRCST_CITY_TABLE_ID,
       COUNTRY,
       PROVINCE,
       CITY,
       GY_CITY_TIER AS GoodyearCityTier,
       sales_group AS OEMGroup,
       sales_group_chinese AS OEMGroupChinese,
       sales_brand AS Brand,
       sales_brand_chinese AS BrandChinese,
       sales_nameplate AS Model,
       sales_nameplate_chinese AS ModelChinese,
       oe_segment AS OESegment,
       re_segment AS RESegment,
       ROF,
       OE_ORIGIN AS OEOrigin,
       CASE WHEN TIRESIZE ='-' THEN NULL
            ELSE TIRESIZE END AS TIRESIZE,
       CASE WHEN RIMSIZE = '-' THEN NULL
            ELSE RIMSIZE END AS RIMSIZE,
       CASE WHEN RIMSIZE = '-' THEN NULL
            ELSE CONCAT(RIMSIZE, '"') END AS RIMSIZEINCH,
       CASE WHEN RIMSIZE IN (NULL, '-') THEN NULL
            WHEN RIMSIZE >= 17 THEN '17+'
            ELSE '16-' END AS RimGroup,
       SELL_PRICE_GREATER_EQ_150K,
       SELL_PRICE_GREATER_EQ_200K,
       FUEL_TYPE AS FuelTypeChinese,
       CASE WHEN FUEL_TYPE = '汽油' THEN 'Petrol'
            WHEN FUEL_TYPE = '纯电动' THEN 'Electric'
            WHEN FUEL_TYPE = '插电式混合动力' THEN 'Plug-in Hybrid'
            WHEN FUEL_TYPE = '柴油' THEN 'Diesel'
            WHEN FUEL_TYPE = '汽油混合动力' THEN 'Petrol Full Hybrid'
            WHEN FUEL_TYPE = '汽油(48V轻混)' THEN 'Petrol(48V MHEV)'
            WHEN FUEL_TYPE = '增程式电动' THEN 'EREV'
            WHEN FUEL_TYPE = '柴油油电混合' THEN 'Diesel Full Hybrid'
            ELSE NULL END AS FuelType,
       MEASURE_YEAR AS MeasureYear,
       cy AS NewCarSales,
       repl_market AS ReplacementMarket,
       oe_market AS OEMarket,
       car_parc_scrap_pct AS CarParc
       //LAG(car_parc_scrap_pct, 1, NULL) OVER (PARTITION BY INDUSTRY_SALES_FRCST_CITY_TABLE_ID ORDER BY MEASURE_YEAR) AS PreviousYearCarParc,
       //Lead(car_parc_scrap_pct, 4, NULL) OVER (PARTITION BY INDUSTRY_SALES_FRCST_CITY_TABLE_ID ORDER BY MEASURE_YEAR) AS FutureFiveYearsCarParc
FROM {{ env_var('DBT_SOURCE_DATABASE', 'APITDBDEV') }}.TRANSACTION_DATA.INDUSTRY_SALES_FRCST_CITY
WHERE PICKUP_TRUCK_TO_REMOVE = FALSE
)
SELECT Country,
       Province,
       City,
       GoodyearCityTier,
       OEMGroup,
       OEMGroupChinese,
       Brand,
       BrandChinese,
       Model,
       ModelChinese,
       OESegment,
       RESegment,
       ROF,
       OEOrigin,
       TIRESIZE,
       RIMSIZE,
       RIMSIZEINCH,
       RimGroup,
       SELL_PRICE_GREATER_EQ_150K,
       SELL_PRICE_GREATER_EQ_200K,
       FuelTypeChinese,
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
