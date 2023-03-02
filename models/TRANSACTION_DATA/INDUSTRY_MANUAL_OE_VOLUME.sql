{{ 
    config (materialized = 'table', schema = 'TRANSACTION_DATA' )
}}

WITH CTE AS (
SELECT COUNTRY,
       REGION,
       SALES_BRAND,
       SALES_NAMEPLATE,
       FUEL_TYPE,
       TIRESIZE,
       RIMSIZE,
       ROF,
       CONCAT(PRICE_SEGMENT,' ',OE_SEGMENT), 
       OE_ORIGIN,
       SUM(OE_MARKET),
       MEASURE_YEAR
FROM APITDBDEV.TRANSACTION_DATA.INDUSTRY_SALES_FRCST
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
         MEASURE_YEAR;

MERGE INTO TRANSACTION_DATA.INDUSTRY_MANUAL_OE_VOLUME s
USING (WITH OEGY AS (
SELECT 
    TIRESIZE AS SIZE,
    RIMSIZE AS RIM,
    CASE WHEN TECH = 'ROF' THEN TRUE
         ELSE FALSE END AS ROF,
    CONCAT(PRICE_SEGMENT,' ', PRODUCT_SEGMENT) AS CarSegment,
    BRAND_COUNTRY_OF_ORIGIN AS OEOrigin,
    IHS_BRAND AS Brand,
    IHS_MODEL AS Model,
    FUEL_TYPE AS FuelType,
    VOLUME,
    VOLUME_YEAR AS VolumeYear
FROM APITDBDEV.TRANSACTION_DATA.MANUAL_OE_VOLUME
WHERE TYRE_BRAND = 'Goodyear'
),
OEGYSUM AS (
SELECT 
    SUM(VOLUME) AS VOLUME,
    SIZE,
    RIM,
    ROF,
    CarSegment,
    OEOrigin,
    Brand,
    Model,
    FuelType,
    VolumeYear
FROM OEGY
GROUP BY
    SIZE,
    RIM,
    ROF,
    CarSegment,
    OEOrigin,
    Brand,
    Model,
    FuelType,
    VolumeYear
)
SELECT * FROM OEGYSUM) d
ON s.CARBRAND = d.BRAND AND s.CARMODEL = d.MODEL AND s.TIRESIZE = d.SIZE AND s.RIMSIZE = d.RIM
   AND s.ROF = d.ROF AND s.CarSegment = d.CarSegment AND s.MeasureYear = d.VolumeYear AND s.OEOrigin = d.OEOrigin
   AND s.FuelType = d.FuelType
WHEN MATCHED THEN UPDATE SET
    s.GYVOLUME = d.VOLUME
WHEN NOT MATCHED THEN
    INSERT (
        COUNTRY,
        REGION,
	    CARBRAND,
	    CARMODEL,
        FUELTYPE,
        TIRESIZE,
        RIMSIZE,
        ROF,
        CarSegment,
        OEOrigin,
	    OEMARKET,
        GYVOLUME,
        MeasureYear
    )
    VALUES(
        'Mainland China',
        'Greater China',
        d.BRAND,
        'Unmatched',
        d.FUELTYPE,
        d.SIZE,
        d.RIM,
        d.ROF,
        d.CarSegment,
        d.OEOrigin,
        0,
        d.VOLUME,
        d.VOLUMEYEAR    
    );

MERGE INTO TRANSACTION_DATA.INDUSTRY_MANUAL_OE_VOLUME s
USING (WITH OECP AS (
SELECT 
    TIRESIZE AS SIZE,
    RIMSIZE AS RIM,
    CASE WHEN TECH = 'ROF' THEN TRUE
         ELSE FALSE END AS ROF,
    CONCAT(PRICE_SEGMENT,' ', PRODUCT_SEGMENT) AS CarSegment,
    BRAND_COUNTRY_OF_ORIGIN AS OEOrigin,
    IHS_BRAND AS Brand,
    IHS_MODEL AS Model,
    FUEL_TYPE AS FUELTYPE,
    VOLUME,
    VOLUME_YEAR AS VolumeYear
FROM APITDBDEV.TRANSACTION_DATA.MANUAL_OE_VOLUME
WHERE TYRE_BRAND = 'Cooper'
),
OECPSUM AS (
SELECT 
    SUM(VOLUME) AS VOLUME,
    SIZE,
    RIM,
    ROF,
    CarSegment,
    OEOrigin,
    Brand,
    Model,
    FUELTYPE,
    VolumeYear
FROM OECP
GROUP BY
    SIZE,
    RIM,
    ROF,
    CarSegment,
    OEOrigin,
    Brand,
    Model,
    FUELTYPE,
    VolumeYear
)
SELECT * FROM OECPSUM) d
ON s.CARBRAND = d.BRAND AND s.CARMODEL = d.MODEL AND s.TIRESIZE = d.SIZE AND s.RIMSIZE = d.RIM
   AND s.ROF = d.ROF AND s.CarSegment = d.CarSegment AND s.MeasureYear = d.VolumeYear AND s.OEOrigin = d.OEOrigin
   AND s.FUELTYPE = d.FUELTYPE
WHEN MATCHED THEN UPDATE SET
    s.CPVOLUME = d.VOLUME
WHEN NOT MATCHED THEN
    INSERT (
        COUNTRY,
        REGION,
	    CARBRAND,
	    CARMODEL,
        FUELTYPE,
        TIRESIZE,
        RIMSIZE,
        ROF,
        CarSegment,
        OEOrigin,
	    OEMARKET,
        CPVOLUME,
        MeasureYear
    )
    VALUES(
        'Mainland China',
        'Greater China',
        d.BRAND,
        'Unmatched',
        d.FUELTYPE,
        d.SIZE,
        d.RIM,
        d.ROF,
        d.CarSegment,
        d.OEOrigin,
        0,
        d.VOLUME,
        d.VOLUMEYEAR    
    )
)

SELECT * FROM CTE