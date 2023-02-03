{{ 
    config ( materialized = 'incremental', schema = 'TRANSACTION_DATA')
}}

WITH CHINA_MATERIALSALES AS (
SELECT *
FROM APITDBDEV.MASTER_DATA.EDW_MATERIALSALES
WHERE SALESORGCODE = 'A710' AND DISTRIBUTIONCHANNELCODE = '11'    
),
CTE AS (
SELECT A.PRODUCT_SIZE,
       C.BRANDNAME AS TIREBRAND,
       C.RIMDIAMETERINCHES AS RIMSIZE,
       C.DESIGN AS PATTERN,
       A.QUANTITY,
       A.ORDER_NO,
       A.SAP_PRODUCT_CODE,
       A.SP_CONFIRM_TIME,
       A.ARRIVED_TIME,
       C.MATERIALNAME AS PRODUCT_NAME,
       D.MATERIALSOURCECOUNTRYNAME AS COUNTRY_OF_ORIGIN,
       (B.PROCESS_LEAD_TIME + B.TRANSPORTATION_LEAD_TIME) * 60 AS LEAD_TIME,
       TIMEDIFF(SECOND, A.SP_CONFIRM_TIME, A.ARRIVED_TIME) AS ARRIVE_TIME,
       CAST(CONCAT(YEAR(A.ARRIVED_TIME), '-', MONTH(A.ARRIVED_TIME), '-01') AS DATE) AS REPORT_DATE,
       B.SERVICE_PROVIDER_CODE_GY AS SP
FROM APITDBDEV.TRANSACTION_DATA.RTM_SALESORDER A
LEFT JOIN APITDBDEV.TRANSACTION_DATA.RTM_LEADTIME B
ON A.SAPCODE = B.RETAILCODE AND A.SPCODE = B.SERVICE_PROVIDER_CODE_WC
LEFT JOIN APITDBDEV.MASTER_DATA.EDW_PRODUCT c
ON A.SAP_PRODUCT_CODE = C.MATERIALID 
LEFT JOIN CHINA_MATERIALSALES d
ON A.SAP_PRODUCT_CODE = D.MATERIALID
WHERE A.ARRIVED_TIME IS NOT NULL AND A.ORDER_STATUS IN ('Finished 已完成', 'Arrived 已送达') AND B.PROCESS_LEAD_TIME + B.TRANSPORTATION_LEAD_TIME != 0  
),
ONTIME_DELIVERY AS (
SELECT REPORT_DATE,
       SP,
       PRODUCT_SIZE,
       PRODUCT_NAME,
       COUNTRY_OF_ORIGIN,
       TIREBRAND,
       RIMSIZE,
       PATTERN,
       SUM(CASE WHEN ARRIVE_TIME <= LEAD_TIME THEN QUANTITY ELSE 0 END) AS ONTIME_QUANTITY
FROM CTE
GROUP BY REPORT_DATE,
       SP,
       PRODUCT_SIZE,
       PRODUCT_NAME,
       COUNTRY_OF_ORIGIN,
       TIREBRAND,
       RIMSIZE,
       PATTERN
  
),
ALL_DELIVERY AS (
SELECT REPORT_DATE,
       SP,
       PRODUCT_SIZE,
       PRODUCT_NAME,
       COUNTRY_OF_ORIGIN,
       TIREBRAND,
       RIMSIZE,
       PATTERN,
      
       SUM(QUANTITY) AS ALL_QUANTITY
FROM CTE
GROUP BY REPORT_DATE,
       SP,
       PRODUCT_SIZE,
       PRODUCT_NAME,
       COUNTRY_OF_ORIGIN,
       TIREBRAND,
       RIMSIZE,
       PATTERN
      
)
SELECT 'AP' AS REGION,
       'China' AS CLUSTER,
       'China' AS COUNTRY_NAME,
       'Consumer' AS PBU,
       'Consumer' AS "PBU-1",
       'RE' AS Channel,
       'RTM' AS CONSUMER_GROUP,
       A.TIREBRAND AS BRAND,
       A.RIMSIZE,
       A.PATTERN,
     
       A.COUNTRY_OF_ORIGIN,
       A.SP AS SERVICE_PROVIDER,
       NULL AS ROOT_CAUSE_L1,
       NULL AS ROOT_CAUSE_L2,
       A.REPORT_DATE AS MONTH_1,
       A.ALL_QUANTITY AS ORDER_QUANTITY,
       B.ONTIME_QUANTITY AS ORDER_QUANTITY_ON_TIME,
       A.ALL_QUANTITY - B.ONTIME_QUANTITY AS ORDER_QUANTITY_LATE
FROM ALL_DELIVERY a
LEFT JOIN ONTIME_DELIVERY b
ON A.REPORT_DATE = B.REPORT_DATE AND
   A.SP = B.SP AND A.PRODUCT_SIZE =B.PRODUCT_SIZE AND A.PRODUCT_NAME = B.PRODUCT_NAME AND
   A.TIREBRAND = B.TIREBRAND AND A.COUNTRY_OF_ORIGIN = B.COUNTRY_OF_ORIGIN

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run

  where (MONTH(MONTH_1) = MONTH(CURRENT_DATE()) - 1) 
        AND YEAR(MONTH_1) = YEAR(CURRENT_DATE())

  
{% endif %}
   
